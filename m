Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaF0QFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:05:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44546 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaF0QFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:05:18 -0400
Message-ID: <53AD9637.5010605@wwwdotorg.org>
Date: Fri, 27 Jun 2014 10:05:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: balbi@ti.com, Andrew Bresticker <abrestic@chromium.org>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v1 4/9] pinctrl: tegra-xusb: Add USB PHY support
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org> <1403072180-4944-5-git-send-email-abrestic@chromium.org> <53AB493F.3030802@wwwdotorg.org> <CAL1qeaHhoqEPu-j+drNiRMyeutz=qqZPxSP8H+v-sgjZSfS5tQ@mail.gmail.com> <20140627150004.GF8069@saruman.home>
In-Reply-To: <20140627150004.GF8069@saruman.home>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GFxGbm30iTpCH0Ab2w9hd3LXB2gxK7eTq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GFxGbm30iTpCH0Ab2w9hd3LXB2gxK7eTq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/27/2014 09:00 AM, Felipe Balbi wrote:
> On Wed, Jun 25, 2014 at 04:30:48PM -0700, Andrew Bresticker wrote:
>>>> +static int usb3_phy_power_on(struct phy *phy)
>>>> +{
>>>> +     struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
>>>> +     int port =3D usb3_phy_to_port(phy);
>>>> +     int lane =3D padctl->usb3_ports[port].lane;
>>>> +     u32 value, offset;
>>>> +
>>>> +     value =3D padctl_readl(padctl, XUSB_PADCTL_IOPHY_USB3_PADX_CTL=
2(port));
>>>> +     value &=3D ~((XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_MASK <=
<
>>>> +                 XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_SHIFT) |=

>>>> +                (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_MASK <<
>>>> +                 XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_SHIFT) |
>>>> +                (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_MASK <<
>>>> +                 XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_SHIFT));
>>>
>>> Hmm. So there is a lot of "PHY" stuff here after all.
>>>
>>> However, the PHYs implemented here appear to implement very low-level=

>>> I/O pad code, whereas the PHYs we have for our USB 2.0 controller are=

>>> somewhat higher-level; they're more USB-oriented than just IO pad
>>> oriented. Do you know which level of abstraction a Linux PHY object i=
s
>>> supposed to be? I could never get an answer when I asked before.
>>
>> The only other PHY driver I've worked with (Exynos USB2/3 PHYs) also
>> mainly only did low-level pad control stuff, but looking at a couple
>> of other USB PHYs (MSM, MV), there appear to be others that have
>> higher-level USB stuff in the PHY driver.  Perhaps Kishon or Felipe
>> could offer us some guidance?
>=20
> well, if you're adding a new driver, I'd rather see folks moving over t=
o
> the generic phy framework (drivers/phy) because we're trying really har=
d
> to get rid of drivers/usb/phy/. And I think, in your case, it's actuall=
y
> ok to use pinctrl because you actually are muxing pads to the USB3 PHY,=

> you just do it lazyly.

What I'm looking for is a good definition of exactly what a PHY is
supposed to be in Linux.

Is it purely something that turns some IO pads/drivers off/on, and
nothing more?

Or, does the PHY concept encompass protocol-specific concepts such as
USB VBUS enable, USB VBUS detection, USB OTG switching,
UTMI-vs-ULPI-vs-HSIC selection... all of which are irrelevant of the PHY
(or at least IO pads) are used for SATA or PCIe instead.

This obviously affects which code goes in the PHY driver, and which in
the EHCI/XHCI controller driver.


--GFxGbm30iTpCH0Ab2w9hd3LXB2gxK7eTq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTrZY3AAoJEJuNpwkmVCGcvtIQAKFrmuE6SyOFAl8hA/0P5BZj
nreRyhuDpflz1XnD2SH2U6IF7nLFg8+QlnZEuv3/ZhwHL16TY1SFzVvvCu2OB4QB
I3Pp/ArAHh1FFCUvYYB/GK+f++jPHlL5O8lpeL80SZ7TVz0NcfaV9c+owqqkqFM3
n5fqL7Z9US1NELQFT0XERy6GnGHoADybkPzLqomzBdenrAzt8gLwY5nc/9oafuwL
HCbyffiAv6Nd85BL+x8ASv+6fzX/wnU8ru2JxSyZuS9B0Kzj3BneeSJz9t69svrw
3I8qq9YstNn+wMpDRZGJ3BSbGFANm9MDdTJNz52ZhhiSk+pes3kxLuyP8MjxMZxD
CzoAlWxRKN5dz8lWowMgT+jV8OTclmiTfWsnwVS5uz6ibrNV4w4kInYiW7Sphpas
SYV8Rbs6Qr7cDAyZQi4C50MqONQaAOP0EB1fE4I3HCfbgG0BIsT7hVqSa0Zine9u
Xn1YIZdeX2jyDYEqZ/lm2NplHyBUAVfYiYclWa/ydvEcjJaSlyLYLQakpVTvkfHG
5kIrAAWvAOlL9eKd1TGLJ4JCldMGO9jpOJfjJ/iFdwbUtH9cf9W+Wg6/sBB4jV9Q
onFQbzcadQ+TORqCdal3PD17TaAyhF3eh187B44+QZ7arXvnkXWOasXOe4T8DDKy
GTMwUqQjIL0ml2vwSxiU
=LcIR
-----END PGP SIGNATURE-----

--GFxGbm30iTpCH0Ab2w9hd3LXB2gxK7eTq--
