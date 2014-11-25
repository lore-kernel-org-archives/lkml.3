Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaKYXwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:52:04 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:35072 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKYXwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:52:02 -0500
Date: Tue, 25 Nov 2014 23:51:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Marek <mmarek@suse.cz>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kbuild: Fix forced rebuild after 'make dtbs'
Message-ID: <20141125235150.GH3836@n2100.arm.linux.org.uk>
References: <CACRpkdYmJWy1_vs0tWRA7SvkQnvbXXKqf7pHpH5b5tZ6vR+KJg@mail.gmail.com>
 <1414961549-31666-1-git-send-email-jason@lakedaemon.net>
 <5474F78F.2060906@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5474F78F.2060906@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:41:35PM +0100, Michal Marek wrote:
> Dne 2.11.2014 v 21:52 Jason Cooper napsal(a):
> > After this patch:
> > 
> >   f4d4ffc03efc kbuild: dtbs_install: new make target
> > 
> > was added the kernel tree, Linus Walleij noticed that 'make dtbs' forced
> > a following 'make zImage' to rebuild the entire tree, even though
> > nothing had changed.  His report:
> > 
> >   After this patch a while back I have observed the following behaviour
> >   of the kernel build:
> > 
> >   make zImage
> >   make zImage
> >   -> incremental build, just relink
> > 
> >   make zImage
> >   make dtbs
> >   make zImage
> >   -> The whole kernel gets rebuilt
> > 
> >   So now if I happen to recompile my device trees, I suddenly want
> >   the entire zImage to be rebuilt to? It's by definition not changes
> >   that affect the kernel build :-(
> > 
> >   I noticed this because my build scripts calls make dtbs && make
> >   zImage, and started to rebuild absolutely everything all the time.
> > 
> > To fix this, we make only the dtbs_install target depend on the prepare
> > target.  It's needed to make sure KERNELVERSION is calculated prior to
> > installing.
> 
> If a mere 'make prepare' causes a rebuild of the whole kernel, then
> there is something fishy in the ARM Makefiles. However, if you only need
> the KERNELRELEASE variable, then you do not need to depend on prepare.
> The main Makefile makes sure that silentoldconfig is ran and therefore
> KERNELRELEASE set for all targets except make *config.

Running make prepare and then re-running a build doesn't rebuild anything
for me.  However, I always build with O=  Also works if I do a make
dtbs too.  So, everything seems to work as expected here.

I think this needs a bit more debugging to see why the whole kernel is
being rebuilt - the kernel build system has methods to tell you why stuff
is being built, which would be a good place to start.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
