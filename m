Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaDVOEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:04:00 -0400
Received: from mail-bn1on0139.outbound.protection.outlook.com ([157.56.110.139]:21832
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755973AbaDVOD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:03:56 -0400
From: Graham Moore <grmoore@altera.com>
To: <ggrahammoore@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>, ZY - marex <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>,
        Graham Moore <grmoore@altera.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH V3] Add support for flag status register on Micron chips.
Date: Tue, 22 Apr 2014 09:03:15 -0500
Message-ID: <1398175396-7560-1-git-send-email-grmoore@altera.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(36756003)(77156001)(47776003)(92726001)(77982001)(85852003)(76482001)(2009001)(20776003)(89996001)(87936001)(33646001)(84676001)(83322001)(97736001)(92566001)(87286001)(6806004)(44976005)(62966002)(86362001)(53416003)(80022001)(74662001)(50466002)(74502001)(4396001)(31966008)(80976001)(48376002)(81542001)(50986999)(99396002)(83072002)(50226001)(46102001)(81342001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB009;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:FC62F0FE.8E2C573A.23F9BB84.C4F03B41.201DF;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01894AD3B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rebased this patch onto the l2-mtd spinor branch.  Sorry it took so long, had to patch for our SoC, corporate network issues, etc.

The change to read the flag status register is, afaik, specific to Micron chips.  So, imo, the fsr ready check should be in the m25p80.c file.  But I put it into the spin-nor.c file, because I need to call the read_sr() function, which is declared static in spi-nor.c.

I *could* duplicate the read_sr code and put the wait_till_fsr_ready in m25p80, but I'm pretty sure that would attract some critique :)  Suggestions most welcome.

I also used n25q512ax3 for the id because there are two part numbers for the 512MB part with FSR, n25q512a13 and n25qa512a83.  The '83' version has a reset line.

Graham Moore (1):
  Add support for flag status register on Micron chips.

 drivers/mtd/spi-nor/spi-nor.c |   51 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/spi-nor.h   |    4 ++++
 2 files changed, 55 insertions(+)

-- 
1.7.9.5

