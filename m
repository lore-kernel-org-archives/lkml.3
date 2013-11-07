Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3KGOFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:05:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60984 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab3KGOF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:05:29 -0500
Message-ID: <527B9E1A.7000002@ti.com>
Date: Thu, 7 Nov 2013 19:35:14 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: call try_to_freeze only
 when its safe
References: <1383831439-25558-1-git-send-email-george.cherian@ti.com> <527B9A7F.8000006@linutronix.de>
In-Reply-To: <527B9A7F.8000006@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/2013 7:19 PM, Sebastian Andrzej Siewior wrote:
> On 11/07/2013 02:37 PM, George Cherian wrote:
>> Call try_to_freeze() in sleep_thread() only when its safe to sleep.
>> do_read() and do_write() calls sleep_thread with lock held.
>> Make sure these wont call try_to_freeze() by passing can_freeze flag
>> to sleep_thread.
> Thank you. This is was Alan asked for and I forgot.
>
> You could add
>
> |Calling try_to_freeze() with a lock hold was done since day one in
> |f_mass_storage but since commit 0f9548ca1 ("lockdep: check that no
> |locks held at freeze time") lockdep complains about it.
>
> so we have an explanation why it is suddenly a bad thing.

okay will send v2 with commit log amend and your Acked-by
>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> Sebastian


-- 
-George

