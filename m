Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaKYSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:09:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19153 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaKYSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:09:25 -0500
Message-ID: <5474C67A.7040200@oracle.com>
Date: Tue, 25 Nov 2014 13:12:10 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, Richard Hendershot <rshendershot@mchsi.com>,
        Borislav Petkov <bp@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
References: <20141119205150.700188369@linuxfoundation.org> <20141119205153.916605840@linuxfoundation.org>
In-Reply-To: <20141119205153.916605840@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 03:52 PM, Greg Kroah-Hartman wrote:
> 3.17-stable review patch.  If anyone has any objections, please let me know.


This breaks PV on Xen.

-boris

>
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
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   arch/x86/kernel/cpu/microcode/core_early.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/arch/x86/kernel/cpu/microcode/core_early.c
> +++ b/arch/x86/kernel/cpu/microcode/core_early.c
> @@ -124,7 +124,7 @@ void __init load_ucode_bsp(void)
>   static bool check_loader_disabled_ap(void)
>   {
>   #ifdef CONFIG_X86_32
> -	return __pa_nodebug(dis_ucode_ldr);
> +	return *((bool *)__pa_nodebug(&dis_ucode_ldr));
>   #else
>   	return dis_ucode_ldr;
>   #endif
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

