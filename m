Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaKFRfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:35:51 -0500
Received: from [65.55.169.54] ([65.55.169.54]:41280 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325AbaKFRfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:35:50 -0500
Date: Thu, 6 Nov 2014 09:33:54 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <stable@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: zynq: Enable PL clocks for Parallella
References: <1415294531-8942-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415294531-8942-1-git-send-email-afaerber@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21078.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <e78290abdb85497081f502e5886bf045@BL2FFO11FD057.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(24454002)(51704005)(189002)(377424004)(6806004)(64706001)(53416004)(110136001)(107046002)(47776003)(44976005)(21056001)(83506001)(20776003)(92566001)(86362001)(4396001)(54356999)(95666004)(104016003)(50466002)(106466001)(99396003)(85182001)(77096003)(23676002)(87936001)(77156002)(50986999)(102836001)(85202003)(76176999)(108616004)(74316001)(46102003)(120916001)(62966003)(31966008)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB065;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB065;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Thu, 2014-11-06 at 06:22PM +0100, Andreas Färber wrote:
> The Parallella board comes with a U-Boot bootloader that loads one of
> two predefined FPGA bitstreams before booting the kernel. Both define an
> AXI interface to the on-board Epiphany processor.
> 
> Enable clocks FCLK0..FCLK3 for the Programmable Logic by default.
> 
> Otherwise accessing, e.g., the ESYSRESET register freezes the board,
> as seen with the Epiphany SDK tools e-reset and e-hw-rev, using /dev/mem.

Yeah, this is the problem. Bypassing the kernel banging on memory
directly through /dev/mem does not leave any chance of enabling clocks on
demand through the proper interfaces.

Though, this is a valid workaround for the immediate problem, longer
term, you should consider adding some kind of proper kernel driver for
this interface that would then use the clock framework to control the
required clocks dynamically.

	Sören
