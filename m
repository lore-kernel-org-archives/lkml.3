Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab3GMVsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 17:48:21 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46116 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3GMVsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 17:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130713162604.627C2FAAE9@dev.laptop.org>
References: <20130713162604.627C2FAAE9@dev.laptop.org>
Date: Sat, 13 Jul 2013 14:48:18 -0700
X-Google-Sender-Auth: jW5PGLH4dAEAVsDZ_NRDNYLWhUQ
Message-ID: <CAE9FiQUndrTZYk+JS09PUYg4Od1VLz_CDikp2DftXSrUraH1bw@mail.gmail.com>
Subject: Re: [PATCH] x86: don't clear olpc_ofw_header when sentinel is detected
From: Yinghai Lu <yinghai@kernel.org>
To: Daniel Drake <dsd@laptop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pgf@laptop.org, Andres Salomon <dilinger@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 9:26 AM, Daniel Drake <dsd@laptop.org> wrote:
> OpenFirmware doesn't quite follow the protocol described in boot.txt
> and the kernel has detected this through use of the sentinel value
> in boot_params. OFW does zero out almost all of the stuff that it should
> do, but not the sentinel.
>
> This causes the kernel to clear olpc_ofw_header, which breaks x86 OLPC
> support.
>
> We will fix OpenFirmware. However, it would be nice if we could maintain
> Linux compatibility with old firmware versions. To do that, we just have
> to avoid zeroing out olpc_ofw_header.
>
> OFW does not write to any other parts of the header that are being zapped
> by the sentinel-detection code, and all users of olpc_ofw_header are
> somewhat protected through checking for the OLPC_OFW_SIG magic value
> before using it. So this should not cause any problems for anyone.
>
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/include/asm/bootparam_utils.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
> index 653668d..4a8cb8d 100644
> --- a/arch/x86/include/asm/bootparam_utils.h
> +++ b/arch/x86/include/asm/bootparam_utils.h
> @@ -35,9 +35,9 @@ static void sanitize_boot_params(struct boot_params *boot_params)
>          */
>         if (boot_params->sentinel) {
>                 /* fields in boot_params are left uninitialized, clear them */
> -               memset(&boot_params->olpc_ofw_header, 0,
> +               memset(&boot_params->ext_ramdisk_image, 0,
>                        (char *)&boot_params->efi_info -
> -                       (char *)&boot_params->olpc_ofw_header);
> +                       (char *)&boot_params->ext_ramdisk_image);
>                 memset(&boot_params->kbd_status, 0,
>                        (char *)&boot_params->hdr -
>                        (char *)&boot_params->kbd_status);
> --
> 1.8.1.4

Acked-by: Yinghai Lu <yinghai@kernel.org>

also need to
Cc: <stable@vger.kerne.org> v3.9+
