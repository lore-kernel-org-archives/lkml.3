Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbaGAWVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:21:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38190 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaGAWVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:21:22 -0400
Message-ID: <53B3345E.9020704@wwwdotorg.org>
Date: Tue, 01 Jul 2014 16:21:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, tuomas.tynkkynen@iki.fi
Subject: Re: [PATCH 3/3] USB: PHY: tegra: Call tegra_usb_phy_close only on
 device removal
References: <1404248923-21086-1-git-send-email-ttynkkynen@nvidia.com> <1404248923-21086-4-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1404248923-21086-4-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 03:08 PM, Tuomas Tynkkynen wrote:
> tegra_usb_phy_close() is supposed to undo the effects of
> tegra_usb_phy_init(). It is also currently added as the USB PHY shutdown
> callback, which is wrong, since tegra_usb_phy_init() is only called
> during probing wheras the shutdown callback can get called multiple
> times. This then leads to warnings about unbalanced regulator_disable if
> the EHCI driver is unbound and bound again at runtime.

The series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c

> -static void tegra_usb_phy_close(struct usb_phy *x)
> +static void tegra_usb_phy_close(struct tegra_usb_phy *phy)

If this function undoes what _init does, it seems it should be called
_fini not _close. But that's bike-shedding perhaps.
