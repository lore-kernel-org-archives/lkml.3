Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaBMVBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:01:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49975 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaBMVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:01:47 -0500
Date: Thu, 13 Feb 2014 16:01:44 -0500 (EST)
Message-Id: <20140213.160144.63805570344280696.davem@davemloft.net>
To: tj@kernel.org
Cc: paul.gortmaker@windriver.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re: [PATCH] sparc: fix implicit include of slab.h in
 leon_pci_grpci2.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140213204217.GD17608@htj.dyndns.org>
References: <1392307158-6932-1-git-send-email-paul.gortmaker@windriver.com>
	<20140213204217.GD17608@htj.dyndns.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 13:01:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 13 Feb 2014 15:42:17 -0500

> On Thu, Feb 13, 2014 at 10:59:18AM -0500, Paul Gortmaker wrote:
>> To fix:
>> 
>> arch/sparc/kernel/leon_pci_grpci2.c: In function 'grpci2_of_probe':
>> arch/sparc/kernel/leon_pci_grpci2.c:720:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
>> arch/sparc/kernel/leon_pci_grpci2.c:720:20: error: assignment makes pointer from integer without a cast [-Werror]
>> arch/sparc/kernel/leon_pci_grpci2.c:882:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
>> cc1: all warnings being treated as errors
>> make[2]: *** [arch/sparc/kernel/leon_pci_grpci2.o] Error 1
>> 
>> According to Stephen, these types of failures are caused by
>> commit 2bd59d48ebfb ("cgroup: convert to kernfs") which was
>> being included implicitly via cgroup.h's inclusion of xattr.h
>> (which has now been removed).
>> 
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> Cc: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Darn, another one.  David, can you please ack this one?  I'll push it
> through cgroup/for-3.15 so that -next doesn't break.

Acked-by: David S. Miller <davem@davemloft.net>
