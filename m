Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3KPJnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 04:43:20 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:61545 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3KPJnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 04:43:15 -0500
Message-ID: <52873E20.6010307@synopsys.com>
Date: Sat, 16 Nov 2013 15:12:56 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Christian Ruppert <christian.ruppert@abilis.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Roskin <proski@gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Noam Camus <noamc@ezchip.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [FIX] init/Kconfig: fix option to disable kernel compression
References: <1384494227-24029-1-git-send-email-hpa@zytor.com> <1384534267-14746-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1384534267-14746-1-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 10:21 PM, Christian Ruppert wrote:
> Some architectures with self-decompressing kernel images did not compile
> with commit 69f0554ec261fd686ac7fa1c598cc9eb27b83a80 because they don't
> provide a non-decompression mechanism for uncompressed kernels.
> 
> Rectify this problem by allowing uncompressed kernels only for architectures
> which explicitly state they support them.
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>


Acked-by: Vineet Gupta <vgupta@synopsys.com>

> ---
>  arch/arc/Kconfig | 2 ++
>  init/Kconfig     | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
> index 2ee0c9b..15f4c3d 100644
> --- a/arch/arc/Kconfig
> +++ b/arch/arc/Kconfig
> @@ -21,6 +21,8 @@ config ARC
>  	select HAVE_ARCH_KGDB
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_IOREMAP_PROT
> +	select HAVE_KERNEL_UNCOMPRESSED
> +	select HAVE_KERNEL_GZIP
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
>  	select HAVE_MEMBLOCK
> diff --git a/init/Kconfig b/init/Kconfig
> index 5496f30..d4baf2e 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -97,6 +97,9 @@ config LOCALVERSION_AUTO
>  
>  	  which is done within the script "scripts/setlocalversion".)
>  
> +config HAVE_KERNEL_UNCOMPRESSED
> +        bool
> +
>  config HAVE_KERNEL_GZIP
>  	bool
>  
> @@ -118,6 +121,7 @@ config HAVE_KERNEL_LZ4
>  choice
>  	prompt "Kernel compression mode"
>  	default KERNEL_GZIP
> +	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4 || HAVE_KERNEL_UNCOMPRESSED
>  	help
>  	  The linux kernel is a kind of self-extracting executable.
>  	  Several compression algorithms are available, which differ
> @@ -138,6 +142,7 @@ choice
>  
>  config KERNEL_UNCOMPRESSED
>  	bool "No compression"
> +	depends on HAVE_KERNEL_UNCOMPRESSED
>  	help
>  	  No compression at all. The kernel is huge but the compression and
>  	  decompression times are zero.
> 

