Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3F3DOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 23:14:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34908 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3F3DOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 23:14:14 -0400
Date: Sat, 29 Jun 2013 22:14:11 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/2] Documentation: arm: early_ioremap
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org, nico@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
In-Reply-To: <1372182401-11029-2-git-send-email-leif.lindholm@linaro.org>
	(from leif.lindholm@linaro.org on Tue Jun 25 12:46:40 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1372562051.2776.162@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 12:46:40 PM, Leif Lindholm wrote:
> This patch provides documentation of the early_ioremap()  
> functionality,
> including its implementation and usage instructions.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  Documentation/arm/00-INDEX          |    2 ++
>  Documentation/arm/early_ioremap.txt |   12 ++++++++++++
>  2 files changed, 14 insertions(+)
>  create mode 100644 Documentation/arm/early_ioremap.txt
> 
> diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
> index 36420e1..4978456 100644
> --- a/Documentation/arm/00-INDEX
> +++ b/Documentation/arm/00-INDEX
> @@ -24,6 +24,8 @@ SPEAr
>  	- ST SPEAr platform Linux Overview
>  VFP/
>  	- Release notes for Linux Kernel Vector Floating Point support  
> code
> +early_ioremap.txt
> +	- documentation of the early_ioremap() functionality
>  empeg/
>  	- Ltd's Empeg MP3 Car Audio Player
>  mem_alignment
> diff --git a/Documentation/arm/early_ioremap.txt  
> b/Documentation/arm/early_ioremap.txt
> new file mode 100644
> index 0000000..178f791
> --- /dev/null
> +++ b/Documentation/arm/early_ioremap.txt
> @@ -0,0 +1,12 @@
> +early_ioremap() and early_iounmap() rovide a mechanism for  
> temporarily mapping

Typo: provide

> +in small blocks of memory, identified by their physical address,  
> into the
> +fixmap virtual address block before paging_init() has been called  
> and more
> +flexible mapping functions are available.
> +
> +Due to its direct method, it also gets around potential need for  
> special
> +handling of regions that end up in highmem.
> +
> +It supports up to 7 simultaneously mapped regions of up to 128KB  
> each.
> +All regions are mapped as non-shareable device memory.
> +
> +Specify 'early_ioremap_debug' on the kernel commandline for verbose  
> output.
> --
> 1.7.10.4

Minor quibble: this explains what it does, but nothing about how to use  
it. Do these mappings persist if you don't unmap them, or does  
paging_init() clear them?

Oh well:

Acked-by: Rob Landley <rob@landley.net>

Rob