Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaCKEyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:54:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:26689 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaCKEyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:54:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="489540309"
Date: Tue, 11 Mar 2014 12:54:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [powerpc:next 45/53] warning: (PPC_C2K && ..) selects
 NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || ..)
Message-ID: <20140311045424.GB12373@localhost>
References: <531acfa5.YesaRIJhSRvrw4/w%fengguang.wu@intel.com>
 <531DD0F4.6020000@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531DD0F4.6020000@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:49:24AM -0400, Paul Gortmaker wrote:
> On 14-03-08 03:07 AM, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next
> > head:   c7e64b9ce04aa2e3fad7396d92b5cb92056d16ac
> > commit: 3c8464a9b12bf83807b6e2c896d7e7b633e1cae7 [45/53] powerpc: Delete old PrPMC 280/2800 support
> > config: make ARCH=powerpc c2k_defconfig
> > 
> > All warnings:
> > 
> > warning: (PPC_C2K && AMIGAONE) selects NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON)
> 
> This _looks_ like a new warning, but it really is not.  If you look
> at the tree prior to the above named commit, it generates this:
> 
> $ make c2k_defconfig
> warning: (PPC_PRPMC2800 && PPC_C2K && AMIGAONE) selects NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON)
> warning: (PPC_PRPMC2800 && PPC_C2K && AMIGAONE) selects NOT_COHERENT_CACHE which has unmet direct dependencies (4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON)
> #
> # configuration written to .config
> 
> So the warning is slightly different in text, but essentially
> the exact same thing that was being warned about before.  We've
> just removed one of the possible symbols from existence.

Yes, sorry, the kbuild robot is not smart enough to detect such
slightly changed error/warnings and will treat them as new ones.

> I'm not sure there would ever be a way to teach kbuild robot
> about something as subtle as the above; just one of the false
> positives that we'll have to live with, probably.

It is false positive: "this bug is not introduced by me!"

However if you take a broader view, it's still notifying the possibly
"relevant" people who may know the background about that bug, or whom
to further CC the report. :)

Thanks,
Fengguang
