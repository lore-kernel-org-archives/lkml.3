Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3AVAwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:52:03 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55256 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3AVAwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:52:01 -0500
Message-ID: <50FDE2AE.8030608@linaro.org>
Date: Mon, 21 Jan 2013 16:51:58 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Sealey <matt@genesi-usa.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
In-Reply-To: <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 02:54 PM, Matt Sealey wrote:
> On Mon, Jan 21, 2013 at 4:36 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 01/21/2013 01:14 PM, Matt Sealey wrote:
>>> My question really has to be is CONFIG_SCHED_HRTICK useful, what
>>> exactly is it going to do on ARM here since nobody can ever have
>>> enabled it? Is it going to keel over and explode if nobody registers a
>>> non-jiffies sched_clock (since the jiffies clock is technically
>>> reporting itself as a ridiculously high resolution clocksource..)?
>> ??? Not following this at all.  jiffies is the *MOST* coarse resolution
>> clocksource there is (at least that I'm aware of.. I recall someone wanting
>> to do a 60Hz clocksource, but I don't think that ever happened).
> Is that based on it's clocksource rating (probably worse than a real
> hrtimer) or it's reported resolution? Because on i.MX51 if I force it
> to use the jiffies clock the debug on the kernel log is telling me it
> has a higher resolution (it TELLS me that it ticks "as fast" as the
> CPU frequency and wraps less than my real timer).
So the clocksource rating is supposed to be defined by the clocksource 
driver writer, and just provides a way for the clocksource core to 
select the best clocksource given a set of clocksources. It is not 
defined as any sort of calculated mapping to any property of the 
clocksource itself (although some driver writers might compute a ratings 
value in that way, but I feel the static ranking is much simpler). The 
comment above struct clocksource in clocksource.h tries to explain this.

As far as jiffies rating, from jiffies.c:
     .rating        = 1, /* lowest valid rating*/

So I'm not sure what you mean by "the debug on the kernel log is telling 
me it has a higher resolution".



> I know where the 60Hz clocksource might come from, the old Amiga
> platforms have one based on the PSU frequency (50Hz in Europe, 60Hz
> US/Japan). Even a 60Hz clocksource is useful though (on the Amiga, at
> least, it is precisely the vsync clock for synchronizing your display
> output on TV-out, which makes it completely useful for the framebuffer
> driver), but.. you just won't expect to assign it as sched_clock or
> your delay timer. And if anyone does I'd expect they'd know full well
> it'd not run so well.

Yes, in the case I was remembering, the 60HZ was driven by the 
electrical line.

thanks
-john


