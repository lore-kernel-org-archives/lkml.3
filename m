Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbbAWCwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 21:52:12 -0500
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:9141
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752017AbbAWCwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 21:52:09 -0500
Date: Fri, 23 Jan 2015 10:56:45 +0800
From: Liu Ying <Ying.Liu@freescale.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        "Steve Longerbeam" <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
Message-ID: <20150123025643.GA11412@victor>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
 <1420655248.3191.73.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420655248.3191.73.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; mentor.com; dkim=none (message not
 signed) header.d=none;mentor.com; dmarc=permerror action=none
 header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(105606002)(110136001)(19580395003)(85426001)(6806004)(92566002)(106466001)(15975445007)(2950100001)(77096005)(87936001)(19580405001)(97756001)(23726002)(86362001)(83506001)(33656002)(46406003)(33716001)(50466002)(104016003)(62966003)(54356999)(50986999)(57986006)(76176999)(46102003)(77156002)(422495003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB246;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR03MB246;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB246;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB246;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 02:52:05.8139
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks that the below commit makes my Hannstar XGA LVDS panel stop working
on the i.MX6DL SabreSD board.  Any idea?

commit eb10d6355532def3a74aaabd115e2373cca70b9d
Author: Steve Longerbeam <slongerbeam@gmail.com>
Date:   Thu Dec 18 18:00:24 2014 -0800

imx-drm: encoder prepare/mode_set must use adjusted mode

The encoder ->prepare() and ->mode_set() methods need to use the
hw adjusted mode, not the original mode.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Regards,
Liu Ying

On Wed, Jan 07, 2015 at 07:27:28PM +0100, Philipp Zabel wrote:
> Am Donnerstag, den 18.12.2014, 18:00 -0800 schrieb Steve Longerbeam:
> > This patchset implements ->mode_fixup() in the imx ipuv3-crtc driver,
> > using a new support function ipu_di_adjust_videomode(). This new
> > function needs to be subsystem independent, so it accepts a video
> > mode as a 'struct videomode'. Hence ipu-crtc ->mode_fixup() needs
> > another support function to convert a drm_display_mode to a videomode
> > before passing the mode to ipu_di_adjust_videomode() for fixup.
> > 
> > Also some related code cleanup: 'struct ipu_di_signal_cfg' should
> > use 'struct videomode' for mode timings.
> 
> Alright, I have applied the series with
> s/videomode_from_drm_display_mode/drm_display_mode_to_videomode/
> 
> thanks
> Philipp
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
