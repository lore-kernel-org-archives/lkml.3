Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaJFNbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:31:06 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59053 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaJFNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:31:04 -0400
Date: Mon, 6 Oct 2014 15:30:59 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 10/11] ARM: at91/dt: add LCD panel description to
 sama5d3xdm.dtsi
Message-ID: <20141006133048.GE26921@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-11-git-send-email-boris.brezillon@free-electrons.com>
 <20141006110115.GH25202@ulmo>
 <20141006142538.76d2df29@bbrezillon>
 <20141006124014.GD26833@ulmo>
 <20141006151111.446ed7d6@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0QFb0wBpEddLcDHQ"
Content-Disposition: inline
In-Reply-To: <20141006151111.446ed7d6@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0QFb0wBpEddLcDHQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 03:11:11PM +0200, Boris Brezillon wrote:
> On Mon, 6 Oct 2014 14:40:15 +0200
> Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Mon, Oct 06, 2014 at 02:25:38PM +0200, Boris Brezillon wrote:
> > > On Mon, 6 Oct 2014 13:01:16 +0200 Thierry Reding <thierry.reding@gmai=
l.com> wrote:
> > > > On Wed, Oct 01, 2014 at 04:53:07PM +0200, Boris Brezillon wrote:
> > > > [...]
> > > > > diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dt=
s/sama5d3xdm.dtsi
> > [...]
> > > > > +		backlight =3D <&backlight>;
> > > > > +		power-supply =3D <&panel_reg>;
> > > > > +		#address-cells =3D <1>;
> > > > > +		#size-cells =3D <0>;
> > > > > +		status =3D "disabled";
> > > > > +
> > > > > +		port@0 {
> > > > > +			#address-cells =3D <1>;
> > > > > +			#size-cells =3D <0>;
> > > > > +
> > > > > +			panel_input: endpoint@0 {
> > > > > +				reg =3D <0>;
> > > > > +				remote-endpoint =3D <&hlcdc_panel_output>;
> > > > > +			};
> > > > >  		};
> > > >=20
> > > > There's no support for OF graphs in simple-panel, so this is unused,
> > > > isn't it?
> > >=20
> > > Actually I use it in my atmel_hlcdc_ouput implementation to figure out
> > > the link between a panel and a device connected on the RGB/DPI bus.=
=20
> >=20
> > That's kind of weird and one of the reasons why I can't make myself like
> > the OF graph bindings. It requires drivers for one device to reach into
> > the device tree node of some other device and look for content. Or put
> > another way, a DT node for a panel that works on one platform doesn't
> > work on another because the display controller needs additional DT
> > content that isn't required by the original binding for the panel.
>=20
> I also have a working POC of a DPI bus implementation (with DPI support
> in panel-simple driver).
>=20
> This is a solution I developed to provide a generic DPI implementation
> in my HLCDC driver and rely on generic external implementations for
> slave devices (panels, encoders, ...).
>=20
> But, IIRC, Laurent was not in favor of a bus approach because the DPI
> bus is just a data bus and not a control bus.
>=20
> Anyway, I'll clean it up and post an RFC.

According to the MIPI website there are also control signals and a
command set to control display behaviour. Does your implementation
handle any of that?

Thierry

--0QFb0wBpEddLcDHQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMpmIAAoJEN0jrNd/PrOh51YP/0kfP7SQppgCdVaCqJtq3oUw
1C7vEMfDrgGpZzrGkjkPIL600B6xvUsHeVu4zUZPhw14bEM6EBZhPi9KA7xoixDx
InbG+sMOTLX+jaQNTVvoJ9WnO6ikAgARKrZWmwUuxsAvFsia8TEJfNPRPYDB7kz6
R/XsA+LXzESjmvPlGtqeuzNKTh8c5o995pSj34WBZ1TeZsbwC8uee/o2Bo8Y9BDg
fpDh/lXEmzwWqTiJiE8vxJQOEXwhIsPo6fWrE9RjiTHu2BkEyQyd0ilVZUoedo39
ltbX9NUq4ztnGHKZ7jSNzuq+5yrOzxu2jsiqzvvXYgv3zSCg0snFTT6PjSTMtOE+
iNs7iqDHA3Fc8xZhwWO+FWoEI7S9p7E3TxbaK7axS17vqdDY5BtkBQvMBlW22UYj
ejbwMGp4BCv8VNy4kYeelSptr/ANpr/4tpqFS7oJF2cCmEoqzCul/NhdLAFIxn9q
ut0sYrdql9JkhqZziBOb7/APyA+ijQhpGxHkEe5TzApkecLRAlL73qlGYsxIBcIo
w5boyP1t2nac84UCR7NLy/n2MHTz3IIjsZqYnnxqrkf2+a+5xNyFiAMcbT7roN3M
EP0hrq+mCByKiFn4lOogZBxmgUihmJtXTCYnzZHZbOPLiPOKnvZC+9aVfAv3a0rL
HnMsg4anSaa6tHS03c9t
=yaay
-----END PGP SIGNATURE-----

--0QFb0wBpEddLcDHQ--
