Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3GYPMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:12:38 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:40343 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130725144118.GA5412@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
	<CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
	<20130725144118.GA5412@linutronix.de>
Date: Thu, 25 Jul 2013 10:12:34 -0500
Message-ID: <CADYTM3bJZKUjgddP1pddZvqg7CfVyayxEXfBoJFrhean79+ykA@mail.gmail.com>
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Thu, Jul 25, 2013 at 9:41 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Bin Liu | 2013-07-23 13:23:57 [-0500]:
>
>>Hi Sebastian,
> Hi Liu,
>
>>On Mon, Jul 22, 2013 at 1:09 PM, Sebastian Andrzej Siewior <
>>bigeasy@linutronix.de> wrote:
>>
>>> This patch renames the type struct from ti81xx_driver_data to
>>> am33xx_driver_data since it is not used for ti81xx anymore. The EOI
>>> member is also removed since the am33xx SoC does not have such register.
>>> The interrupt is acknowledged by writting into the stat register.
>>>
>>I guess the EOI register is removed from the TRM because AM33xx does not
>>use it, there is no need to write to it to acknowledge. It does not hurt to
>>write to it though since the register still exists, it just does nothing, I
>>guess.
>
> Is it really there or was it never there and it has been added to TRM by
> accident?
The EOI register IS in the USB subsystem of AM33xx, but the SoC does
not use it because it uses level triggering for USB interrupt.

>
>>But I am not sure if it is a good idea to remove eoi from the musb_dsps
>>driver. If the intension is to merge the support for other SoC, such as
>>AM35xx, AM18xx, then EOI handling might be still needed. I just don't know
>>how those devices use EOI.
>
> If one of the architectures gets added which need an EOI then the offset
> can be 0 and the EOI will happen only if it is != 0.
This patch cleaned up the use of EOI. Do you mean EOI handling will be
added back with condition EOI offset != 0, when the support of new
device which uses EIO is added?

Regards,
-Bin.

>
>>
>>Regards,
>>-Bin.
>
> Sebastian
