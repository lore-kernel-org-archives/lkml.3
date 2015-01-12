Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbbALKka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:40:30 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50605 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbbALKk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:40:28 -0500
Message-ID: <1421059225.22660.33.camel@x220>
Subject: Re: [PATCH v2 0/3] power: rt5033: Add Richtek RT533 drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, lee.jone@linaro.org,
        broonie@kernel.org, dbaryshkov@gmail.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com
Date: Mon, 12 Jan 2015 11:40:25 +0100
In-Reply-To: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
References: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2015 10:40:26.0386 (UTC) FILETIME=[2D2DEF20:01D02E54]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beomho,

On Fri, 2015-01-09 at 17:45 +0900, Beomho Seo wrote:
> This patchset adds driver for Richtek rt5033 chip The chip contains
> switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge.
> Additionally, This includes document for device tree of RT5033 device.
> 
> RT5033 core driver is applied by Lee Jones.
> RT5033 regulator driver have been merged by Mark Brown. commit is below,
> 
> commit b1917578fd5d8efa67afa05a0d6d7e323f2802da
> 
> Changes in v2:
> - Revise binding documentation..
>  
> Beomho Seo (3):
>   power: rt5033_battery: Add RT5033 Fuel gauge device driver
>   power: rt5033_charger: Add RT5033 charger device driver
>   Documentation: Add documentation for rt5033 multifunction device
> 
>  Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  drivers/power/Kconfig                              |   16 +
>  drivers/power/Makefile                             |    2 +
>  drivers/power/rt5033_battery.c                     |  177 +++++++
>  drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
>  6 files changed, 782 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
>  create mode 100644 drivers/power/rt5033_battery.c
>  create mode 100644 drivers/power/rt5033_charger.c

This series adds two drivers that depend on MFD_RT5033. But there's
currently no Kconfig symbol MFD_RT5033.

The regulator driver mentioned above is another driver that depends on
MFD_RT5033. It was included first in next-20141117. It is also included
in mainline since v3.19-rc1. That regulator driver has never been
buildable, even if one bypasses its dependency on MFD_RT5033. That is
because it includes two headers that are not yet part of the tree
(linux/mfd/rt5033.h and linux/mfd/rt5033-private.h).

When is the Kconfig symbol MFD_RT5033 expected to be included in the
tree?


Paul Bolle

