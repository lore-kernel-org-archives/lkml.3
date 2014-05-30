Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaE3Fxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:53:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbaE3Fxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:53:30 -0400
Date: Fri, 30 May 2014 13:54:47 +0800
From: Dave Young <dyoung@redhat.com>
To: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com, horms@verge.net.au
Subject: Re: [PATCH]x86 efi: do not export efi runtime map in case old map
Message-ID: <20140530055447.GB2187@darkstar.nay.redhat.com>
References: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Simon.

Simon, appologize for not ccing you about this kernel patch. I see you have
applied the userspace patch for checking sysfs runtime existance.

The userspace patch depends on this patch but it is not harmful even without
this kernel patch. So applying the userspace patch before this one is still
safe.

On 05/30/14 at 11:20am, Dave Young wrote:
> 
> For ioremapped efi memory aka old_map the virt addresses are not persistant
> across kexec reboot. kexec-tools will read the runtime maps from sysfs then
> pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
> kexec boot failure.
> 
> To address this issue do not export runtime maps in case efi old_map so
> userspace can use no efi boot instead.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 3781dd3..4d36932 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -919,6 +919,9 @@ static void __init save_runtime_map(void)
>  	void *tmp, *p, *q = NULL;
>  	int count = 0;
>  
> +	if (efi_enabled(EFI_OLD_MEMMAP))
> +		return;
> +
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
