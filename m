Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaLCOtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:49:04 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50952 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCOtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:49:02 -0500
Message-ID: <1417618130.10667.102.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RESEND PATCH] ima: Fix build failure on powerpc when
 TCG_IBMVTPM dependencies are not met
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, Lo Hon Ching <lo1@us.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, George Wilson <gcwilson@us.ibm.com>
Date: Wed, 03 Dec 2014 09:48:50 -0500
In-Reply-To: <1417586690-11521-1-git-send-email-mpe@ellerman.id.au>
References: <1417586690-11521-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120314-0033-0000-0000-00000321D6E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 17:04 +1100, Michael Ellerman wrote: 
> On powerpc we can end up with IMA=y and PPC_PSERIES=n which leads to:
> 
>   warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES)
>   tpm_ibmvtpm.c:(.text+0x14f3e8): undefined reference to `.plpar_hcall_norets'
> 
> I'm not sure why IMA needs to select those user-visible symbols, but if
> it must then the simplest fix is to just express the proper dependencies
> on the select.

On systems without a TPM, IMA goes into a "by-pass" mode, which stores
the measurements without extending the TPM PCR.  On Power, there isn't a
HW TPM, but on Power running PowerVM there is a virtual TPM(vTPM).  On
Power running PowerKVM there isn't support for vTPM, yet.  The Kconfig
needs to differentiate between the two.

> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

[CC'ing: Vicky(Lo, Hon Ching), Ashley Lai, George Wilson]
Sorry, I'm still waiting to hear back from the developers/testers.

Mimi

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


