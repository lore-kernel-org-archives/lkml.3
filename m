Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaE2SgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:36:17 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:30275
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751206AbaE2SgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:36:16 -0400
Message-ID: <1401387624.6603.161.camel@snotra.buserror.net>
Subject: Re: [PATCH] pcmcia: m8xx: remove checks for four macros
From: Scott Wood <scottwood@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-pcmcia@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>
Date: Thu, 29 May 2014 13:20:24 -0500
In-Reply-To: <1400916970.31526.78.camel@x220>
References: <1400916970.31526.78.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:d1b9:9316:96e:1a3c]
X-ClientProxiedBy: DM2PR06CA006.namprd06.prod.outlook.com (10.141.96.36) To
 DM2PR03MB397.namprd03.prod.outlook.com (10.141.84.139)
X-Forefront-PRVS: 022649CC2C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(377424004)(24454002)(103116003)(81542001)(93916002)(20776003)(4396001)(86362001)(33646001)(64706001)(31966008)(76482001)(47776003)(99396002)(23676002)(81342001)(79102001)(50986999)(76176999)(89996001)(92726001)(92566001)(80022001)(62966002)(87976001)(83072002)(88136002)(85852003)(50226001)(77982001)(74502001)(42186004)(101416001)(46102001)(74662001)(77156001)(19580405001)(83322001)(19580395003)(102836001)(21056001)(87286001)(50466002)(104166001)(32563001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB397;H:[IPv6:2601:2:5800:3f7:d1b9:9316:96e:1a3c];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-24 at 09:36 +0200, Paul Bolle wrote:
> This driver contains checks for four Kconfig macros. But the related
> Kconfig symbols have never been part of the tree. Remove these checks
> and the code they hide.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> This has been an issue ever since this driver was added in v2.6.15. Note
> that there is no header named "*/cpld.h", so setting PRxK can't possibly
> work.
> 
>  drivers/pcmcia/m8xx_pcmcia.c | 75 --------------------------------------------
>  1 file changed, 75 deletions(-)

Does anything in this driver still work?  It looks like bitrot from the
arch/ppc days, that sort of got updated to use the device tree -- but
even after this patch there are lots of instances of CONFIG symbols
being used to assert the exact hardware being used, rather than what
hardware is supported.

Is anyone actively maintaining/testing this code?

-Sott


