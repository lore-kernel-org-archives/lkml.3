Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaG2U3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:29:14 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:55601 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaG2U3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:29:13 -0400
Date: Tue, 29 Jul 2014 13:29:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
In-Reply-To: <1406653761-3884-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Prarit Bhargava wrote:

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 87fc96b..3875090 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -384,10 +384,10 @@ static void __init print_efi_memmap(void)
>  	     p < memmap.map_end;
>  	     p += memmap.desc_size, i++) {
>  		md = p;
> -		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
> +		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluKiB)\n",
>  			i, md->type, md->attribute, md->phys_addr,
>  			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> +			(md->num_pages << 2));
>  	}
>  #endif  /*  EFI_DEBUG  */
>  }

If EFI_PAGE_SHIFT were to ever change from its hard-coded 12, then this 
would be wrong.  Any reason to not simply print EFI_PAGE_SIZE and 
md->num_pages?
