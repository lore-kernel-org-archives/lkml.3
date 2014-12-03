Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaLCNKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:10:48 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48266 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaLCNKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:10:45 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0f-547f0bd25c26
Message-id: <547F0B6B.3030206@samsung.com>
Date: Wed, 03 Dec 2014 15:08:59 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, james.l.morris@oracle.com, serge@hallyn.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Subject: Re: [RESEND PATCH] ima: Fix build failure on powerpc when TCG_IBMVTPM
 dependencies are not met
References: <1417586690-11521-1-git-send-email-mpe@ellerman.id.au>
In-reply-to: <1417586690-11521-1-git-send-email-mpe@ellerman.id.au>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xq7qXuOtDDDad57Poexxk8XLGPHaL
	y7vmsFl86HnEZrGl4RCbxfkL59gtPq2YxOzA7rHoZQOLx7XdkR4PDm1m8di94DOTx8ent1g8
	Pm+SC2CL4rJJSc3JLEst0rdL4MpY1HqCvWAWV8Wi/S9ZGhgXcHQxcnBICJhI/Ftg3sXICWSK
	SVy4t54NxBYSWMoo8e9UUhcjF5DdyCTRues4G4Qzi1Fi8on7YFW8AloSy7fuZgaxWQRUJSZf
	OsYOYrMJ6ElsaP4BZosKREhcWTOHEaJeUOLH5HssILaIgLtE29vP7CBDmQVmMkqcePYRbKiw
	QKZE14KZUGc4ScybtBWsmVPAWeLc4anMIFczAy24f1ELJMwsIC+xec1bZohyVYnutWvZIL5R
	lDg9+RzzBEbhWUhWz0LonoWkewEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkIj5soNx
	8TGrQ4wCHIxKPLwKU+pChFgTy4orcw8xSnAwK4nwPvsGFOJNSaysSi3Kjy8qzUktPsTIxMEp
	1cDYuvZH3NTY15xJjH/MvEUm3l8wf1f7pz+8GxafaEhZ8n1uXq1L62/WRTrBW7dvb1TOi+wK
	F3JXvaezas2zqHVHvsVv7Sw64Ked8H/lmVfqagqfwqdXH/q3eNIkxSxBhSm7nee1nCn6qz99
	+8dSmcjJH4yM/N8+F7j66+gk3nq959vnVJdfDBW0UGIpzkg01GIuKk4EALSc8C12AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Yes, we will pick it up.

Thanks,
Dmitry

On 03/12/14 08:04, Michael Ellerman wrote:
> On powerpc we can end up with IMA=y and PPC_PSERIES=n which leads to:
>
>   warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES)
>   tpm_ibmvtpm.c:(.text+0x14f3e8): undefined reference to `.plpar_hcall_norets'
>
> I'm not sure why IMA needs to select those user-visible symbols, but if
> it must then the simplest fix is to just express the proper dependencies
> on the select.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  security/integrity/ima/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> Could someone please pick this up?
>
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index e099875643c5..b51668d04f9d 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -10,7 +10,7 @@ config IMA
>  	select CRYPTO_HASH_INFO
>  	select TCG_TPM if HAS_IOMEM && !UML
>  	select TCG_TIS if TCG_TPM && X86
> -	select TCG_IBMVTPM if TCG_TPM && PPC64
> +	select TCG_IBMVTPM if TCG_TPM && PPC_PSERIES
>  	help
>  	  The Trusted Computing Group(TCG) runtime Integrity
>  	  Measurement Architecture(IMA) maintains a list of hash

