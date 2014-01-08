Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbaAHVCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:02:38 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59581 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756768AbaAHVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:02:36 -0500
Date: Wed, 8 Jan 2014 21:02:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
Message-ID: <20140108210228.GO27432@n2100.arm.linux.org.uk>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com> <20140108143529.GB14122@mudshark.cambridge.arm.com> <CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com> <20140108192028.GM27432@n2100.arm.linux.org.uk> <CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:43:29AM -0800, Doug Anderson wrote:
> Olof came up with the idea that you could update the RW firmware
> (affects initial boot) and then cache away the value and restore it in
> the kernel after resume.  That would still require a kernel patch but
> perhaps a less objectionable one.  ...of course if writing this
> register is a problem in secure mode then maybe that patch would be
> NAKed anyway.

It's not a problem in secure mode, since secure mode will have access
to the register.  It's the non-secure mode where various registers
either ignore writes, or they trigger an exception that are the problem.

Consider what would happen if an exception were to be triggered when no
exception handlers were installed (eg, because the MMU is not enabled.)

> That's one I didn't think about, you're right.  ...but we're really
> getting into hypothetical situations here.  Are there any r2p0
> products that have such a fix (and thus require a latency of >= 4)?

Really, we can't know, because this kind of information is dependent on
the SoC, and probably such customisations are only knowable via NDAs.

However, I do know of some A9 CPUs where exactly this kind of thing has
happened - where various selected silicon bugs have been fixed but the
revision still reports the same as one with all those bugs.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
