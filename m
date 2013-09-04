Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393Ab3IDKjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762282Ab3IDKjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:39:07 -0400
Date: Wed, 4 Sep 2013 13:38:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM changes for 3.12
Message-ID: <20130904103855.GC7402@redhat.com>
References: <20130903121046.GE22899@redhat.com>
 <20130904101826.GA2744@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904101826.GA2744@ulmo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copying Marek, Aneesh and Alex since this came through PPC kvm tree.

On Wed, Sep 04, 2013 at 12:18:28PM +0200, Thierry Reding wrote:
> On Tue, Sep 03, 2013 at 03:10:46PM +0300, Gleb Natapov wrote:
> [...]
> > Aneesh Kumar K.V (5):
> >       mm/cma: Move dma contiguous changes into a seperate config
> 
> Hi Gleb,
> 
> This commit is going to cause runtime regressions on various ARM
> platforms because it renames a symbol but fails to update all default
> configurations that select the symbol. A quick grep shows that three ARM
> platforms are affected:
> 
> 	$ git grep CONFIG_CMA=y
> 	arch/arm/configs/keystone_defconfig:CONFIG_CMA=y
> 	arch/arm/configs/omap2plus_defconfig:CONFIG_CMA=y
> 	arch/arm/configs/tegra_defconfig:CONFIG_CMA=y
> 
> I've been digging around a bit and it seems like the original patch from
> Aneesh had the defconfig changes but they were dropped because they "...
> require separate handling to avoid pointless merge conflicts."[0]
> 
Marek, that's your words. What do you think about ARM problem?

> While I can't speak for Keystone or OMAP, at least on Tegra this causes
> issues because we use CMA for framebuffer allocation. Since we only have
> CMA selected but not the new DMA_CMA, large DMA allocations will fail.
> 
Make config suppose to ask you about new option though, does it?

> Can we have the defconfig changes added back to this patch, please? I
> suspect that Linus can handle any resulting merge conflicts.
> 
> Thierry
> 
> [0]: http://permalink.gmane.org/gmane.linux.kernel.mm/102707



--
			Gleb.
