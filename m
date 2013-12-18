Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3LRDuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:50:50 -0500
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:50765
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab3LRDut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:50:49 -0500
Message-ID: <1387338638.3140.43.camel@snotra.buserror.net>
Subject: Re: [v3][PATCH 8/8] book3e/kexec/kdump: recover "r4 = 0" to create
 the initial TLB
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 21:50:38 -0600
In-Reply-To: <1373357007-30785-9-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
	 <1373357007-30785-9-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR06CA015.namprd06.prod.outlook.com (10.141.56.35) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(377424004)(24454002)(51704005)(189002)(199002)(81342001)(47446002)(31966008)(81542001)(80022001)(74662001)(74502001)(74876001)(62966002)(33646001)(74706001)(50226001)(50466002)(77156001)(76796001)(79102001)(49866001)(65816001)(47736001)(4396001)(47976001)(81686001)(83322001)(19580405001)(63696002)(47776003)(81816001)(50986001)(23676002)(19580395003)(56816005)(80976001)(85306002)(89996001)(51856001)(76482001)(90146001)(53806001)(42186004)(54316002)(87286001)(87266001)(77096001)(77982001)(76786001)(83072002)(74366001)(56776001)(46102001)(59766001)(87976001)(69226001)(85852003)(88136002)(32563001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 16:03 +0800, Tiejun Chen wrote:
> In commit 96f013f, "powerpc/kexec: Add kexec "hold" support for Book3e
> processors", requires that GPR4 survive the "hold" process, for IBM Blue
> Gene/Q with with some very strange firmware. But for FSL Book3E, r4 = 1
> to indicate that the initial TLB entry for this core already exists so
> we still should set r4 with 0 to create that initial TLB.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/head_64.S |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
> index 0b46c9d..d546c5e 100644
> --- a/arch/powerpc/kernel/head_64.S
> +++ b/arch/powerpc/kernel/head_64.S
> @@ -127,6 +127,10 @@ __secondary_hold:
>  	/* Grab our physical cpu number */
>  	mr	r24,r3
>  	/* stash r4 for book3e */
> +#ifdef CONFIG_PPC_FSL_BOOK3E
> +	/* we need to setup initial TLB entry. */
> +	li	r4,0
> +#endif
>  	mr	r25,r4

This breaks being able to build one kernel that supports both FSL book3e
and IBM book3e.

-Scott


