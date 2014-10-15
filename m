Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaJOTyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:54:25 -0400
Received: from mail-bl2on0056.outbound.protection.outlook.com ([65.55.169.56]:38400
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751536AbaJOTyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:54:24 -0400
Date: Wed, 15 Oct 2014 14:50:32 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
X-X-Sender: dinguyen@linux-builds1
To: Alan Tull <atull@opensource.altera.com>
CC: <linux@arm.linux.org.uk>, <pavel@denx.de>, <arnd@arndb.de>,
        <s.trumtrar@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v3 0/2] socfpga: fix hotplug/add suspend to ram
In-Reply-To: <1413315219-28885-1-git-send-email-atull@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1410151449060.16697@linux-builds1>
References: <1413315219-28885-1-git-send-email-atull@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN3PR0301CA0035.namprd03.prod.outlook.com (25.160.180.173)
 To BY1PR0301MB1191.namprd03.prod.outlook.com (25.160.195.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1191;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(51704005)(24434003)(24454002)(77096002)(46406003)(19580405001)(95666004)(83506001)(69596002)(19580395003)(87976001)(85852003)(50466002)(40100003)(31966008)(99396003)(4396001)(101416001)(110136001)(102836001)(120916001)(42186005)(33716001)(66066001)(64706001)(20776003)(53416004)(21056001)(92726001)(122386002)(97736003)(23726002)(85306004)(105586002)(92566001)(80022003)(86362001)(46102003)(107046002)(106356001)(81156004)(54356999)(76482002)(50986999)(76176999);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1191;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014, atull@opensource.altera.com wrote:

> From: Alan Tull <atull@opensource.altera.com>
> 
> Patch 1: socfpga: hotplug: put cpu1 in wfi
>   Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
>   since that results in increased power consumption.  Only
>   briefly reset CPU1.
> 
> Patch 2: socfpga: support suspend to ram
>   * allocate space in ocram using sram driver
>   * Add a function in ocram to do suspend to ram and
>     place DDR in self-refresh
> 
> Alan Tull (2):
>   socfpga: hotplug: put cpu1 in wfi
>   socfpga: support suspend to ram
> 
>  arch/arm/mach-socfpga/Kconfig        |    1 +
>  arch/arm/mach-socfpga/Makefile       |    1 +
>  arch/arm/mach-socfpga/core.h         |    7 ++
>  arch/arm/mach-socfpga/platsmp.c      |   19 ++--
>  arch/arm/mach-socfpga/pm.c           |  150 ++++++++++++++++++++++++++++++++
>  arch/arm/mach-socfpga/self-refresh.S |  157 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-socfpga/socfpga.c      |   10 +++
>  7 files changed, 337 insertions(+), 8 deletions(-)
>  create mode 100644 arch/arm/mach-socfpga/pm.c
>  create mode 100644 arch/arm/mach-socfpga/self-refresh.S
>

I've applied both patches. I just had to fixup a minor checkpatch error with
the 2nd patch:

ERROR: trailing whitespace
#284: FILE: arch/arm/mach-socfpga/self-refresh.S:34:
+^I/*^I$

total: 1 errors, 1 warnings, 354 lines checked

BR,
Dinh
