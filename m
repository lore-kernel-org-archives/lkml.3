Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaKSDoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:44:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbaKSDoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:44:02 -0500
Date: Wed, 19 Nov 2014 14:43:48 +1100
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141119144348.169c4166@notabene.brown>
In-Reply-To: <20141112223154.GP641@saruman>
References: <20141102180756.GH31454@atomide.com>
	<5458D29E.50908@compulab.co.il>
	<20141104154231.GP31454@atomide.com>
	<CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
	<515E660B-B65D-41EF-97F5-74E4DE8FDD13@goldelico.com>
	<20141112212027.GK26481@atomide.com>
	<20141112223154.GP641@saruman>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0pudNttYBM/.QLEovnsqZFY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0pudNttYBM/.QLEovnsqZFY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Nov 2014 16:31:54 -0600 Felipe Balbi <balbi@ti.com> wrote:

> On Wed, Nov 12, 2014 at 01:20:27PM -0800, Tony Lindgren wrote:
> > * Dr. H. Nikolaus Schaller <hns@goldelico.com> [141112 12:28]:
> > > Am 12.11.2014 um 16:45 schrieb Grazvydas Ignotas <notasas@gmail.com>:
> > > > On Tue, Nov 4, 2014 at 5:42 PM, Tony Lindgren <tony@atomide.com> wr=
ote:
> > > >=20
> > > > Pandora does, as well as GTA04 AFAIK,
> > >=20
> > > Yes. The trick is that the power level that turns on the device is a =
little higher
> > > and the battery provides enough energy for approx. 30 seconds until i=
t drained
> > > to a level where it turns off. Depending on general setup (WIFI must =
remain
> > > powered off after boot) this is enough to boot into Linux and start f=
ull charging.
> > > Another trick is to modify MLO and U-Boot to raise the charging curre=
nt.
> >=20
> > Depending on the device and the boot-up speed this seems to work only w=
hen
> > connected to a Linux PC though. AFAIK Windows PCs enforce the 100mA USB=
 power
> > limit until the device is enumerated which can keep the device in an et=
ernal
> > reboot loop not being able to ever get the charging going :)
>=20
> this is actually what the USB Battery Charging spec requires us to
> implement. If Linux is doing differently, it's a bug on Linux which
> should be fixed :-)
>=20
> No host is allowed to source more then one unit load (100mA in LS/FS/HS,
> 150mA in SS) until the device is fully enumerated. Host are also
> required to drop max current budget to 8mA (IIRC) if the device doesn't
> enumerate for however many minutes (I guess it was a pretty long
> threshold, something like half an hour or so. My memory fails me right
> now).
>=20

I think the twl4030 driver does do the "right" thing unless the "allow_usb"
module parameter is set, in which case it enables charging at a higher rate
which is 600mA (default value of BCIIREF1).

It would be nice if the driver could check if a charger was plugged in and
act accordingly.
The charger I have for my openmoko is identified by a 47K resistor between =
ID
and ground.  The twl4030 can detect that easily enough, but it isn't very
standard.

The standard is of course to have D+ and D- shorted, but I don't know if the
twl4030 can detect that?  If it can, then getting some very early code to
check for the short (or the 47k resistor) and quickly enabling charging mig=
ht
be a sufficient solution.

NeilBrown

--Sig_/0pudNttYBM/.QLEovnsqZFY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGwR9Dnsnt1WYoG5AQIs7g/+OfqF6FfolC7x5kOb04o46VwQIiyrleXo
oGZztPdtkiTM0Ni6mZALybHkW+y/4yhMdrz4kQoIrb5Kn1/LoRAUvSCpB2A2BenC
yCektVlSTJj8sH1oXvFiJdsOgAtXKdbGW88kSy4rN68UTjOm9qFkHVdgGg+O4X3J
UuCveALbyvlXNwC5PwlkuIbMAxteHs3tY08Lp7UnJsdL2LKx6LsM0YmBBEK7rej9
vGUTLJeNMtSWq/bJWBph5SjuRBQQiTxJ/5HxMjM+n6lr0V3p8uUNdD+dR6bP1gRk
vCweYnQo6gR/2XrxiSKWpykaVYTtgl9qiFNT6htOmKTERT8jPMz5V7TwdhGT1PTO
BdAlW3Ld2sJRz9pDTgA9R7ag2PCwBU9S1d591G+16A8Zl0FwK5ks1ME68cvuOUSt
IBPlkCbN3lhC1ADSoRtHuY6R0cZJC9LpDWgxwz66vO/FIfzNUdHHvvo4gxSPwUjz
5LrZe2neYGxQ4QGke/HTop6h0jgbSuKdp2rcqrIADgsc2DonHUdzry4jkgualYaQ
7nQrYH+kvUKSrbjhTM0BPjGlER8FcBibrjQPuj+qoD3JKjS6bLFXXYj3b1OJaoXR
aer9Gsl+gQXpMqDRskN7LdRRVpfIqMe+vq9yv88kLIhVCDyOHs1hdDWxSUZUkvkn
3WDedru/Kqw=
=zPpi
-----END PGP SIGNATURE-----

--Sig_/0pudNttYBM/.QLEovnsqZFY--
