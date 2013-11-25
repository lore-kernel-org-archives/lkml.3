Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3KYMrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:47:47 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37620 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3KYMro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:47:44 -0500
MIME-Version: 1.0
In-Reply-To: <1385372437-20958-1-git-send-email-ian.campbell@citrix.com>
References: <1385372437-20958-1-git-send-email-ian.campbell@citrix.com>
Date: Mon, 25 Nov 2013 07:47:43 -0500
Message-ID: <CA+5PVA4u7U6GarwnYdtj-N1pOm-9TMQJMX_2D045vk3FA=XPxg@mail.gmail.com>
Subject: Re: [PATCH] powerpc/4xx: Fix warning in kilauea.dtb
From: Josh Boyer <jwboyer@gmail.com>
To: Ian Campbell <ian.campbell@citrix.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Rupjyoti Sarmah <rsarmah@apm.com>, Tirumala R Marri <tmarri@apm.com>,
        Paul Mackerras <paulus@samba.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 4:40 AM, Ian Campbell <ian.campbell@citrix.com> wrote:
> Currently I see:
>   DTC     arch/powerpc/boot/kilauea.dtb
> Warning (reg_format): "reg" property in /plb/ppc4xx-msi@C10000000 has invalid length (12 bytes) (#address-cells == 1, #size-cells == 1)
>
> It appears that unlike the other platforms handled by 3fb7933850fa
> "powerpc/4xx: Adding PCIe MSI support" this platform does not use address-cells=2.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Acked-by: Josh Boyer <jwboyer@gmail.com>
> Cc: Rupjyoti Sarmah <rsarmah@apm.com>
> Cc: Tirumala R Marri <tmarri@apm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Resending, this hasn't been picked up since June
> http://patchwork.ozlabs.org/patch/248234/

Ben, please pick this up.

josh

> ---
>  arch/powerpc/boot/dts/kilauea.dts |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
> index 1613d6e..5ba7f01 100644
> --- a/arch/powerpc/boot/dts/kilauea.dts
> +++ b/arch/powerpc/boot/dts/kilauea.dts
> @@ -406,7 +406,7 @@
>
>                 MSI: ppc4xx-msi@C10000000 {
>                         compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
> -                       reg = < 0x0 0xEF620000 0x100>;
> +                       reg = <0xEF620000 0x100>;
>                         sdr-base = <0x4B0>;
>                         msi-data = <0x00000000>;
>                         msi-mask = <0x44440000>;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
