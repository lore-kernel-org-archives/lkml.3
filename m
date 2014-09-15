Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaIPCX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:23:59 -0400
Received: from mail-bl2on0126.outbound.protection.outlook.com ([65.55.169.126]:10144
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752861AbaIPCXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:23:53 -0400
X-Greylist: delayed 3581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 22:23:53 EDT
Date: Mon, 15 Sep 2014 18:44:23 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: "J. German Rivera" <German.Rivera@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <Kim.Phillips@freescale.com>, <scottwood@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 0/4] drivers/bus: Freescale Management Complex bus
 driver patch series
Message-ID: <20140915184423.2189d18282c9c2030e564f7c@freescale.com>
In-Reply-To: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(164054003)(46102001)(88136002)(83072002)(62966002)(110136001)(77156001)(6806004)(92566001)(87286001)(85852003)(104166001)(50226001)(84676001)(50466002)(47776003)(4396001)(44976005)(89996001)(64706001)(83322001)(104016003)(19580395003)(107046002)(19580405001)(95666004)(105606002)(102836001)(85306004)(26826002)(68736004)(46406003)(106466001)(97736003)(21056001)(81542001)(79102001)(80022001)(76176999)(99396002)(100306002)(50986999)(92726001)(81342001)(23726002)(86362001)(93916002)(33646002)(76482001)(20776003)(87936001)(31966008)(77982001)(74662001)(74502001)(90102001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0713;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 12:34:20 -0500
"J. German Rivera" <German.Rivera@freescale.com> wrote:

> This patch series introduces Linux support for the Freescale
> Management Complex (fsl-mc) hardware.

here are the results of using some tools to check this patchseries:

make C=1 CF="-D__CHECK_ENDIAN__":

drivers/bus/fsl-mc/fsl_mc_sys.c:235:9: warning: context imbalance in 'mc_send_command' - different lock contexts for basic block
drivers/bus/fsl-mc/fsl_mc_dprc.c: In function 'dprc_add_new_devices':
drivers/bus/fsl-mc/fsl_mc_dprc.c:173:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'uint32_t' [-Wformat=]
      region_desc.size);
      ^

When built as a module (CONFIG_FSL_MC_BUS=m):

ERROR: ".dprc_get_obj" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
ERROR: ".dprc_get_obj_count" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
ERROR: ".dprc_close" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
ERROR: ".dprc_open" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
ERROR: ".dprc_get_obj_region" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

checkpatch:

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?

WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented -- check ./Documentation/devicetree/bindings/
#690: FILE: drivers/bus/fsl-mc/fsl_mc_bus.c:528:
+	{.compatible = "fsl,qoriq-mc",},

For the former warning, I'd suggest moving patch 4/4's contents up
in the series.

For the latter warning, googling for the property shows an upstream
effort, so it might be ok, but it'd be nice to provide a
cross-reference to the status of the latest post, to make it easier
for reviewer consumption.

Also, I think you'd get more recipient coverage by using
scripts/get_maintainer.pl.

Thanks,

Kim
