Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbbAWW2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:28:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbbAWW2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:28:48 -0500
Date: Sat, 24 Jan 2015 09:28:42 +1100
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Marek Belisko <marek@goldelico.com>, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, NeilBrown <neil@brown.name>
Subject: Re: [PATCH 12/13] ARM: dts: omap3-gta04: uart4 is not connected, so
 mark it "disabled"
Message-ID: <20150124092842.2441d3c6@notabene.brown>
In-Reply-To: <20150122214052.GY7718@atomide.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
	<1421959099-28319-13-git-send-email-marek@goldelico.com>
	<20150122214052.GY7718@atomide.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Pu=LAE=9iVL8lHYgcpTy=YI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Pu=LAE=9iVL8lHYgcpTy=YI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Jan 2015 13:40:53 -0800 Tony Lindgren <tony@atomide.com> wrote:

> * Marek Belisko <marek@goldelico.com> [150122 12:42]:
> > From: NeilBrown <neil@brown.name>
> >=20
> > Signed-off-by: NeilBrown <neil@brown.name>
> > ---
> >  arch/arm/boot/dts/omap3-gta04.dtsi | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/oma=
p3-gta04.dtsi
> > index 228e79b..8d2b0a1 100644
> > --- a/arch/arm/boot/dts/omap3-gta04.dtsi
> > +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
> > @@ -357,6 +357,10 @@
> >  	pinctrl-0 =3D <&uart3_pins>;
> >  };
> > =20
> > +&uart4 {
> > +	status =3D "disabled";
> > +};
> > +
>=20
> This you probably want to avoid from PM point of view. Depending on
> bootloader state of uart4, Linux may or may not be able to hit any
> deeper power states.
>=20
> Marking something with status =3D "disabled" in dts causes the device
> entry not even to be created. That means hwmod won't be able to reset
> and idle this device during boot.
>=20
> The uart4 device is there for sure even if not muxed and in incomplete
> state. You may want to also check other places where you're using
> status =3D "disabled" for the same reasons.

That's ... unfortunate.  Would that apply to the MCBSPs too?  They are
disabled by default so you would need to explicitly enable them all for
sensible behaviour....

Hopefully there is some way to mark as device as "this is not used, make su=
re
it is turned off and stays off" ???

Thanks for the heads-up.  I'll have a look and see exactly what is happenin=
g.

BTW, on the topic of OMAP UARTs and power saving...
 I note that there are now two drivers for the OMAP3 UART - omap-serial and
 8250_omap.
 I also note that your commit:

commit a2fc36613ac1af2e92cbed7af80bc72d8114dd50
    ARM: OMAP3: Use manual idle for UARTs because of DMA errata

 is incompatible with omap-serial.  In particular, if I enable runtime
 suspend of the serial port by setting the autosuspend_timeout, then incomi=
ng
 characters will no longer wake the port (if I revert your patch incoming
 chars do wake the port).
 This could (I think) be fixed by enabling the RX/CTS interrupt.  However if
 omap-serial is being deprecated, then there probably isn't any point.

 So: what is the longer term expectation for these drivers?  Should we be
 switching over to 8250?

Thanks,
NeilBrown

--Sig_/Pu=LAE=9iVL8lHYgcpTy=YI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVMLLGjnsnt1WYoG5AQI0GRAApeJgaD++vxc6PfBuABjkcpC6vfETHAAK
Mp53TskeQzfvKbjGQA+hUBZDBde9wvuhyH7FsFZJv02njrqhhgD/NOWFmhFeCcqS
M7HU/5TXui2Xs5216+GvpDuW1gbXzqrg8AcgMjcAlgEsa3DKCd1TfcgE4PognVZU
Sscy0YY97dSFDYk3n0kcJ6BnY6zzXPmaVMEZgx+B+hdBmO9S7RKuS8jxsnCKSQdE
QgKcXq7aQJOgtxz9z6I5zOj6thos2i1P+dGSS1QizHQ6bXs4QbI4+8lUPu3hxp1j
aiUezyyQeH03XtSekCqVRo//YvQ89XZK/r0/b6YUN97O9tfY4ODuvJhCFUWLN7Fs
Edi1nJp4iujyczyx290Rjb4483eQBbgJ1hAnjQZjyHEPyk9LdnO734rEvVPDWLm1
jKdKuj+Jsf86AwVkrTHep8gogS8BpjpKhZLMbKoFNaASEN1YSBlM5BehLsJRcsuB
DspFibuERnRgVMcBn0PxAnKFuTIeKSaZjxDVuqiZXTWYoAbIQ0WFbuhsyGXczDJT
uwX9Nv5+UIxAubZDrdOkH2eIWy335lWNfV3k5FzzIqbm8xoHMEfzDUf+99qFOWlM
z1QtUC58bSxnsW7lyMHrZKRfxcZfpD3QSmXtwr67MCpxmCwe2bm5Jc9YM7qHAs4M
9weUEsQjVfE=
=mF4f
-----END PGP SIGNATURE-----

--Sig_/Pu=LAE=9iVL8lHYgcpTy=YI--
