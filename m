Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaJ2J6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:58:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34852 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbaJ2J6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:58:16 -0400
Date: Wed, 29 Oct 2014 10:58:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH RESEND V4 5/9] of: Add NVIDIA Tegra xHCI controller
 binding
Message-ID: <20141029095808.GB28356@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-6-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <1414535277-15645-6-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 28, 2014 at 03:27:52PM -0700, Andrew Bresticker wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
[...]
> +    - pll_u_480m
> +    - clk_m
> +    - pll_e

What are these used for? I guess I'll see when I get to the driver
patch.

> +Optional properties:
> +--------------------
> + - phys: Must contain an entry for each entry in phy-names.
> +   See ../phy/phy-bindings.txt for details.
> + - phy-names: Should include an entry for each PHY used by the controller.
> +   May be a subset of the following:
> +    - utmi-{0,1,2}
> +    - hsic-{0,1}
> +    - usb3-{0,1}
> + - avddio-pex-supply: PCIe/USB3 analog logic power supply.  Must supply 1.05V.
> + - dvddio-pex-supply: PCIe/USB3 digital logic power supply.  Must supply 1.05V.
> + - avdd-usb-supply: USB controller power supply.  Must supply 3.3V.
> + - avdd-pll-utmip-supply: UTMI PLL power supply.  Must supply 1.8V.
> + - avdd-pll-erefe-supply: PLLE reference PLL power supply.  Must supply 1.05V.
> + - avdd-pex-pll-supply: PCIe/USB3 PLL power supply.  Must supply 1.05V.
> + - hvdd-pex-supply: High-voltage PCIe/USB3 power supply.  Must supply 3.3V.
> + - hvdd-pex-plle-supply: High-voltage PLLE power supply.  Must supply 3.3V.

I think the name for this in the documentation is HVDD_PEX_PLL_E, which
would translate to hvdd-pex-pll-e. At least that's how we named this
supply for PCIe.

Alternatively it seems like there are aliases for the USB 3.0 related
supplies:

	avdd-pex-pll -> avdd-usb-ss-pll
	hvdd-pex -> hvdd-usb-ss
	hvdd-pex-pll-e -> hvdd-usb-ss-pll-e

So perhaps these could be used for the XHCI driver instead? Also, should
these supplies not be mandatory?

Thierry

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUULowAAoJEN0jrNd/PrOhqSMP/A0WZ+IQ9+HY4U3HiMecg0T8
E7rTjP8DAVngvBKDocb7p94tR+yLT6kEPoYlCicOCF7Rw6sAtiqbHCZTiQGWbsZl
nuwMAOlo0lSBC08tTTcxoRwcqquCIgQQZADz+olX+M7MCZam9fFVLyPBpfR0ZNag
cJRxcI3842GfAzeavjMcaPCrSPVUgimnFgBR9oMZq74YPstX5E1aaRY+LEW6fn0z
1SfjU9X5voXFNZzZ0aE62MbAzmWrdxCPoEL6urryphBDlnaRHN9ig4m4xwAz1+8E
QnpKAQ3T7a2KEyl8fRTMUhKR0odXrywjPD8JikuxzwY3xQp5qunMaT749KH5avj8
siCbCagu+2e5jFGVi4yFVeQ6XD884nDxqxjF3nu/3Lh7hkBXtlvTGSQQkw7pAmwq
vAh3jhL7ia0/hiARPLf6KozRTEXDASsqxsDDHZ4EPZCuBSbWsTjxFegdGbGfoWC4
25xhdgkz3w/3juOmThUXKxm02t9/xA8pU6f9KoVyiJ9dOyQBbDw7nTbpOqU1cezM
0CTJO95MpFKQlde0AOoMU61WCFOTmZoMQfL8TzpN9+JZjaLzpVDDpb43FPwtuOuP
0KOxx6ljxlNqW3iGBKvlqYduGD5o2d4EhqG9SBq+2ZXpzJ9vTawJ92po7jGW4NP1
mYcrQhMVfJzQETqE2olp
=YV82
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
