Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaKGNdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:33:31 -0500
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:65071
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751763AbaKGNd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:33:28 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
CC: "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 0/7] usb: add support for the generic PHY framework
Thread-Topic: [PATCH v8 0/7] usb: add support for the generic PHY framework
Thread-Index: AQHP9Gi7kha74pjlEEGgoPYePjXFxpxVMssw
Date: Fri, 7 Nov 2014 13:33:25 +0000
Message-ID: <07c7cfed25af4bdb9e34b6ad1aaed0c7@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1414690879-7184-1-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1414690879-7184-1-git-send-email-antoine.tenart@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0771;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(77096003)(62966003)(2501002)(92566001)(97736003)(76576001)(74316001)(76176999)(101416001)(54356999)(99286002)(2656002)(40100003)(122556002)(77156002)(105586002)(86362001)(64706001)(4396001)(21056001)(33646002)(2171001)(95666004)(99396003)(120916001)(31966008)(87936001)(20776003)(106116001)(2201001)(106356001)(46102003)(66066001)(107046002)(50986999)(108616004)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0771;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 
> 
> Antoine Tenart (7):
>   usb: move the OTG state from the USB PHY to the OTG structure
>   usb: rename phy to usb_phy in OTG
>   usb: add support to the generic PHY framework in OTG
>   usb: allow to supply the PHY in the drivers when using HCD
>   usb: chipidea: rename transceiver and phy to usb_phy
>   usb: chipidea: move usb_otg into struct ci_hdrc
>   usb: chipidea: add support to the generic PHY framework
> 

Hi Felipe,

I find you queue the patch 1st-4th and 7th in your next tree, how you queue
the 7th without queueing 5th and 6th, they have some relationships.

Will you queue 5th and 6th, or I queue them (5th- 7th) through my chipidea patch set?

Peter

>  drivers/phy/phy-omap-usb2.c         | 14 ++----
>  drivers/usb/chipidea/ci.h           |  8 +++-
>  drivers/usb/chipidea/ci_hdrc_imx.c  |  2 +-
> drivers/usb/chipidea/ci_hdrc_msm.c  |  8 ++--
>  drivers/usb/chipidea/core.c         | 89 ++++++++++++++++++++++++++--------
>  drivers/usb/chipidea/debug.c        |  2 +-
>  drivers/usb/chipidea/host.c         | 10 ++--
>  drivers/usb/chipidea/otg_fsm.c      | 30 +++++-------
>  drivers/usb/chipidea/udc.c          |  4 +-
>  drivers/usb/common/usb-otg-fsm.c    |  8 ++--
>  drivers/usb/core/hcd.c              |  7 +--
>  drivers/usb/host/ohci-omap.c        |  2 +-
>  drivers/usb/musb/am35x.c            | 28 +++++------
>  drivers/usb/musb/blackfin.c         | 18 +++----
>  drivers/usb/musb/da8xx.c            | 28 +++++------
>  drivers/usb/musb/davinci.c          | 18 +++----
>  drivers/usb/musb/musb_core.c        | 94 ++++++++++++++++++------------------
>  drivers/usb/musb/musb_dsps.c        | 26 +++++-----
>  drivers/usb/musb/musb_gadget.c      | 36 +++++++-------
>  drivers/usb/musb/musb_host.c        |  8 ++--
>  drivers/usb/musb/musb_virthub.c     | 22 ++++-----
>  drivers/usb/musb/omap2430.c         | 30 ++++++------
>  drivers/usb/musb/tusb6010.c         | 40 ++++++++--------
>  drivers/usb/musb/ux500.c            | 10 ++--
>  drivers/usb/phy/phy-ab8500-usb.c    | 16 +++----
>  drivers/usb/phy/phy-fsl-usb.c       | 23 ++++-----
>  drivers/usb/phy/phy-generic.c       |  6 +--
>  drivers/usb/phy/phy-gpio-vbus-usb.c | 14 +++---  drivers/usb/phy/phy-
> isp1301-omap.c  | 10 ++--
>  drivers/usb/phy/phy-msm-usb.c       | 95 +++++++++++++++++++----------------
> --
>  drivers/usb/phy/phy-mv-usb.c        | 50 +++++++++----------
>  drivers/usb/phy/phy-tahvo.c         |  8 ++--
>  drivers/usb/phy/phy-ulpi.c          |  6 +--
>  include/linux/usb/chipidea.h        |  4 +-
>  include/linux/usb/otg.h             |  7 ++-
>  include/linux/usb/phy.h             |  1 -
>  36 files changed, 420 insertions(+), 362 deletions(-)
> 
> --
> 2.1.0

