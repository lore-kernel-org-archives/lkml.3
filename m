Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaIZIjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:39:12 -0400
Received: from mail-by2on0137.outbound.protection.outlook.com ([207.46.100.137]:3712
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753224AbaIZIjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:39:10 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] ARM: Kconfig: Open force maximum zone order for all	SoCs
Thread-Topic: [PATCH] ARM: Kconfig: Open force maximum zone order for all	SoCs
Thread-Index: AQHP2WLQUp/5jeUbOkqJIwjEvwe4RZwTE+6w
Date: Fri, 26 Sep 2014 08:39:04 +0000
Message-ID: <de6767070ea644d5830778059770451f@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409546541-4129-1-git-send-email-Li.Xiubo@freescale.com>
 <9dc024498c904d48b3a25430f8d31f29@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <20140926082054.GI5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140926082054.GI5182@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;UriScan:;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6029001)(6009001)(24454002)(164054003)(199003)(51704005)(189002)(83072002)(110136001)(85852003)(87936001)(2656002)(92566001)(10300001)(106116001)(105586002)(99286002)(33646002)(95666004)(74316001)(107046002)(50986999)(54356999)(66066001)(20776003)(108616004)(76176999)(64706001)(99396003)(120916001)(85306004)(19580405001)(19580395003)(74502003)(79102003)(80022003)(74662003)(46102003)(4396001)(81342003)(77982003)(90102001)(76576001)(81542003)(106356001)(86362001)(83322001)(101416001)(76482002)(21056001)(97736003)(31966008)(77096002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> On Fri, Sep 26, 2014 at 05:30:40AM +0000, Li.Xiubo@freescale.com wrote:
> > Hi Russell,
> >
> > I'd like to know the status of this patch.
> >
> > Our Platforms depend on it.
> 
> I'm not applying it.  This option should not be exposed for general
> use.  The usage pattern is clear from the existing users - propose
> an alternative default value for your platform rather than making it
> a user visible tweakable option.
> 

Okay.

Something like :
++++++++++
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..5729a2c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1802,7 +1802,7 @@ source "mm/Kconfig"
 config FORCE_MAX_ZONEORDER
        int "Maximum zone order" if ARCH_SHMOBILE
        range 11 64 if ARCH_SHMOBILE
-       default "12" if SOC_AM33XX
+       default "12" if SOC_AM33XX || SOC_LS1021A
        default "9" if SA1111
        default "11"
        help
----------

Is okay ?

Thanks,

BRs
Xiubo

> --
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
