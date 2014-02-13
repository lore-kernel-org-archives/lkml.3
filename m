Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaBMVTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:19:04 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:53400 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMVTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:19:01 -0500
Date: Thu, 13 Feb 2014 16:18:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] sparc: fix implicit include of slab.h in
 leon_pci_grpci2.c
Message-ID: <20140213211857.GF17608@htj.dyndns.org>
References: <1392307158-6932-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392307158-6932-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:59:18AM -0500, Paul Gortmaker wrote:
> To fix:
> 
> arch/sparc/kernel/leon_pci_grpci2.c: In function 'grpci2_of_probe':
> arch/sparc/kernel/leon_pci_grpci2.c:720:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
> arch/sparc/kernel/leon_pci_grpci2.c:720:20: error: assignment makes pointer from integer without a cast [-Werror]
> arch/sparc/kernel/leon_pci_grpci2.c:882:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
> cc1: all warnings being treated as errors
> make[2]: *** [arch/sparc/kernel/leon_pci_grpci2.o] Error 1
> 
> According to Stephen, these types of failures are caused by
> commit 2bd59d48ebfb ("cgroup: convert to kernfs") which was
> being included implicitly via cgroup.h's inclusion of xattr.h
> (which has now been removed).
> 
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied to cgroup/for-3.15.

Thanks.

-- 
tejun
