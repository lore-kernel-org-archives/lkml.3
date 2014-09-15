Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaIOUI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:08:28 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56394 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbaIOUIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:08:25 -0400
Date: Mon, 15 Sep 2014 13:08:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: gxt@mprc.pku.edu.cn
Cc: linux-kernel@vger.kernel.org, gxt@pku.edu.cn, gang.chen.5i5j@gmail.com,
        Qin Rui <qinrui@pku.edu.cn>
Subject: Re: [PATCH 1/4] unicore32-oldabi: add CONFIG_UNICORE32_OLDABI for
 distinguishing two ABIs
Message-ID: <20140915200820.GD18175@roeck-us.net>
References: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 02:41:43PM +0800, gxt@mprc.pku.edu.cn wrote:
> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Qin Rui <qinrui@pku.edu.cn>

This series lets me build and run an initramfs with the published toolchain,
after adding the patch 'unicore32: Add ocd console and qemu-defconfig
to support qemu simulator' as well to get console output. So feel free
to add

Tested-by: Guenter Roeck <linux@roeck-us.net>

to the series.

I have a couple of questions:

- After adding the patch 'unicore32: Add ocd console and qemu-defconfig
  to support qemu simulator', I only get console output, but no input.
  Is there a way (for example with a qemu command line option) to get
  input as well ?
- Is it possible to connect a console to a serial device in qemu (in other
  words to run the image in qemu without the ocd console patch) ?
- Is there a working description on how to create a toolchain for the _new_
  ABI ? Alternatively, would it be possible to publish such a toolchain ?

Thanks a lot,

Guenter

> ---
>  arch/unicore32/Kconfig | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index 928237a..e5d25b4 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -72,6 +72,17 @@ source "kernel/Kconfig.freezer"
>  
>  menu "System Type"
>  
> +config UNICORE32_OLDABI
> +	bool "Allow old ABI binaries to run with this kernel"
> +	default y
> +	help
> +	  This option preserves the old syscall interface instead of the
> +	  asm-generic one. It also provides a compatibility layer to
> +	  intercept syscalls that have structure arguments which layout
> +	  in memory differs between the asm-generic ABI and this old one.
> +
> +	  If in doubt, say Y.
> +
>  config MMU
>  	def_bool y
>  
> -- 
> 2.0.0.GIT
> 
