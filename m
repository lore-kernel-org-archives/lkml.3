Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3JVRG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:06:27 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40774 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3JVRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:06:25 -0400
Date: Tue, 22 Oct 2013 18:06:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
Message-ID: <20131022170621.GB2620@lee--X1>
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com>
 <20130807084054.GA18668@lee--X1>
 <52667A6C.6000301@linutronix.de>
 <20131022160523.GB24024@lee--X1>
 <5266AA0F.1030603@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5266AA0F.1030603@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013, Sebastian Andrzej Siewior wrote:

> On 10/22/2013 06:05 PM, Lee Jones wrote:
> >> I added reg_se_cache to cache the content of REG_SE once and
> >> synchronize it among TSC & ADC access. REG_SE is set to 0 by the HW
> >> after "work" has been done. So you need to know the old value or TSC may
> >> disable ADC and the other way around.
> > 
> > Yep, it's initialised as '0'.
> > 
> > 12.5.1.15 STEPENABLE Register (offset = 54h) [reset = 0h]
> 
> Ehm yes but!. After init it is set to 0, correct. The value was never
> read from the HW. It was always set via  am335x_tsc_se_set() to "cache
> | argument" and written to HW from both sides (TSC, ADC). This
> initialization is done at ->probe() time in both drivers.
> 
> The value remains (remained) constant over the whole time
> so both drivers only called am335x_tsc_se_update() to set the value
> (the enabled steps of both sides) back to the register (because after
> the conversation the value was 0 according to my memory) and since
> 32bit reads are atomic I didn't use a lock here.

Hmm.. I'm starting to see what you mean.

So what's the point of the read before write then?

Why don't you use the cache all of the time?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
