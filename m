Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3GJFSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:18:30 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:37909
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab3GJFSP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:18:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [v3][PATCH 1/8] powerpc/book3e: rename interrupt_end_book3e
 with __end_interrupts
Thread-Topic: [v3][PATCH 1/8] powerpc/book3e: rename interrupt_end_book3e
 with __end_interrupts
Thread-Index: AQHOfHsqYoeAliFjgkWssJZaQteYK5ldYJNA
Date: Wed, 10 Jul 2013 05:17:20 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D070AE11F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
 <1373357007-30785-2-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1373357007-30785-2-git-send-email-tiejun.chen@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
> Sent: Tuesday, July 09, 2013 1:33 PM
> To: benh@kernel.crashing.org
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: [v3][PATCH 1/8] powerpc/book3e: rename interrupt_end_book3e with
> __end_interrupts
> 
> We can rename 'interrupt_end_book3e' with '__end_interrupts' then book3s/book3e
> can share this unique label to make sure we can use this conveniently.

I think we can be consistent with start and end names, no?

-Bharat

> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/exceptions-64e.S |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S
> b/arch/powerpc/kernel/exceptions-64e.S
> index 645170a..a518e48 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -309,8 +309,8 @@ interrupt_base_book3e:					/* fake
> trap */
>  	EXCEPTION_STUB(0x300, hypercall)
>  	EXCEPTION_STUB(0x320, ehpriv)
> 
> -	.globl interrupt_end_book3e
> -interrupt_end_book3e:
> +	.globl __end_interrupts
> +__end_interrupts:
> 
>  /* Critical Input Interrupt */
>  	START_EXCEPTION(critical_input);
> @@ -493,7 +493,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
>  	beq+	1f
> 
>  	LOAD_REG_IMMEDIATE(r14,interrupt_base_book3e)
> -	LOAD_REG_IMMEDIATE(r15,interrupt_end_book3e)
> +	LOAD_REG_IMMEDIATE(r15,__end_interrupts)
>  	cmpld	cr0,r10,r14
>  	cmpld	cr1,r10,r15
>  	blt+	cr0,1f
> @@ -559,7 +559,7 @@ kernel_dbg_exc:
>  	beq+	1f
> 
>  	LOAD_REG_IMMEDIATE(r14,interrupt_base_book3e)
> -	LOAD_REG_IMMEDIATE(r15,interrupt_end_book3e)
> +	LOAD_REG_IMMEDIATE(r15,__end_interrupts)
>  	cmpld	cr0,r10,r14
>  	cmpld	cr1,r10,r15
>  	blt+	cr0,1f
> --
> 1.7.9.5
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


