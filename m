Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3C0M3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:29:01 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36404 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3C0M27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:28:59 -0400
Date: Wed, 27 Mar 2013 21:28:57 +0900
From: Simon Horman <horms@verge.net.au>
To: zhouzhouyi@gmail.com
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com, yizhouzhou@ict.ac.cn
Subject: Re: [PATCH 1/1 v1] the recommended crash memory reservation is too
 small for x86_64.
Message-ID: <20130327122856.GK17248@verge.net.au>
References: <1364209009-11592-1-git-send-email-zhouzhouyi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364209009-11592-1-git-send-email-zhouzhouyi@gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 06:56:49PM +0800, zhouzhouyi@gmail.com wrote:
> From: root <root@zzy-Lenovo.(none)>

The above line is bogus.

>  On Documentation/kdump/kdump.txt, section Boot into  System Kernel: On x86 and x86_64, use
>  "crashkernel=64M@16M", but some OSes like ubuntu 12.10 use ram fs larger than 64M, so in these cases the
>  memory reserved for crashkernel should be at least 128M.

The above lines are way to wide. Something less than 80 columns is normal.

> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  Documentation/kdump/kdump.txt |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 13f1aa0..1e850e0 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -290,7 +290,9 @@ Boot into System Kernel
>     "crashkernel=64M@16M" tells the system kernel to reserve 64 MB of memory
>     starting at physical address 0x01000000 (16MB) for the dump-capture kernel.
>  
> -   On x86 and x86_64, use "crashkernel=64M@16M".
> +   On x86 and x86_64, use "crashkernel=64M@16M" (some OSes use init ram fs larger
> +than 64M, for example ubuntu-12.10, use crashkernel=128M@16M instead, or dump-capture
> +kernel will out of memory).

I believe lines of kdmump.txt should also be 80 columns wide or less.

>     On ppc64, use "crashkernel=128M@32M".
>  
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
