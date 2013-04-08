Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965249Ab3DHOuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:50:18 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:6254
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965236Ab3DHOuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:50:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 8 Apr 2013 22:50:21 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Hector Palacios <hector.palacios@digi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "marex@denx.de" <marex@denx.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: Re: [PATCH RFC] ARM: dts: mxs: leave card detect out of common mmc
 pins config
Message-ID: <20130408145019.GD5044@S2101-09.ap.freescale.net>
References: <1365415940-11609-1-git-send-email-hector.palacios@digi.com>
 <20130408124810.GC5044@S2101-09.ap.freescale.net>
 <5162CCED.4070707@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5162CCED.4070707@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:58:05PM +0200, Hector Palacios wrote:
> On 04/08/2013 02:48 PM, Shawn Guo wrote:
> >On Mon, Apr 08, 2013 at 12:12:20PM +0200, Hector Palacios wrote:
> >>MicroSD card sockets don't usually have card detect line. This pin
> >>is actually not needed for the MMC to work and it is more of a
> >>platform design decission to have it.
> >>The card detect pin already has a configuration entry of its own:
> >>'mmc0_cd_cfg' so we complete the iomux configuration here and let
> >>platforms to include it or not depending on whether the card detect
> >>line is routed to the SD socket.
> >>
> >Sounds sensible.
> >
> >>Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> >>---
> >>
> >>Hello,
> >>
> >>All imx28 based platforms except 'bluegiga,apx4devkit' and
> >>'schulercontrol,imx28-sps1', use 'mmc0_cd_cfg' in their mmc configuration
> >>so please check whether this patch would break these platforms.
> >>
> >I just tested the patch on imx28-evk and card-detection still works.  So
> >patches applied, thanks.
> 
> The EVK and most platforms will work because they are using
> 'mmc0_cd_cfg' so actually this patch does not change anything on
> them.
> Platforms 'bluegiga,apx4devkit' and 'schulercontrol,imx28-sps1'
> however are not referencing 'mmc0_cd_cfg' so after applying this
> patch they will have unconfigured CD line and they may break.

Ah, yes.  I thought that any board that has CD support has to reference
'mmc0_cd_cfg'.  That's not necessarily true.

> The driver will call get_cd() upon probing, which returns the status of the CD line.
> Please check these two platforms before applying.

Ok, let's wait for people owning the boards to confirm.

Shawn

