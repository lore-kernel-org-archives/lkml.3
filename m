Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaJ0TLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:11:08 -0400
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:38286
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753663AbaJ0TEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:22 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 15:04:21 EDT
Message-ID: <544E93F0.3030409@opensource.altera.com>
Date: Mon, 27 Oct 2014 13:50:24 -0500
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@altera.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: Re: [PATCHv2 0/4] Add Altera peripheral memories to EDAC framework
References: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
In-Reply-To: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR10CA0024.namprd10.prod.outlook.com (25.160.213.34) To
 BLUPR03MB119.namprd03.prod.outlook.com (10.255.212.20)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB119;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(164054003)(51704005)(24454002)(377454003)(479174003)(189002)(199003)(59896002)(87976001)(2201001)(92566001)(21056001)(31966008)(99396003)(83506001)(85852003)(64706001)(65806001)(80316001)(120916001)(47776003)(19580405001)(66066001)(86362001)(65956001)(20776003)(23746002)(85306004)(19580395003)(76482002)(97736003)(33656002)(54356999)(76176999)(87266999)(50986999)(42186005)(50466002)(46102003)(95666004)(105586002)(107046002)(92726001)(80022003)(106356001)(122386002)(101416001)(40100003)(102836001)(77096002)(4396001)(1121002)(921003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB119;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On 10/17/2014 03:33 PM, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
>
> This patch adds the L2 cache and OCRAM peripherals to the EDAC framework
> using the EDAC device framework. The ECC is enabled early in the boot
> process in the platform specific code.
>
> Thor Thayer (4):
>    arm: socfpga: Enable L2 Cache ECC on startup.
>    arm: socfpga: Enable OCRAM ECC on startup.
>    edac: altera: Add Altera L2 Cache and OCRAM EDAC Support
>    arm: dts: Add Altera L2 Cache and OCRAM EDAC
>
>   .../bindings/arm/altera/socfpga-l2-edac.txt        |   15 ++
>   .../bindings/arm/altera/socfpga-ocram-edac.txt     |   16 ++
>   MAINTAINERS                                        |    4 +-
>   arch/arm/boot/dts/socfpga.dtsi                     |   15 +-
>   arch/arm/mach-socfpga/Makefile                     |    2 +
>   arch/arm/mach-socfpga/l2_cache.c                   |   44 ++++
>   arch/arm/mach-socfpga/l2_cache.h                   |   28 +++
>   arch/arm/mach-socfpga/ocram.c                      |   90 +++++++
>   arch/arm/mach-socfpga/ocram.h                      |   28 +++
>   arch/arm/mach-socfpga/socfpga.c                    |   13 +-
>   drivers/edac/Kconfig                               |   14 ++
>   drivers/edac/Makefile                              |    3 +
>   drivers/edac/altera_edac_mgr.c                     |  261 ++++++++++++++++++++
>   drivers/edac/altera_edac_mgr.h                     |   56 +++++
>   drivers/edac/altera_l2_edac.c                      |  130 ++++++++++
>   drivers/edac/altera_ocram_edac.c                   |  107 ++++++++
>   16 files changed, 823 insertions(+), 3 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
>   create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
>   create mode 100644 arch/arm/mach-socfpga/l2_cache.c
>   create mode 100644 arch/arm/mach-socfpga/l2_cache.h
>   create mode 100644 arch/arm/mach-socfpga/ocram.c
>   create mode 100644 arch/arm/mach-socfpga/ocram.h
>   create mode 100644 drivers/edac/altera_edac_mgr.c
>   create mode 100644 drivers/edac/altera_edac_mgr.h
>   create mode 100644 drivers/edac/altera_l2_edac.c
>   create mode 100644 drivers/edac/altera_ocram_edac.c
>
Do you have any comments about this driver?

Thanks,

Thor
