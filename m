Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaIDGU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:20:58 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:29651
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932425AbaIDGU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:20:57 -0400
From: "B47624@freescale.com" <B47624@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Peter Chen <Peter.Chen@freescale.com>, "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
CC: "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>,
        "yoshihiro.shimoda.uh@renesas.com" <yoshihiro.shimoda.uh@renesas.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Thread-Topic: [PATCH v4 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Thread-Index: AQHPx0rQ0P29X51Z3UWyNKdXHsVhzJvwgAJA
Date: Thu, 4 Sep 2014 06:20:53 +0000
Message-ID: <f2992755648f428b9af45b75275cad48@BN1PR03MB186.namprd03.prod.outlook.com>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-10-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1409730040-14200-10-git-send-email-antoine.tenart@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(13464003)(189002)(199003)(76576001)(66066001)(46102001)(74502001)(76482001)(77982001)(19580405001)(83322001)(64706001)(20776003)(74316001)(80022001)(106116001)(107046002)(33646002)(31966008)(99286002)(90102001)(95666004)(2501002)(108616004)(19580395003)(106356001)(105586002)(74662001)(15975445006)(81542001)(85306004)(2171001)(99396002)(81342001)(77096002)(15202345003)(50986999)(54356999)(76176999)(2656002)(85852003)(92566001)(2201001)(86362001)(83072002)(4396001)(21056001)(79102001)(101416001)(87936001)(24736002)(422495003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0773;H:BN1PR03MB186.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

-----Original Message-----
From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Antoine Tenart
Sent: Wednesday, September 03, 2014 3:41 PM
To: balbi@ti.com; gregkh@linuxfoundation.org; Chen Peter-B29397; kishon@ti.com; stern@rowland.harvard.edu
Cc: Antoine Tenart; sergei.shtylyov@cogentembedded.com; yoshihiro.shimoda.uh@renesas.com; alexandre.belloni@free-electrons.com; thomas.petazzoni@free-electrons.com; zmxu@marvell.com; jszhang@marvell.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH v4 9/9] usb: chipidea: add support to the generic PHY framework in ChipIdea

This patch adds support of the PHY framework for ChipIdea drivers.
Changes are done in both the ChipIdea common code and in the drivers accessing the PHY. This is done by adding a new PHY member in ChipIdea's structures and by taking care of it in the code.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/ci.h      |  5 ++-
 drivers/usb/chipidea/core.c    | 74 ++++++++++++++++++++++++++++++++++--------
 drivers/usb/chipidea/debug.c   |  3 +-
 drivers/usb/chipidea/host.c    |  5 ++-
 drivers/usb/chipidea/otg_fsm.c |  6 +++-
 include/linux/usb/chipidea.h   |  2 ++
 6 files changed, 78 insertions(+), 17 deletions(-)
...

diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c index 5a7ea93011dd..999e9d683d7a 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -219,7 +219,8 @@ static int ci_otg_show(struct seq_file *s, void *unused)
 	fsm = &ci->fsm;
 
 	/* ------ State ----- */
-		usb_otg_state_string(ci->usb_phy->otg.state));
+	seq_printf(s, "OTG state: %s\n\n",

Still not resolve this?

Li Jun 
+		   usb_otg_state_string(ci->otg.state)); 

 	/* ------ State Machine Variables ----- */
 	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop); diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c index 
--
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
