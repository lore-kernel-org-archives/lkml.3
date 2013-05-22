Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3EVFHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab3EVFG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:06:59 -0400
Date: Wed, 22 May 2013 08:07:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vhost tree
Message-ID: <20130522050718.GA7993@redhat.com>
References: <20130522143704.3431658328f8f879f55b0910@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522143704.3431658328f8f879f55b0910@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:37:04PM +1000, Stephen Rothwell wrote:
> Hi Michael,
> 
> After merging the vhost tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from arch/powerpc/include/asm/uaccess.h:12:0,
>                  from arch/powerpc/lib/checksum_wrappers_64.c:24:
> include/asm-generic/uaccess.h: In function 'might_fault':
> include/asm-generic/uaccess.h:36:2: error: implicit declaration of function 'segment_eq' [-Werror=implicit-function-declaration]
>   if (_might_fault())
>   ^
> include/asm-generic/uaccess.h:36:2: error: implicit declaration of function 'get_fs' [-Werror=implicit-function-declaration]
> include/asm-generic/uaccess.h:29:47: error: 'KERNEL_DS' undeclared (first use in this function)
>  #define _might_fault() (!segment_eq(get_fs(), KERNEL_DS) && !in_atomic())
>                                                ^
> include/asm-generic/uaccess.h:36:6: note: in expansion of macro '_might_fault'
>   if (_might_fault())
>       ^
> 
> and many, many more.
> 
> Caused by commit d198a8acf543 ("kernel: might_fault does not imply
> might_sleep").
> 
> I have used the version of the vhost tree from next-20130521 for today.
> 
> It was unexpected that such patches would turn up in the "vhost" tree ...
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


Looks like I pushed a wrong commit. Sorry, will fix this up ASAP.
