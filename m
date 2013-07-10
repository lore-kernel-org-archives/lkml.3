Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3GJFVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:21:23 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:58344
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050Ab3GJFVW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:21:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [v3][PATCH 7/8] book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
Thread-Topic: [v3][PATCH 7/8] book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
Thread-Index: AQHOfHvB67E2WQz92U6o+48z0f/BepldYUNQ
Date: Wed, 10 Jul 2013 05:20:24 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D070AE138@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
 <1373357007-30785-8-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1373357007-30785-8-git-send-email-tiejun.chen@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
> Sent: Tuesday, July 09, 2013 1:33 PM
> To: benh@kernel.crashing.org
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: [v3][PATCH 7/8] book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
> 
> Book3e is always aligned 1GB to create TLB so we should
> use (KERNELBASE - MEMORY_START) as VIRT_PHYS_OFFSET to
> get __pa/__va properly while boot kdump.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/include/asm/page.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
> index 988c812..5b00081 100644
> --- a/arch/powerpc/include/asm/page.h
> +++ b/arch/powerpc/include/asm/page.h
> @@ -112,6 +112,8 @@ extern long long virt_phys_offset;
>  /* See Description below for VIRT_PHYS_OFFSET */
>  #ifdef CONFIG_RELOCATABLE_PPC32
>  #define VIRT_PHYS_OFFSET virt_phys_offset
> +#elif defined(CONFIG_PPC_BOOK3E_64)
> +#define VIRT_PHYS_OFFSET (KERNELBASE - MEMORY_START)

Can you please explain this code a bit more. I am not understanding this part:)

-Bharat

>  #else
>  #define VIRT_PHYS_OFFSET (KERNELBASE - PHYSICAL_START)
>  #endif
> --
> 1.7.9.5
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


