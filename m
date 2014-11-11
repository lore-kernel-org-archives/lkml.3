Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaKKT6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:58:39 -0500
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:11264
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751538AbaKKT6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:58:37 -0500
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2014 14:58:37 EST
Date: Tue, 11 Nov 2014 13:41:09 -0600
From: Graham Moore <grmoore@opensource.altera.com>
X-X-Sender: lavauser@lava-test-server
To: bpqw <bpqw@micron.com>
CC: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        Graham Moore <grmoore@opensource.altera.com>
Subject: Re: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
In-Reply-To: <54613259.4070903@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1411111336010.1356@lava-test-server>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com> <201409251211.57183.marex@denx.de> <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com> <201409261046.07132.marex@denx.de> <A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
 <54613259.4070903@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR12CA0031.namprd12.prod.outlook.com (25.160.137.41) To
 BY2PR03MB441.namprd03.prod.outlook.com (10.141.141.142)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB441;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB441;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(199003)(189002)(164054003)(479174003)(24454002)(377454003)(54356999)(31966008)(4396001)(105586002)(77096003)(62966003)(77156002)(120916001)(122386002)(76176999)(97736003)(99396003)(106356001)(95666004)(83506001)(42186005)(81156004)(33716001)(53416004)(40100003)(50986999)(93886004)(102836001)(107046002)(20776003)(87976001)(66066001)(23726002)(64706001)(50466002)(46102003)(46406003)(101416001)(47776003)(92566001)(69596002)(21056001)(86362001)(110136001)(92726001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB441;H:lava-test-server.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB441;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 09:09 PM, bpqw wrote:
> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.
> 
> For Micron SPI NOR flash,enabling or disabling quad I/O protocol is
> controlled
> by EVCR (Enhanced Volatile Configuration Register), Quad I/O protocol bit 7.
> When EVCR bit 7 is reset to 0,the SPI NOR flash will operate in quad I/O
> mode.

Hi, I'm having trouble with this patch using a Cadence QSPI controller and
Micron n25q00 part.

I can use quad commands in Extended SPI mode, but I can't make this EVCR Quad
mode work.

The Cadence QSPI Controller has fields to configure the quad transfer, and can
support quad opcode, quad address, and quad data, or some combination.  There
is a chart in the docs which shows the combinations for various read commands.

Problem is, I've tried all of the combinations and all I get is FF with this
EVCR patch.

If I don't set the quad mode in the EVCR, then I can use quad read commands no
problem.

Bottom line, with the Cadence QSPI controller, if I use quad commands in
Extended SPI mode, then all good.  If I use this EVCR quad mode, then all bad.

Anybody else have a Cadence QSPI controller and using EVCR quad mode
successfully?

Thanks,
Graham Moore

