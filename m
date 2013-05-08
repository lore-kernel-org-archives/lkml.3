Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3EHAa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:30:57 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54713 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3EHAa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:30:56 -0400
Message-ID: <51899CBC.6020003@linaro.org>
Date: Tue, 07 May 2013 17:30:52 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: Arnd Bergmann <arnd@arndb.de>, tglx@linutronix.de,
        Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        kernel list <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
References: <20130426121433.GA16249@amd.pavel.ucw.cz> <201305061545.22587.arnd@arndb.de> <20130506155304.GA6645@amd.pavel.ucw.cz> <201305062324.17080.arnd@arndb.de> <20130507135752.GA3500@amd.pavel.ucw.cz> <51892E5E.8090909@linaro.org> <20130507201126.GA8169@amd.pavel.ucw.cz>
In-Reply-To: <20130507201126.GA8169@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 01:11 PM, Pavel Machek wrote:
> It seems we made a mistake when creating dw_apb_timer_of.c:
> picoxcell sched_clock had parts that were not related to
> dw_apb_timer, yet we moved them to dw_apb_timer_of, and tried to
> use them on socfpga.
>
> This results in system where user/system time is not measured
> properly, as demonstrated by
>      
>      time dd if=/dev/urandom of=/dev/zero bs=100000 count=100
>      
> So this patch switches sched_clock to hardware that exists on both
> platforms, and adds missing of_node_put() in dw_apb_timer_init().
>      
> Signed-off-by: Pavel Machek <pavel@denx.de>
> Acked-by: Jamie Iles <jamie@jamieiles.com>

Ok. I'm still not a happy about the general issue of 
sched_clock/clockevent code being in drivers/clocksources (I know, 
everyone is sick of my griping about it :), so reviewing this sucks, but 
at least this patch technically isn't making that issue worse.

Additionally, this is an *ugly* driver in my opinion. Its split between 
arch specific logic in arch/x86/kernel/apb_timer.c, 
arch/arm/mach-picoxcell/common.c, and arch/arm/mach-socfpga/socfpga.c, 
and then arch independent logic in drivers/clocksource/dw_apb_timer.c 
and drivers/clocksource/dw_apb_timer_of.c, but then it seems like much 
of drivers/clocksource/dw_apb_timer_of.c is actually ARM specific.

Are there any plans to clean this up in the future?

Also, next time please run checkpatch.pl to catch trivial issues like 
trailing whitespace. :P

But I've gone ahead and queued this for 3.11.

thanks
-john

