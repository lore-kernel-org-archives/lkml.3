Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3KZOwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:52:07 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:45163 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844Ab3KZOwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:52:05 -0500
Date: Tue, 26 Nov 2013 14:51:55 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 04/12] efi: cleanup efi_enter_virtual_mode function
Message-ID: <20131126145155.GL11521@console-pimps.org>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-5-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385445477-9665-5-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov, at 01:57:49PM, Dave Young wrote:
> Add two small functions:
> efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
> calls them instead of embedding two long for loop.
> 
> v1->v2:
> refresh; coding style fixes.
> 
> v2->v3:
> Toshi Kani:
> remove unused variable
> Matt: check return value of krealloc.
> v3->v4:
> Boris: Stretch comment to 80 cols
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/platform/efi/efi.c | 109 +++++++++++++++++++++++++++-----------------
>  1 file changed, 66 insertions(+), 43 deletions(-)

[...]

> @@ -922,9 +948,6 @@ void __init efi_enter_virtual_mode(void)
>  			 0, NULL);
>  
>  	return;
> -
> - err_out:
> -	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
>  }
>  
>  /*
 
Teeny, tiny comment: You could now delete the above return statement.

-- 
Matt Fleming, Intel Open Source Technology Center
