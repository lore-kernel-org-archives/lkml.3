Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaKXKZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:25:06 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49327 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaKXKZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:25:04 -0500
Date: Mon, 24 Nov 2014 10:24:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Auto Configured <romain.perier@gmail.com>, Mark Brown <broonie@kernel.org>,
        heiko@sntech.de, grant.likely@linaro.org, robh@kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, mark.rutland@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com
Subject: Re: [PATCH v4 1/2] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141124102456.GE4241@x1>
References: <1415885699-1465-1-git-send-email-user@radxa>
 <1415885699-1465-2-git-send-email-user@radxa>
 <20141121105951.GA20679@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141121105951.GA20679@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Johan Hovold wrote:

> On Thu, Nov 13, 2014 at 01:34:58PM +0000, Auto Configured wrote:
> > From: Romain Perier <romain.perier@gmail.com>
> > 
> > It reverts commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").
> > As discussed on the mailing list, it makes more sense to rename back to the
> > old established property name, without the vendor prefix. Problem being that
> > the word "source" usually tends to be used for inputs and that is out of control
> > of the OS. The poweroff capability is an output which simply turns the
> > system-power off. Also, this property might be used by drivers which power-off
> > the system and power back on subsequent RTC alarms. This seems to suggest to
> > remove "poweroff" from the property name and to choose "system-power-controller"
> > as the more generic name. This patchs adds the required renaming changes and
> > defines an helper function which is compatible with both properties, the old one
> > which was only used by tps65910 and the new one without vendor-prefix.
> 
> Now this is a bit of a mess.
> 
> There's a commit in the mfd tree, 25f833c1171d ("mfd: tps65910: Convert
> ti,system-power-controller DT property to poweroff-source"), which
> breaks all dts using tps65910 since these are never updated to the now
> retracted property name ("poweroff-source").

My word!

Romain, what conversation on the MLs are you talking about?

> This one should simply be reverted ASAP.

No need to revert, I can just remove the patch from the MFD tree.

> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > ---
> >  .../bindings/power/{poweroff.txt => power-controller.txt}        | 0
> >  .../devicetree/bindings/regulator/act8865-regulator.txt          | 4 ++--
> >  drivers/mfd/tps65910.c                                           | 9 ++++++++-
> >  drivers/regulator/act8865-regulator.c                            | 2 +-
> >  include/linux/of.h                                               | 6 +++---
> >  5 files changed, 14 insertions(+), 7 deletions(-)
> 
> Romain, what tree is this patch against? The changes to the tps65910
> driver appears not to even be in the regulator tree, yet you asked Mark
> to merge this. And the MFD maintainer is not even on CC.
> 
> Let's fix the breakage by reverting the offending commit in mfd. Then the
> new standard name can be introduced in regulator alone (e.g. this patch
> without the tps65910 bits) as nothing outside of regulator should be
> using the new power-off feature (or binding) for act8865. Then other
> drivers and dts can be converted to use the new property name (while
> retaining backwards compatibility) for 3.20.
> 
> [ We should probably also consider adding an "of_device_is_" prefix to
> the helper name for consistency. ]
> 
> Johan

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
