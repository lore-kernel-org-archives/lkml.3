Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3D2J4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:56:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33976 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755242Ab3D2J4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:56:06 -0400
Message-ID: <517E43AE.6050203@console-pimps.org>
Date: Mon, 29 Apr 2013 10:55:58 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
CC: matt.fleming@intel.com, mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: initial the local variable of DataSize to zero
References: <1366996767-8234-1-git-send-email-jlee@suse.com>
In-Reply-To: <1366996767-8234-1-git-send-email-jlee@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 18:19, Lee, Chun-Yi wrote:
> That will be better initial the value of DataSize to zero for the input of
> GetVariable(), otherwise we will feed a random value. The debug log of input
> DataSize like this:
> 
> ...
> [  195.915612] EFI Variables Facility v0.08 2004-May-17
> [  195.915819] efi: size: 18446744071581821342
> [  195.915969] efi:  size': 18446744071581821342
> [  195.916324] efi: size: 18446612150714306560
> [  195.916632] efi:  size': 18446612150714306560
> [  195.917159] efi: size: 18446612150714306560
> [  195.917453] efi:  size': 18446612150714306560
> ...
> 
> Found on Acer Aspire V3 BIOS, it will not return the size of data if we input a
> non-zero DataSize.
> 
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/platform/efi/efi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e4a86a6..cb59732 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -204,7 +204,7 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
>  	}
>  
>  	if (boot_used_size && !finished) {
> -		unsigned long size;
> +		unsigned long size = 0;
>  		u32 attr;
>  		efi_status_t s;
>  		void *tmp;
> 

Looks good to me. Matthew?

-- 
Matt Fleming, Intel Open Source Technology Center
