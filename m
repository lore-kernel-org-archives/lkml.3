Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab3GSPN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:13:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51784 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3GSPN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:13:28 -0400
Date: Fri, 19 Jul 2013 17:13:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
Message-ID: <20130719151321.GD19581@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
 <20130718225349.GD15992@pd.tnic>
 <20130719142628.GC19581@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130719142628.GC19581@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 04:26:28PM +0200, Borislav Petkov wrote:
> On Fri, Jul 19, 2013 at 12:53:49AM +0200, Borislav Petkov wrote:
> > > I assumed it was some sort of BIOS issue where any modification of the
> > > RTC_AIE bit caused the alarm irq line to be left high(or something
> > > like that) that triggered the immediate power-on on shutdown. But I've
> > > not been able to dig down on this.
> > 
> > Ha, this actually fits like an ass on a bucket (don't ask - German
> > proverb :-)).
> > 
> > If what you're saying is actually the case, then this explains why not
> > writing to 0xb doesn't cause the alarm irq to fire.
> > 
> > Btw, in the trace above we do the disabling twice. Once from
> > rtc_timer_remove() and then again from rtc_timer_do_work().
> > 
> > So, if we disable it once and we touch RTC_AIE again causing the second
> > time to rearm the alarm irq, this would explain the issue. Which reminds
> > me:
> > 
> > Maybe we should read out the alarm interrupt first and disable it only
> > if it is enabled - that would save us the modification of RTC_AIE. Cool,
> > I'll try that tomorrow.
> 
> Well, the below seems to do the trick. But since I don't trust the BIOS
> in any way, I'll run it a couple more days here. Btw, I think we should
> commit this regardless, as it saves us unneeded writes:

Nope, this doesn't help - box just rebooted. :(

So I'm back to the DMI quirk patch...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
