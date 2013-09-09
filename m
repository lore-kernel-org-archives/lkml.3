Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3IINbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:31:08 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53680 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3IINbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:31:05 -0400
Date: Mon, 9 Sep 2013 09:31:01 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: linux-omap@vger.kernel.org, bcousson@baylibre.com, tony@atomide.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olof@lixom.net
Subject: Re: [PATCHv3] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
Message-ID: <20130909133059.GD10973@ohporter.com>
References: <1378638746-10627-1-git-send-email-koen@dominion.thruhere.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378638746-10627-1-git-send-email-koen@dominion.thruhere.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 01:12:26PM +0200, Koen Kooi wrote:
> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
> so create a common dtsi both can use.
> 
> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI transceiver 
> after a dozen boots with an uSD card inserted because LDO will be at 3.3V instead
> of 1.8. 
> 
> MMC support for AM335x still isn't in, so only the LDO change has been added.
> 
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>

Tested-by: Matt Porter <matt.porter@linaro.org>

Works fine for me on tip and 3.11. I did notice a regression in musb (worked
on 3.11, now failing to probe but this is not related to your new dts as it
happens on am335x-bone.dts too, assuming merge window volatility). One nit,
git-am picked up a whitespace error on that extra line at EOF so you should
trim that out.

Only thing is...for a clear bug like this that will destroy hardware, it
should be marked Cc: stable@vger.kernel.org to be picked up in stable.

-Matt
