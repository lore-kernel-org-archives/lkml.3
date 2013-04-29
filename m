Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3D2K0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:26:42 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:41817 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3D2K0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:26:41 -0400
Subject: Re: [PATCH] x86, efi: initial the local variable of DataSize to
 zero
From: joeyli <jlee@suse.com>
To: matt.fleming@intel.com, mjg59@srcf.ucam.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1366996767-8234-1-git-send-email-jlee@suse.com>
References: <1366996767-8234-1-git-send-email-jlee@suse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Apr 2013 18:25:11 +0800
Message-ID: <1367231111.22858.55.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 六，2013-04-27 於 01:19 +0800，Lee, Chun-Yi 提到：
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

After applied patch, the log of size like this:

[   82.442042] EFI Variables Facility v0.08 2004-May-17
[   82.442202] efi: size: 0
[   82.442360] efi:  size': 1039
[   82.443828] efi: size: 0
[   82.444127] efi:  size': 2616
[   82.447057] efi: size: 0
[   82.447356] efi:  size': 5832
[   82.452669] efi: size: 0
[   82.453128] efi:  size': 1
[   82.454339] efi: size: 0
[   82.454843] efi:  size': 1
[   82.456173] efi: size: 0
[   82.456764] efi:  size': 8
[   82.458194] efi: size: 0
[   82.458905] efi:  size': 4

The size' is the return value of Acer BIOS, it return right size value
then we feed zero DataSize.


Thanks a lot!
Joey Lee

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


