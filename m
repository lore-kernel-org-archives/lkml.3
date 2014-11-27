Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaK0LUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:20:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaK0LUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:20:37 -0500
Date: Thu, 27 Nov 2014 11:20:35 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3.16.y-ckt 172/254] x86, microcode: Fix accessing
 dis_ucode_ldr on 32-bit
Message-ID: <20141127112035.GD8184@hercules>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
 <1416912004-5928-173-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416912004-5928-173-git-send-email-luis.henriques@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:38:42AM +0000, Luis Henriques wrote:
> 3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.
> 

As requested on the stable mailing-list, I'm dropping this patch from
the 3.16 queue.

Cheers,
--
Luís

> ------------------
> 
> From: Borislav Petkov <bp@suse.de>
> 
> commit 85be07c32496dc264661308e4d9d4e9ccaff8072 upstream.
> 
> We should be accessing it through a pointer, like on the BSP.
> 
> Tested-by: Richard Hendershot <rshendershot@mchsi.com>
> Fixes: 65cef1311d5d ("x86, microcode: Add a disable chicken bit")
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  arch/x86/kernel/cpu/microcode/core_early.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
> index 5f28a64e71ea..2c017f242a78 100644
> --- a/arch/x86/kernel/cpu/microcode/core_early.c
> +++ b/arch/x86/kernel/cpu/microcode/core_early.c
> @@ -124,7 +124,7 @@ void __init load_ucode_bsp(void)
>  static bool check_loader_disabled_ap(void)
>  {
>  #ifdef CONFIG_X86_32
> -	return __pa_nodebug(dis_ucode_ldr);
> +	return *((bool *)__pa_nodebug(&dis_ucode_ldr));
>  #else
>  	return dis_ucode_ldr;
>  #endif
> -- 
> 2.1.0
> 
