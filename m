Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaCKXaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:30:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:8387 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbaCKXaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:30:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,634,1389772800"; 
   d="scan'208";a="490137636"
Date: Wed, 12 Mar 2014 07:30:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [powerpc:next 45/53] warning: (PPC_C2K && ..) selects
 NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || ..)
Message-ID: <20140311233009.GB8740@localhost>
References: <531acfa5.YesaRIJhSRvrw4/w%fengguang.wu@intel.com>
 <531DD0F4.6020000@windriver.com>
 <20140311045424.GB12373@localhost>
 <531F1E7D.5060309@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531F1E7D.5060309@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 10:32:29AM -0400, Paul Gortmaker wrote:
> On 14-03-11 12:54 AM, Fengguang Wu wrote:
> > On Mon, Mar 10, 2014 at 10:49:24AM -0400, Paul Gortmaker wrote:
> >> On 14-03-08 03:07 AM, kbuild test robot wrote:
> >>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next
> >>> head:   c7e64b9ce04aa2e3fad7396d92b5cb92056d16ac
> >>> commit: 3c8464a9b12bf83807b6e2c896d7e7b633e1cae7 [45/53] powerpc: Delete old PrPMC 280/2800 support
> >>> config: make ARCH=powerpc c2k_defconfig
> >>>
> >>> All warnings:
> >>>
> >>> warning: (PPC_C2K && AMIGAONE) selects NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON)
> >>
> >> This _looks_ like a new warning, but it really is not.  If you look
> >> at the tree prior to the above named commit, it generates this:
> >>
> >> $ make c2k_defconfig
> >> warning: (PPC_PRPMC2800 && PPC_C2K && AMIGAONE) selects NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON)
> >> warning: (PPC_PRPMC2800 && PPC_C2K && AMIGAONE) selects NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON)
> >> #
> >> # configuration written to .config
> >>
> >> So the warning is slightly different in text, but essentially
> >> the exact same thing that was being warned about before.  We've
> >> just removed one of the possible symbols from existence.
> > 
> > Yes, sorry, the kbuild robot is not smart enough to detect such
> > slightly changed error/warnings and will treat them as new ones.
> 
> No apology required.  I think we all appreciate the build test
> coverage, and I saw your mail where you said you sent out ~60
> reports yesterday- wow!

Paul, thank you!  But let me clarify it a bit.

The kernel test robots typically send out 30+ reports per day,
including build/boot error/warnings, performance/power/functional
regressions, and build test completion notifications.

The ~60 emails I mentioned are the ones that I write up in mutt,
most of them are on internal development and maintenance works of
the test infrastructure.

Thanks,
Fengguang

> Thanks,
> Paul.
> --
> 
> > 
> >> I'm not sure there would ever be a way to teach kbuild robot
> >> about something as subtle as the above; just one of the false
> >> positives that we'll have to live with, probably.
> > 
> > It is false positive: "this bug is not introduced by me!"
> > 
> > However if you take a broader view, it's still notifying the possibly
> > "relevant" people who may know the background about that bug, or whom
> > to further CC the report. :)
> > 
> > Thanks,
> > Fengguang
> > 
