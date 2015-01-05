Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbbAERyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:54:39 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:57951 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbbAERyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:54:37 -0500
Date: Mon, 5 Jan 2015 18:54:29 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 5
Message-ID: <20150105175428.GA27817@linux-mips.org>
References: <20150105144418.26dbb514@canb.auug.org.au>
 <20150105091403.GA15991@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105091403.GA15991@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 01:14:03AM -0800, Guenter Roeck wrote:

> On Mon, Jan 05, 2015 at 02:44:18PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20150103:
> > 
> > The net-next tree lost its build failures.
> > 
> > Non-merge commits (relative to Linus' tree): 1000
> >  1120 files changed, 31463 insertions(+), 18473 deletions(-)
> > 
> mips allmodconfig build fails.
> 
> # bad: [35393dcb2ed331e8698a548fbba8042457f5fd32] Add linux-next specific files for 20150105
> # good: [b7392d2247cfe6771f95d256374f1a8e6a6f48d6] Linux 3.19-rc2
> git bisect start 'HEAD' 'v3.19-rc2'
> # bad: [0e549e6e3875b24240385b7d9ea6af202fe752ad] Merge remote-tracking branch 'slave-dma/next'
> git bisect bad 0e549e6e3875b24240385b7d9ea6af202fe752ad
> # good: [633df24083c385997b98321f27721f3e38eb347f] Merge remote-tracking branch 'samsung/for-next'
> git bisect good 633df24083c385997b98321f27721f3e38eb347f
> # bad: [4091196d9eccdd246387f8567f6ae76700ce7d8a] Merge remote-tracking branch 'hid/for-next'
> git bisect bad 4091196d9eccdd246387f8567f6ae76700ce7d8a
> # bad: [6c45bc837e118c956f180c4e5de604099372868b] Merge remote-tracking branch 'f2fs/dev'
> git bisect bad 6c45bc837e118c956f180c4e5de604099372868b
> # bad: [5e73502be2b877d54ba5ec2e29ffa6374ef7a1f2] Merge remote-tracking branch 'mips/mips-for-linux-next'
> git bisect bad 5e73502be2b877d54ba5ec2e29ffa6374ef7a1f2
> # good: [5cc18cbf7b4693319f0686b31b0ce31005b7ce9f] Merge remote-tracking branch 'cris/for-next'
> git bisect good 5cc18cbf7b4693319f0686b31b0ce31005b7ce9f
> # good: [fd437fa849b349df6b0ac0fd6fa3a4a1efba7b07] MIPS: ARC: Add declarations for a few missing ARC firmware functions.
> git bisect good fd437fa849b349df6b0ac0fd6fa3a4a1efba7b07
> # bad: [d8b1d15c5d8f97da00f9469b9aa6f14b050d42a1] MIPS: Kconfig: Fix recursive dependency.
> git bisect bad d8b1d15c5d8f97da00f9469b9aa6f14b050d42a1
> # good: [af53a7778a69283e9b10e6f41874f13463df4e10] MIPS: Update malta_defconfig to something that works out of the box.
> git bisect good af53a7778a69283e9b10e6f41874f13463df4e10
> # good: [4436bb1bb866ee8e9d3bc3200a3cddd833357689] MIPS: JZ4740: Fixup #include's (sparse)
> git bisect good 4436bb1bb866ee8e9d3bc3200a3cddd833357689
> # good: [d74473bdf7a4c1ef7ae2b75f585fe5649ac2dcea] MIPS: Compat: Fix build error if CONFIG_MIPS32_COMPAT but no compat ABI.
> git bisect good d74473bdf7a4c1ef7ae2b75f585fe5649ac2dcea
> # first bad commit: [d8b1d15c5d8f97da00f9469b9aa6f14b050d42a1] MIPS: Kconfig: Fix recursive dependency.
> 
> "make archprepare" fails after "make allmodconfig", so this is easy to
> reproduce.

Thanks for reporting.  d8b1d15c5 allowed the to generate an invalid
configuration, that is N32 support to be enabled on 32-bit kernels which
would fail to build.  No issue for valid kernel configurations.  Fix
will be in tomorrow's linux-next.

  Ralf
