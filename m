Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaJCSWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:22:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbaJCSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:21:55 -0400
Date: Fri, 3 Oct 2014 11:21:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build warnings after merge of the akpm-current tree
Message-Id: <20141003112154.92b5a47b2009293090d18f5a@linux-foundation.org>
In-Reply-To: <20141003173004.7ac4edce@canb.auug.org.au>
References: <20141003173004.7ac4edce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014 17:30:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (arm
> multi_v7_defconfig) produced these warnings:
> 
> drivers/base/dma-contiguous.c:244:2: warning: initialization from incompatible pointer type
>   .device_init = rmem_cma_device_init,
>   ^
> drivers/base/dma-contiguous.c:244:2: warning: (near initialization for 'rmem_cma_ops.device_init')
> drivers/base/dma-coherent.c:303:2: warning: initialization from incompatible pointer type
>   .device_init = rmem_dma_device_init,
>   ^
> 
> Introduced by commit e92f6296f3a2 ("drivers: dma-coherent: add
> initialization from device tree").  This init routine is supposed to
> return void ...

I'm a bit reluctant to just go in and change rmem_cma_device_init().

Why does it test for rmem->priv==NULL?  Can that really happen?  Why? 
Is it a legitimate state?

And why does dev_set_cma_area() test for dev==NULL?  Can that really
happen?  Is it legitimate?  Is all this stuff just papering over other
bugs?

The whole thing could do with a bit of an audit and cleanup, I suspect.
Get the states and initialization sequences and error checking all
sorted out, then get rid of all these tests for NULL.

