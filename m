Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaDVIgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:36:22 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42996 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbaDVIgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:36:15 -0400
Date: Tue, 22 Apr 2014 09:35:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Capella <sebastian.capella@linaro.org>
Subject: Re: linux-next: build warning after merge of the arm tree
Message-ID: <20140422083524.GQ24070@n2100.arm.linux.org.uk>
References: <20140422103223.f16654774d15a81410eaad22@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422103223.f16654774d15a81410eaad22@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:32:23AM +1000, Stephen Rothwell wrote:
> Hi Russell,
> 
> After merging the arm tree, today's linux-next build (arm
> multi_v7_defconfig) produced this warning:
> 
> In file included from /scratch/sfr/next/arch/arm/include/asm/page.h:163:0,
>                  from /scratch/sfr/next/include/linux/mmzone.h:20,
>                  from /scratch/sfr/next/include/linux/gfp.h:5,
>                  from /scratch/sfr/next/include/linux/kmod.h:22,
>                  from /scratch/sfr/next/include/linux/module.h:13,
>                  from /scratch/sfr/next/init/version.c:10:
> /scratch/sfr/next/arch/arm/include/asm/memory.h:297:0: warning: "virt_to_pfn" redefined [enabled by default]
> /scratch/sfr/next/arch/arm/include/asm/memory.h:194:0: note: this is the location of the previous definition
> 
> Lots of these ...
> 
> Introduced by commit e2b5c192c4a6 ("ARM: 8011/1: ARM hibernation /
> suspend-to-disk").

Yes, it's a conflict between that patch and one I pushed during the
merge window.  I've asked the Sebastian to validate with his version of
virt_to_pfn() removed, and I'm waiting for the results of that...
That's partly happened, but I'm waiting for the final results.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
