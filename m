Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaEFX4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:56:19 -0400
Received: from forward2m.mail.yandex.net ([37.140.138.2]:48868 "EHLO
	forward2m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaEFX4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:56:18 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2014 19:56:18 EDT
From: zbr@ioremap.net
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>, Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
In-Reply-To: <20140506234930.GU21508@spacedout.fries.net>
References: <20140501034759.GG5096@spacedout.fries.net>
	 <1399411564-16172-1-git-send-email-khoroshilov@ispras.ru> <20140506234930.GU21508@spacedout.fries.net>
Subject: Re: [PATCH v2] w1: do not unlock unheld list_mutex in __w1_remove_master_device()
MIME-Version: 1.0
Message-Id: <1240941399420266@web11m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 07 May 2014 03:51:06 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

07.05.2014, 03:49, "David Fries" <David@Fries.net>:
> Acked-by: David Fries <david@fries.net>
>
> On Wed, May 07, 2014 at 01:26:04AM +0400, Alexey Khoroshilov wrote:
>
>> šw1_process_callbacks() expects to be called with dev->list_mutex held,
>> šbut it is the fact only in w1_process(). __w1_remove_master_device()
>> šcalls w1_process_callbacks() after it releases list_mutex.
>>
>> šThe patch fixes __w1_remove_master_device() to acquire list_mutex
>> šfor w1_process_callbacks().
>>
>> šFound by Linux Driver Verification project (linuxtesting.org).
>>
>> šSigned-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks for this fix
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
