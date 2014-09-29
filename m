Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaI2BZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 21:25:07 -0400
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:9185
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753122AbaI2BZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 21:25:04 -0400
Date: Mon, 29 Sep 2014 09:24:50 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/7] usb: add support for the generic PHY framework
Message-ID: <20140929012449.GB26753@peterchendt>
References: <1411467122-21440-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411467122-21440-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(189002)(76176999)(46406003)(110136001)(54356999)(21056001)(50986999)(20776003)(47776003)(4396001)(120916001)(102836001)(90102001)(26826002)(84676001)(33656002)(97756001)(50466002)(76482002)(107046002)(97736003)(95666004)(85306004)(87936001)(99396003)(15975445006)(105606002)(83322001)(19580395003)(83506001)(64706001)(31966008)(69596002)(77982003)(81342003)(74662003)(104016003)(6806004)(81542003)(92726001)(86362001)(46102003)(74502003)(80022003)(79102003)(44976005)(33716001)(83072002)(106466001)(85852003)(92566001)(57986006)(10300001)(81156004)(23726002)(68736004)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB219;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB219;
X-Forefront-PRVS: 034902F5BC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:11:55PM +0200, Antoine Tenart wrote:
> Patches can also be found at:
> git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy
> 
> The series applies on top of Sergei generic PHY support in HCD[1]
> and on top of Peter Chen's ci-for-usb-next branch[2].
> 
> Thanks a lot!
> 
> Antoine
> 
> Changes since v5:
> 	- rebased on the latest version of Sergei's series[1]
> 	- fixed one modifiaction made in the wrong patch
> 
> Changes since v4:
>         - reworked the PHY handling in ci_hdrc_probe()
>         - fixed a rebase error
>         - rebased on top of [3]
> 
> Changes since v3:
>         - moved phy_exit() after phy_power_on()
>         - fixed the PHY handling in ci_hdrc_probe()
>         - some little fixes
> 
> Changes since v2:
>         - rebased the series on top of v3.17-rc1 (and [2])
>         - switched to devm_phy_get() to handle non DT cases
>         - moved usb_otg into the ci_hdrc structure
> 
> Changes since v1:
>         - rebased the series on top of [2] (generic PHY support for HCD)
>         - split s/phy/usb_phy/ renaming and generic PHY support in separate
>           patches
> 
> [1] https://www.mail-archive.com/linux-usb%40vger.kernel.org/msg48068.html
> [2] git://github.com/hzpeterchen/linux-usb.git ci-for-usb-next
> 
> Antoine Tenart (7):
>   usb: move the OTG state from the USB PHY to the OTG structure
>   usb: rename phy to usb_phy in OTG
>   usb: add support to the generic PHY framework in OTG
>   usb: allow to supply the PHY in the drivers when using HCD
>   usb: rename transceiver and phy to usb_phy in ChipIdea
>   usb: chipidea: move usb_otg into struct ci_hdrc
>   usb: chipidea: add support to the generic PHY framework in ChipIdea
> 
>  drivers/phy/phy-omap-usb2.c         | 14 ++----
>  drivers/usb/chipidea/ci.h           |  8 +++-
>  drivers/usb/chipidea/ci_hdrc_imx.c  |  2 +-
>  drivers/usb/chipidea/ci_hdrc_msm.c  |  8 ++--
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
>  drivers/usb/phy/phy-gpio-vbus-usb.c | 14 +++---
>  drivers/usb/phy/phy-isp1301-omap.c  | 10 ++--
>  drivers/usb/phy/phy-msm-usb.c       | 95 +++++++++++++++++++------------------
>  drivers/usb/phy/phy-mv-usb.c        | 50 +++++++++----------
>  drivers/usb/phy/phy-samsung-usb2.c  |  2 +-
>  drivers/usb/phy/phy-tahvo.c         |  8 ++--
>  drivers/usb/phy/phy-ulpi.c          |  6 +--
>  include/linux/usb/chipidea.h        |  4 +-
>  include/linux/usb/otg.h             |  7 ++-
>  include/linux/usb/phy.h             |  1 -
>  37 files changed, 421 insertions(+), 363 deletions(-)
> 
> -- 
> 1.9.1
> 

Antoine, I am ok with your three chipidea patches, but when I go to
test it, I meet below error when I try to apply your 1st patch,
my branch is based on latest Greg's usb-next tree.

git am --3 patch_generic_phy_antoine/1.patch
Applying: usb: move the OTG state from the USB PHY to the OTG structure
fatal: sha1 information is lacking or useless (drivers/usb/host/ohci-omap.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 usb: move the OTG state from the USB PHY to the OTG structure
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

-- 
Best Regards,
Peter Chen
