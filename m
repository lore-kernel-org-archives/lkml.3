Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3AKLnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:43:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33557 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab3AKLn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:43:29 -0500
Date: Fri, 11 Jan 2013 12:43:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Adrian Byszuk <adrian.byszuk@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
Message-ID: <20130111114328.GD6570@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sujith Manoharan <sujith@msujith.org>,
	Adrian Byszuk <adrian.byszuk@gmail.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>
References: <20130109120732.GA8016@liondog.tnic>
 <50ED98AA.1090304@gmail.com>
 <20130109170119.GA17840@liondog.tnic>
 <50EDB070.9020908@gmail.com>
 <20130109181520.GB17840@liondog.tnic>
 <50EE9F24.8010908@gmail.com>
 <20130110113511.GB23008@liondog.tnic>
 <50EECA0B.2050407@gmail.com>
 <50EEF8A9.5070406@gmail.com>
 <20719.47186.830126.689552@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20719.47186.830126.689552@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 12:29:30PM +0530, Sujith Manoharan wrote:
> Adrian Byszuk wrote:
> > Aaaand failure again!
> > I haven't finished bisecting yet, but as of now I have ~20 commits left:
> > all related to 'mtd' - propably not a source of troubles too.
> > Any other way to diagnose this bug?
> 
> I think this has been fixed by:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=3935e89505a1c3ab3f3b0c7ef0eae54124f48905
> 
> For Arch Linux, it was tracked here:
> https://bugs.archlinux.org/task/33095

Good point, thanks Sujith.

Commit message sounds exactly like your issue, Adrian, and oopsing in an
unitialized hrtimer - which this patch fixes - is what you see so you
could very well cherry pick this patch from Linus' tree and test.

Even though this patch is marked for stable, for some reason it didn't
make it into 3.7.1 and I can't find it in the 3.7.2 lineup either.
Strange.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
