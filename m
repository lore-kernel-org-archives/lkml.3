Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaGBH4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:56:40 -0400
Received: from [207.46.163.141] ([207.46.163.141]:23192 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750895AbaGBH4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:56:39 -0400
Message-ID: <53B3B8B9.30400@Freescale.com>
Date: Wed, 2 Jul 2014 02:46:01 -0500
From: Emil Medve <Emilian.Medve@Freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Varun Sethi <Varun.Sethi@Freescale.com>,
        <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
 <1403618237-26248-2-git-send-email-Varun.Sethi__13822.953499812$1403630309$gmane$org@freescale.com>
In-Reply-To: <1403618237-26248-2-git-send-email-Varun.Sethi__13822.953499812$1403630309$gmane$org@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(377454003)(479174003)(24454002)(189002)(199002)(51704005)(107886001)(83072002)(107046002)(69596002)(104016002)(84676001)(2201001)(44976005)(92726001)(83322001)(4396001)(85306003)(95666004)(33656002)(68736004)(19580395003)(80022001)(65806001)(19580405001)(50466002)(105606002)(76482001)(21056001)(106466001)(81156004)(79102001)(74662001)(65816999)(46102001)(20776003)(102836001)(47776003)(87936001)(81542001)(6806004)(50986999)(83506001)(54356999)(76176999)(36756003)(23676002)(86362001)(97736001)(31966008)(74502001)(26826002)(77982001)(64706001)(64126003)(92566001)(85852003)(65956001)(99396002)(81342001)(2101003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB480;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0260457E99
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Emilian.Medve@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 08:57 AM, Varun Sethi wrote:
> is_power_of_2 requires an unsigned long parameter which would
> lead to truncation of 64 bit values on 32 bit architectures.
> 
> __ffs also expects an unsigned long parameter thus won't work
> for 64 bit values on 32 bit architectures.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
>  drivers/iommu/fsl_pamu.c        |    8 ++++----
>  drivers/iommu/fsl_pamu_domain.c |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)

Tested-by: Emil Medve <Emilian.Medve@Freescale.com>

On a P4080 DS (i.e. 32-bit SoC)


Cheers,
