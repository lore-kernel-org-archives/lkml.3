Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbaFWTxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:53:10 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:13163
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756731AbaFWTxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:53:08 -0400
Message-ID: <1403553015.9081.7.camel@linux-builds1>
Subject: Re: [PATCH V2] In the Denali NAND controller driver, use 8 bytes
 for READID command.
From: Dinh Nguyen <dinguyen@altera.com>
To: Graham Moore <grmoore@altera.com>
CC: <ggrahammoore@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Alan Tull <atull@altera.com>,
        "Yves Vandervennet" <rocket.yvanderv@gmail.com>
Date: Mon, 23 Jun 2014 14:50:15 -0500
In-Reply-To: <1403551270-31873-1-git-send-email-grmoore@altera.com>
References: <1403551270-31873-1-git-send-email-grmoore@altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(377424004)(51704005)(199002)(189002)(24454002)(99396002)(4396001)(85852003)(77156001)(83072002)(88136002)(50986999)(76176999)(89996001)(76482001)(50226001)(97736001)(92566001)(92726001)(86362001)(93916002)(21056001)(50466002)(64706001)(79102001)(23676002)(20776003)(77982001)(68736004)(87286001)(19580395003)(19580405001)(44976005)(87936001)(83322001)(84676001)(80022001)(46102001)(95666004)(6806004)(85306003)(106466001)(105596002)(31966008)(104166001)(103116003)(102836001)(77096002)(33716001)(81542001)(62966002)(74662001)(74502001)(33646001)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB030;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=dinguyen@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graham,

On Mon, 2014-06-23 at 14:21 -0500, Graham Moore wrote:
> The Denali NAND driver reads only 5 bytes of ID, but some Hynix and Samsung
> have size parameters in the 6th byte.  As a result, the page and oob size
> for a Hynix H27UAG8T2B were calculated incorrectly and the driver failed to
> load.
> 
> The solution is to read 8 bytes of ID, as expected by the nand framework.
> 
> Signed-off-by: Graham Moore <grmoore@altera.com>
> --
> V2: Increase size of id_bytes array to 8.
> ---
>  drivers/mtd/nand/denali.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Your commit header should have "mtd: denali:"

i.e: "mtd: denali: use 8 bytes for READID command"

Dinh

