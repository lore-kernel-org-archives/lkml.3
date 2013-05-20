Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3ETHP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:15:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:37284 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3ETHP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:15:58 -0400
X-Spam-Score: -100.8
Message-ID: <5199CD7C.4080304@asianux.com>
Date: Mon, 20 May 2013 15:15:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "nico@linaro.org" <nico@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: compiling issue, need 'EXPORT_SYMBOL(clear_page)'
References: <5199CCF9.4030305@asianux.com>
In-Reply-To: <5199CCF9.4030305@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After this patch, can pass building arm64 with allmodconfig under
next-20130517 tree. :-)

On 05/20/2013 03:12 PM, Chen Gang wrote:
> 
> Need 'EXPORT_SYMBOL(clear_page)' if building with allmodconfig.
> 
> The related errors:
>   ERROR: "clear_page" [fs/ocfs2/dlm/ocfs2_dlm.ko] undefined!
>   ERROR: "clear_page" [fs/ntfs/ntfs.ko] undefined!
>   ERROR: "clear_page" [fs/gfs2/gfs2.ko] undefined!
>   ERROR: "clear_page" [fs/fuse/fuse.ko] undefined!
>   ERROR: "clear_page" [fs/ext3/ext3.ko] undefined!
>   ERROR: "clear_page" [fs/ext2/ext2.ko] undefined!
>   ERROR: "clear_page" [fs/exofs/libore.ko] undefined!
>   ERROR: "clear_page" [fs/exofs/exofs.ko] undefined!
>   ERROR: "clear_page" [drivers/block/brd.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/kernel/arm64ksyms.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
> index 7df1aad..41b4f62 100644
> --- a/arch/arm64/kernel/arm64ksyms.c
> +++ b/arch/arm64/kernel/arm64ksyms.c
> @@ -34,6 +34,7 @@ EXPORT_SYMBOL(__strnlen_user);
>  EXPORT_SYMBOL(__strncpy_from_user);
>  
>  EXPORT_SYMBOL(copy_page);
> +EXPORT_SYMBOL(clear_page);
>  
>  EXPORT_SYMBOL(__copy_from_user);
>  EXPORT_SYMBOL(__copy_to_user);
> 


-- 
Chen Gang

Asianux Corporation
