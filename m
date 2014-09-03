Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbaICPa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:30:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59228 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682AbaICPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:30:21 -0400
Message-ID: <54073409.6030004@canonical.com>
Date: Wed, 03 Sep 2014 17:30:17 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Matt Fleming <matt@console-pimps.org>, Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
References: <5405E186.2080406@canonical.com>	<20140902192941.GB3001@console-pimps.org>	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>	<5406D0DB.90401@canonical.com> <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
In-Reply-To: <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 03-09-14 om 14:18 schreef Ard Biesheuvel:
> Could you please try adding the visibility attribute lik this instead?
>
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 044a2fd3c5fe..8725d85f1903 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -178,7 +178,7 @@ struct efi_config {
>         bool is64;
>  } __packed;
>
> -extern struct efi_config *efi_early;
> +extern __attribute__((visibility("hidden"))) struct efi_config *efi_early;
>
>  #define efi_call_early(f, ...)                                         \
>         efi_early->call(efi_early->f, __VA_ARGS__);
>
> Before this change, I get 18 R_X86_64_GOTPCREL relocations pointing to
> efi_early, both in efi-stub-helper.c and eboot.c.
> After the change, I get 0, using 'readelf -a
> drivers/firmware/efi/libstub/efi-stub-helper.o
> arch/x86/boot/compressed/eboot.o|grep GOTPCREL|wc -l'
>
Yeah that fixes things!

Feel free to slap on a reported-reviewed-and-tested-by on your patch. :-)

~Maarten
