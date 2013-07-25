Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3GYOlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:41:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:59352 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3GYOlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:41:19 -0400
Date: Thu, 25 Jul 2013 16:41:18 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Bin Liu <binmlist@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to
 am33xx_driver_data
Message-ID: <20130725144118.GA5412@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
 <CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bin Liu | 2013-07-23 13:23:57 [-0500]:

>Hi Sebastian,
Hi Liu,

>On Mon, Jul 22, 2013 at 1:09 PM, Sebastian Andrzej Siewior <
>bigeasy@linutronix.de> wrote:
>
>> This patch renames the type struct from ti81xx_driver_data to
>> am33xx_driver_data since it is not used for ti81xx anymore. The EOI
>> member is also removed since the am33xx SoC does not have such register.
>> The interrupt is acknowledged by writting into the stat register.
>>
>I guess the EOI register is removed from the TRM because AM33xx does not
>use it, there is no need to write to it to acknowledge. It does not hurt to
>write to it though since the register still exists, it just does nothing, I
>guess.

Is it really there or was it never there and it has been added to TRM by
accident?

>But I am not sure if it is a good idea to remove eoi from the musb_dsps
>driver. If the intension is to merge the support for other SoC, such as
>AM35xx, AM18xx, then EOI handling might be still needed. I just don't know
>how those devices use EOI.

If one of the architectures gets added which need an EOI then the offset
can be 0 and the EOI will happen only if it is != 0.

>
>Regards,
>-Bin.

Sebastian
