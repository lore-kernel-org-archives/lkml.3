Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaA0Gbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:31:39 -0500
Received: from mail.ispras.ru ([83.149.199.45]:33335 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaA0Gbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:31:38 -0500
Message-ID: <52E5FD48.7040208@ispras.ru>
Date: Mon, 27 Jan 2014 10:31:36 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] USB: input: gtco.c: fix usb_dev leak
References: <1390087466-9898-1-git-send-email-khoroshilov@ispras.ru> <20140121195957.GB29615@core.coreip.homeip.net>
In-Reply-To: <20140121195957.GB29615@core.coreip.homeip.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.01.2014 23:59, Dmitry Torokhov wrote:
> On Sun, Jan 19, 2014 at 03:24:26AM +0400, Alexey Khoroshilov wrote:
>> There is usb_get_dev() in gtco_probe(), but there is no usb_put_dev()
>> anywhere in the driver.
>>
>> The patch adds usb_get_dev() to failure handling code of gtco_probe()
>> and to gtco_disconnect(().
> Hmm, I think gtco should simply not use usb_get_dev() in the first
> place.
>
> Thanks.
Dear Dmitry,

Could you please clarify why usb_get_dev() not needed here?
We store reference to usb_dev in gtco structure, so we should refcount it.
What is wrong in this reasoning?

Thanks,
Alexey
