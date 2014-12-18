Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaLRCyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:54:13 -0500
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:11537
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751489AbaLRCyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:54:11 -0500
Message-ID: <1418869363.5581.123.camel@freescale.com>
Subject: Re: [v2 PATCH 2/2] powerpc/8xx: use _PAGE_RO instead of _PAGE_RW
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
Date: Wed, 17 Dec 2014 20:22:43 -0600
In-Reply-To: <20141217091432.072901A5E12@localhost.localdomain>
References: <20141217091432.072901A5E12@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BY2PR06CA059.namprd06.prod.outlook.com (10.141.250.177) To
 BY2PR0301MB0726.namprd03.prod.outlook.com (25.160.63.16)
Authentication-Results: c-s.fr; dkim=none (message not signed) header.d=none;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0726;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0726;
X-Forefront-PRVS: 042957ACD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377424004)(24454002)(51704005)(77156002)(19580405001)(33646002)(36756003)(105586002)(103116003)(21056001)(106356001)(42186005)(68736005)(107046002)(2950100001)(64706001)(97736003)(23676002)(87976001)(122386002)(50986999)(86362001)(76176999)(92566001)(89996001)(46102003)(110136001)(20776003)(47776003)(62966003)(120916001)(50226001)(31966008)(101416001)(4396001)(40100003)(99396003)(50466002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0726;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0726;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 10:14 +0100, Christophe Leroy wrote:
> On powerpc 8xx, in TLB entries, 0x400 bit is set to 1 for read-only pages
> and is set to 0 for RW pages. So we should use _PAGE_RO instead of _PAGE_RW
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
> v2 is a complete rework compared to v1
> 
>  arch/powerpc/include/asm/pte-8xx.h | 7 +++----
>  arch/powerpc/kernel/head_8xx.S     | 3 ---
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
> index daa4616..4f5583e 100644
> --- a/arch/powerpc/include/asm/pte-8xx.h
> +++ b/arch/powerpc/include/asm/pte-8xx.h
> @@ -46,7 +46,7 @@
>   * require a TLB exception handler change.  It is assumed unused bits
>   * are always zero.
>   */
> -#define _PAGE_RW	0x0400	/* lsb PP bits, inverted in HW */
> +#define _PAGE_RO	0x0400	/* lsb PP bits */

It looks like pte_update() needs to be updated to match.

>  #define _PAGE_USER	0x0800	/* msb PP bits */
>  /* set when neither _PAGE_USER nor _PAGE_RW are set */

Also update this comment.

>  #define _PAGE_KNLRO	0x0200
> @@ -62,9 +62,8 @@
>  #define PTE_ATOMIC_UPDATES	1
>  
>  /* We need to add _PAGE_SHARED to kernel pages */
> -#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_KNLRO)
> -#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_KNLRO)
> -#define _PAGE_KERNEL_RW	(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)
> +#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_RO | _PAGE_KNLRO)
> +#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_RO | _PAGE_KNLRO)
>  
>  #endif /* __KERNEL__ */
>  #endif /*  _ASM_POWERPC_PTE_8xx_H */

Where did _PAGE_KERNEL_RW go?

-Scott


