Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaDHQre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:47:34 -0400
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:16075
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756894AbaDHQrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:47:33 -0400
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 12:47:32 EDT
From: <grmoore@altera.com>
To: <ggrahammoore@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marex@denx.de>,
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
Subject: [PATCH] Add support for flag status register on Micron chips   
Date: Tue, 8 Apr 2014 11:12:49 -0500
Message-ID: <1396973570-13995-1-git-send-email-grmoore@altera.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(199002)(189002)(97186001)(77156001)(5?=
 =?us-ascii?Q?6776001)(20776003)(79102001)(86362001)(33646001)(76786001)(8?=
 =?us-ascii?Q?1542001)(85852003)(76796001)(81342001)(6806004)(83072002)(49?=
 =?us-ascii?Q?866001)(87936001)(98676001)(95666003)(46102001)(50226001)(80?=
 =?us-ascii?Q?976001)(19580395003)(97336001)(47736002)(54316003)(47446003)?=
 =?us-ascii?Q?(47976002)(85306002)(81816001)(94316002)(62966002)(94946001)?=
 =?us-ascii?Q?(88136002)(19580405001)(93516002)(53416003)(44976005)(636960?=
 =?us-ascii?Q?02)(83322001)(87286001)(90146001)(74366001)(97736001)(200900?=
 =?us-ascii?Q?1)(15395725003)(59766001)(4396001)(74662001)(74502001)(92726?=
 =?us-ascii?Q?001)(31966008)(69226001)(93916002)(99396002)(92566001)(76482?=
 =?us-ascii?Q?001)(48376002)(81686001)(80022001)(36756003)(95416001)(87266?=
 =?us-ascii?Q?001)(56816005)(86152002)(65816001)(84676001)(74706001)(89996?=
 =?us-ascii?Q?001)(15202345003)(77096001)(50466002)(77982001)(74876001)(76?=
 =?us-ascii?Q?176001)(47776003)(93136001)(15975445006)(50986002)(53806002)?=
 =?us-ascii?Q?(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11HUB039;H:S?=
 =?us-ascii?Q?J-ITEXEDGE02.altera.priv.altera.com;FPR:9EC0F31A.2A328F17.BE?=
 =?us-ascii?Q?99FF7.44E839BA.20201;MLV:sfv;PTR:InfoDomainNonexistent;A:1;M?=
 =?us-ascii?Q?X:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 017589626D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graham Moore <grmoore@altera.com>

This is a slightly different version of the patch that Insop Song
submitted (http://marc.info/?i=201403012022.10111.marex%20()%20denx%20!%20de).

I talked to Insop, and he agreed I should submit this patch as a follow-on to his.

This patch uses a flag in the m25p_ids[] array to determine which chips need
to use the FSR (Flag Status Register).

Rationale for using the FSR:

The Micron data sheets say we have to do this, at least for the multi-die 512M 
and 1G parts (n25q512 and n25q00).  In practice, if we don't check the FSR 
for program/erase status, and we rely solely on the status register (SR), 
then we get corrupted data in the flash.

Micron told us (Altera) that for multi-die chips based on the 65nm 256MB
die, we need to check the SR first, then check the FSR, which is why the 
wait_for_fsr_ready function does that.  Future chips based on 45 nm 512MB die 
will use the FSR only.              

Thanks.

Graham Moore (1):
  Add support for flag status register on Micron chips.

 drivers/mtd/devices/m25p80.c |   94 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 80 insertions(+), 14 deletions(-)

-- 
1.7.10.4

