Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaDYScf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:32:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:59008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaDYScc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:32:32 -0400
Date: Fri, 25 Apr 2014 20:32:26 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 07/14] HSI: Add common DT binding for HSI client devices
Message-ID: <20140425183225.GC22721@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-8-git-send-email-sre@kernel.org>
 <CAL_JsqLMAj7LewzkOk+tSyaZcS8CXyeozY5zMAY=iTWueuVuVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLMAj7LewzkOk+tSyaZcS8CXyeozY5zMAY=iTWueuVuVA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2014 at 11:52:11AM -0500, Rob Herring wrote:
> On Fri, Mar 28, 2014 at 7:31 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > Implement and document generic DT bindings for HSI clients.
> >
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
>=20
> Seems pretty reasonable although I know little about HSI.

ok.

> > ---
> >  .../devicetree/bindings/hsi/client-devices.txt     |  44 +++++
> >  drivers/hsi/hsi.c                                  | 197 +++++++++++++=
+++++++-
> >  include/linux/hsi/hsi.h                            |   2 +
> >  3 files changed, 241 insertions(+), 2 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/hsi/client-device=
s.txt
> >
> > diff --git a/Documentation/devicetree/bindings/hsi/client-devices.txt b=
/Documentation/devicetree/bindings/hsi/client-devices.txt
> > new file mode 100644
> > index 0000000..7504cb1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/hsi/client-devices.txt
> > @@ -0,0 +1,44 @@
> > +Each HSI port is supposed to have one child node, which
> > +symbols the remote device connected to the HSI port. The
> > +following properties are standardized for HSI clients:
> > +
> > +Required HSI configuration properties:
> > +
> > +- reg:                 A list of channel ids
> > +
> > +- hsi-rx-mode:         Receiver Bit transmission mode ("stream" or "fr=
ame")
> > +- hsi-tx-mode:         Transmitter Bit transmission mode ("stream" or =
"frame")
> > +- hsi-mode:            May be used instead hsi-rx-mode and hsi-tx-mode=
 if
> > +                       the transmission mode is the same for receiver =
and
> > +                       transmitter
> > +- hsi-speed-kbps:      Max bit transmission speed in kbit/s
> > +- hsi-flow:            RX flow type ("synchronized" or "pipeline")
> > +- hsi-arb-mode:                Arbitration mode for TX frame ("round-r=
obin", "priority")
> > +
> > +Optional HSI configuration properties:
> > +
> > +- reg-names:           A list with one name per channel specified in t=
he
> > +                       reg property
> > +
> > +
> > +Device Tree node example for an HSI client:
> > +
> > +hsi-controller {
> > +       hsi-port {
> > +               modem: hsi-client {
> > +                       compatible =3D "nokia,n900-modem";
>=20
> Is there only 1 version of HSI? If not, then perhaps you need to
> know what version a client is.

There is HSI (High-speed Synchronous Serial Interface) and a legacy
variant from Texas Instruments called SSI (Synchronous Serial Interface).
The main difference is the speed and I don't think the difference
must be encoded in the Device Tree.

> > +                       reg =3D <0>, <1>, <2>, <3>;
>=20
> Where do these numbers get defined?

HSI provides multiple serial connections and this describes which
channels are used for the remote device.

>Are they always 0-N?

=46rom what I understand they don't have to.

> I don't see much advantage to using reg. Perhaps something like
> hsi-channel-ids would be better.

I will change it to hsi-channel-ids for PATCHv4.

-- Sebastian

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTWqo5AAoJENju1/PIO/qaZHwP/1FdBz12XC3wBiGql1IVSQ3E
xYx5oG9fjbCIPcRYGCSFu882mCu+/XpTUzr0bhAfv6//HXjr/+iGDIUi0/E7hzOz
XArRGxZy6fpqmon1g2ETFU9jNt+Dtni3hTXSruusZ4YtR4/KzFz8yXGKNaWSwE+P
HqpUb96popHLHpgPtg0AsZCweUBlEJrJOvjOdelyfUDa3vqp16NwPhhFOlJ4gW2Z
8Wc8BCg+5o5msSi4lLGiFzz4ej2mg3VFEyGfNm116cD5kUYdO4+9uOrYW/Ef6DMW
TJNLwpchfIJRFm/Af0c0daWfC+2WF1JByBNXg41ojfyNCcS7C77st07e79QKkfuK
OiJX38SWf7d4tAiOMni7kAkKazxmkprJsvUms+JVk2bLIBTHPUBy+7K/qBY6EgMR
Ox5s0OOkS2TO4gf1NTZAvcfO4DIKxZJ6tyIfUg/TF161DTFbQWy/ZEESNX1ILvGL
1d2jMu+jH9tM+7ST8ckflaaGHwV2eIN2wkYYgP5vdNXf/DA+Aw7xCaVGHF/pWC4F
EIZRJRh/6aowRVuV1UtFUa2LC2xbnXyyIep44DruL4Clke7a8L6A2+HZP2jgB3nW
kien8fRUPhY7GxFkWB2skOrfY+UWomO00kI4nRpocTA67HNbFJfJvuVpvHuUY38g
oLspYNQrIKW408VoMZ3S
=hzcH
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
