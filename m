Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3CRTit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:38:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59266 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab3CRTir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:38:47 -0400
Message-ID: <51476D3E.6010305@ti.com>
Date: Mon, 18 Mar 2013 15:38:38 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/8] staging: omap-thermal: use spin_lock_irqsave inside
 IRQ handler
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com> <1363618756-15851-3-git-send-email-eduardo.valentin@ti.com> <20130318191618.GU9138@mwanda>
In-Reply-To: <20130318191618.GU9138@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-03-2013 15:16, Dan Carpenter wrote:
> On Mon, Mar 18, 2013 at 10:59:10AM -0400, Eduardo Valentin wrote:
>> Even if the IRQ is not firing because it is ONE_SHOT and disable
>> at INTC level, the IRQ handler must use spin_lock_irqsave.
>> It is necessary to disable IRQs from the current
>> CPU while it is holding a spin_lock which is need.
>>
>
> Gar...  I think I was just totally wrong on this.  I think your
> original code was fine.  Sorry Eduardo and Greg.
>
> This is a threaded IRQ so the regular spin_lock is fine or even the
> mutex would have been.

In fact it is. But I rather prefer to use spinlocks there, just to keep 
the irq handler sane, even if it is moved to non-threaded IRQ.

>
> IRQ_ONESHOT is about triggering a second IRQ before the first one
> has been finished, btw.

It is, and that gets done by masking the IRQ at INTC level.

>
> I am an idiot.


Not really. Thanks for your time reviewing the driver.

  I will resend this series. Drop this one and split patch 4/8 into two 
I think (one for moving files, one for renaming functions)

>
> regards,
> dan carpenter
>
>
>

