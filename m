Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaKYVlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:41:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKYVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:41:39 -0500
Message-ID: <5474F78F.2060906@suse.cz>
Date: Tue, 25 Nov 2014 22:41:35 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kbuild: Fix forced rebuild after 'make dtbs'
References: <CACRpkdYmJWy1_vs0tWRA7SvkQnvbXXKqf7pHpH5b5tZ6vR+KJg@mail.gmail.com> <1414961549-31666-1-git-send-email-jason@lakedaemon.net>
In-Reply-To: <1414961549-31666-1-git-send-email-jason@lakedaemon.net>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 2.11.2014 v 21:52 Jason Cooper napsal(a):
> After this patch:
> 
>   f4d4ffc03efc kbuild: dtbs_install: new make target
> 
> was added the kernel tree, Linus Walleij noticed that 'make dtbs' forced
> a following 'make zImage' to rebuild the entire tree, even though
> nothing had changed.  His report:
> 
>   After this patch a while back I have observed the following behaviour
>   of the kernel build:
> 
>   make zImage
>   make zImage
>   -> incremental build, just relink
> 
>   make zImage
>   make dtbs
>   make zImage
>   -> The whole kernel gets rebuilt
> 
>   So now if I happen to recompile my device trees, I suddenly want
>   the entire zImage to be rebuilt to? It's by definition not changes
>   that affect the kernel build :-(
> 
>   I noticed this because my build scripts calls make dtbs && make
>   zImage, and started to rebuild absolutely everything all the time.
> 
> To fix this, we make only the dtbs_install target depend on the prepare
> target.  It's needed to make sure KERNELVERSION is calculated prior to
> installing.

If a mere 'make prepare' causes a rebuild of the whole kernel, then
there is something fishy in the ARM Makefiles. However, if you only need
the KERNELRELEASE variable, then you do not need to depend on prepare.
The main Makefile makes sure that silentoldconfig is ran and therefore
KERNELRELEASE set for all targets except make *config.

Michal
