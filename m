Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbaKMQ3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:29:35 -0500
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:57173
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753928AbaKMQ3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:29:34 -0500
Date: Thu, 13 Nov 2014 10:26:39 -0600
From: Graham Moore <grmoore@opensource.altera.com>
X-X-Sender: lavauser@lava-test-server
To: bpqw <bpqw@micron.com>
CC: Graham Moore <grmoore@opensource.altera.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marex@denx.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>
Subject: RE: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315EB0DA@NTXXIAMBX02.xacn.micron.com>
Message-ID: <alpine.DEB.2.02.1411130945300.19890@lava-test-server>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com> <201409251211.57183.marex@denx.de> <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com> <201409261046.07132.marex@denx.de> <A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
 <54613259.4070903@opensource.altera.com> <alpine.DEB.2.02.1411111336010.1356@lava-test-server> <A765B125120D1346A63912DDE6D8B6315EB0DA@NTXXIAMBX02.xacn.micron.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR05CA034.namprd05.prod.outlook.com (10.141.250.24) To
 BLUPR03MB438.namprd03.prod.outlook.com (10.141.78.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB438;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB438;
X-Forefront-PRVS: 0394259C80
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(164054003)(24454002)(189002)(199003)(31966008)(69596002)(120916001)(42186005)(92726001)(99396003)(83506001)(33716001)(4396001)(93886004)(92566001)(46102003)(87976001)(122386002)(40100003)(50466002)(102836001)(53416004)(105586002)(106356001)(81156004)(95666004)(97736003)(107046002)(46406003)(20776003)(23726002)(47776003)(86362001)(110136001)(21056001)(101416001)(66066001)(77096003)(77156002)(54356999)(76176999)(50986999)(62966003)(64706001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB438;H:lava-test-server.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB438;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Nov 2014, bpqw wrote:

> This maybe your spi controller is still extended mode, 
> Once EVCR bit 7 is set to 0, the spi nor device will operate in quad I/O.Command-address-data line is 4-x-4.
> So after send WRITE EVCR command , spi controller also  must transfer to quad I/O Mode,and set its Command-address-data line also
> Should be 4-x-4 .

Thanks, this helped.  I added some code to snoop the command stream for 
WRITE EVCR with quad mode, and then set up the quad mode in the 
controller.  Seems kinda ugly, but working now.

-Graham
