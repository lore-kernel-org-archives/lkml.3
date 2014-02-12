Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaBLVPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:15:44 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:65058 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbaBLVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:15:42 -0500
Date: Wed, 12 Feb 2014 16:15:38 -0500
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build failure after merge of the final tree (cgroup
 tree related)
Message-ID: <20140212211538.GG26809@htj.dyndns.org>
References: <20140212162500.242e91e4cc3541b992fa3a0c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212162500.242e91e4cc3541b992fa3a0c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 04:25:00PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc defconfig)
> failed like this:
> 
> arch/sparc/kernel/sun4m_irq.c: In function 'sun4m_build_device_irq':
> arch/sparc/kernel/sun4m_irq.c:266:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
> arch/sparc/kernel/sun4m_irq.c:266:15: error: assignment makes pointer from integer without a cast [-Werror]
> 
> Presumably caused by commit 2bd59d48ebfb ("cgroup: convert to kernfs")
> (see the comment in commit 1ff6bbfd13ca ("arm, pm, vmpressure: add
> missing slab.h includes")).  I wonder how mane more builds are broken by
> this :-(
> 
> Indeed, reverting that commit fixes the build.
> 
> I have added the following build fix for today (please check the
> overnight builds for more breakage):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 12 Feb 2014 16:01:10 +1100
> Subject: [PATCH] sun4M: add include of slab.h for kzalloc
> 
> This was being included implicitly via cgroup.h's inclusion of xattr.h
> (which has now been removed).
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied to cgroup/for-3.15.

Thanks!

-- 
tejun
