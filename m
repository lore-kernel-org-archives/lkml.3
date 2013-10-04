Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3JDTpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:45:14 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50529 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3JDTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:45:11 -0400
Date: Fri, 4 Oct 2013 12:45:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: Tree for Oct 3
Message-ID: <20131004194504.GA32457@roeck-us.net>
References: <20131004010230.GI27287@sirena.org.uk>
 <524E50DB.3060707@roeck-us.net>
 <20131004102839.GJ27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004102839.GJ27287@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 11:28:39AM +0100, Mark Brown wrote:
> On Thu, Oct 03, 2013 at 10:23:39PM -0700, Guenter Roeck wrote:
> > On 10/03/2013 06:02 PM, Mark Brown wrote:
> 
> > >Due to the length of time taken to run all the allmodconfigs I skipped
> > >the defconfig tests; I know Olof has the ARM stuff covered in his
> > >autobuilder.  I'm going to use allyesconfig tomorrow since that should
> > >run faster so hopefully I can cover the ARM, i386 and x86_64 configs
> > >again.
> 
> > I could try to set up the buildbot farm I am using for -stable candidates
> > to also test the -next tree. Would that help ?
> 
> Yes, that'd be great.  Like Olof said ARM is pretty well covered but
> adding more platforms would be very helpful.

Ok, here are the results based on v3.12-rc3-3771-gedc72f7.

Build summary:
	total: 110 pass: 86 skipped: 4 fail: 20

'skipped' means the configuration does not (or no longer) exist. 

Failed builds:
	arm:allmodconfig
	arm:ape6evm_defconfig
	arm:marzen_defconfig
	arm:armadillo800eva_defconfig
	arm:mackerel_defconfig
	blackfin:defconfig
	metag:defconfig
	metag:meta1_defconfig
	metag:meta2_defconfig
	metag:meta2_smp_defconfig
	mips:defconfig
	mips:bcm63xx_defconfig
	mips:nlm_xlp_defconfig
	mips:fuloong2e_defconfig
	mips:e55_defconfig
	mips:malta_defconfig
	powerpc:ppc64e_defconfig
	powerpc:chroma_defconfig
	powerpc:mpc85xx_smp_defconfig
	sparc64:allmodconfig

mips and mips64 qemu tests fail as well. mips test builds but hangs early in
boot, mips64 fails to build.

On the plus side, the sh qemu warning (WARNING traceback during boot)
is no longer observed.

Details are at http://server.roeck-us.net:8010/builders.

If everything works as intended, updates to the repository should trigger an
automatic re-build. No guarantees, though - I had some trouble with the initial
checkout.

Guenter

