Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbaJaUQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:16:41 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36289 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbaJaUQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:16:39 -0400
Date: Fri, 31 Oct 2014 13:16:34 -0700
From: josh@joshtriplett.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, boot: document intermediates more clearly
Message-ID: <20141031201634.GA32605@cloud>
References: <20141031162204.GA26268@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031162204.GA26268@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 09:22:04AM -0700, Kees Cook wrote:
> This adds a comment detailing the various intermediate files used to build
> the bootable decompression image for the x86 kernel.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Definitely the documentation I wish I had long ago when trying to figure
out the twisty maze of binaries.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/x86/boot/compressed/Makefile | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index be1e07d4b596..44a866b85c6f 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -3,6 +3,18 @@
>  #
>  # create a compressed vmlinux image from the original vmlinux
>  #
> +# vmlinuz is:
> +#	decompression code (*.o)
> +#	asm globals (piggy.S), including:
> +#		vmlinux.bin.(gz|bz2|lzma|...)
> +#
> +# vmlinux.bin is:
> +#	vmlinux stripped of debugging and comments
> +# vmlinux.bin.all is:
> +#	vmlinux.bin + vmlinux.relocs
> +# vmlinux.bin.(gz|bz2|lzma|...) is:
> +#	(see scripts/Makefile.lib size_append)
> +#	compressed vmlinux.bin.all + u32 size of vmlinux.bin.all
>  
>  targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
>  	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
> -- 
> 1.9.1
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
