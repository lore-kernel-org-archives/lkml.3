Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936930Ab3DIIPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:15:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52725 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136Ab3DIIPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:15:48 -0400
X-Auth-Info: oyzEmSplH+tTWRnnwBw2YOXqPCyP/9aO5tZ9aTq/6aE=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH RFC] ARM: dts: mxs: leave card detect out of common mmc pins config
Date: Tue, 9 Apr 2013 10:15:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        linux-mmc@vger.kernel.org
References: <1365415940-11609-1-git-send-email-hector.palacios@digi.com> <201304081828.27127.marex@denx.de> <5163C0B4.60501@digi.com>
In-Reply-To: <5163C0B4.60501@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091015.43472.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Dear Marek Vasut,
> 
> On 04/08/2013 06:28 PM, Marek Vasut wrote:
> > Dear Shawn Guo,
> > 
> >> On Mon, Apr 08, 2013 at 03:58:05PM +0200, Hector Palacios wrote:
> >>> On 04/08/2013 02:48 PM, Shawn Guo wrote:
> >>>> On Mon, Apr 08, 2013 at 12:12:20PM +0200, Hector Palacios wrote:
> >>>>> MicroSD card sockets don't usually have card detect line. This pin
> >>>>> is actually not needed for the MMC to work and it is more of a
> >>>>> platform design decission to have it.
> >>>>> The card detect pin already has a configuration entry of its own:
> >>>>> 'mmc0_cd_cfg' so we complete the iomux configuration here and let
> >>>>> platforms to include it or not depending on whether the card detect
> >>>>> line is routed to the SD socket.
> >>>> 
> >>>> Sounds sensible.
> >>>> 
> >>>>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> >>>>> ---
> >>>>> 
> >>>>> Hello,
> >>>>> 
> >>>>> All imx28 based platforms except 'bluegiga,apx4devkit' and
> >>>>> 'schulercontrol,imx28-sps1', use 'mmc0_cd_cfg' in their mmc
> >>>>> configuration so please check whether this patch would break these
> >>>>> platforms.
> >>>> 
> >>>> I just tested the patch on imx28-evk and card-detection still works. 
> >>>> So patches applied, thanks.
> >>> 
> >>> The EVK and most platforms will work because they are using
> >>> 'mmc0_cd_cfg' so actually this patch does not change anything on
> >>> them.
> >>> Platforms 'bluegiga,apx4devkit' and 'schulercontrol,imx28-sps1'
> >>> however are not referencing 'mmc0_cd_cfg' so after applying this
> >>> patch they will have unconfigured CD line and they may break.
> >> 
> >> Ah, yes.  I thought that any board that has CD support has to reference
> >> 'mmc0_cd_cfg'.  That's not necessarily true.
> >> 
> >>> The driver will call get_cd() upon probing, which returns the status of
> >>> the CD line. Please check these two platforms before applying.
> >> 
> >> Ok, let's wait for people owning the boards to confirm.
> > 
> > Maybe you want to use MMC_CAP_NEEDS_POLL as was noted by someone before
> > on the olinuxino -- the slot is there, it's just the CD line that's
> > missing.
> 
> I'm not sure of what you mean. The mxs-mmc.c driver already sets the
> MMC_CAP_NEEDS_POLL flag by default in the probe() function. My platform
> does not even route the CD line because the microSD socket does not have
> it.
> So what I have done is modify the driver to parse the property
> 'non-removable' from the device tree in order to set the
> MMC_CAP_NONREMOVABLE flag:

Yes, I get it. I have two remarks still:
1) The card is removable (you can pull it out from olinuxino's slot)
2) Why is the NEEDS_POLL set by default ?
3) Does the NEEDS_POLL not solve the issue with missing CD line?

Best regards,
Marek Vasut
