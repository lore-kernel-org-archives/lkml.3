Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaKSDNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:13:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57753 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbaKSDNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:13:46 -0500
Date: Tue, 18 Nov 2014 21:14:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Message-ID: <20141119031405.GD24874@saruman>
Reply-To: <balbi@ti.com>
References: <546A829A.8030106@linaro.org>
 <20141118003028.GA11280@saruman>
 <546B5578.8040809@linaro.org>
 <20141118151753.GB8223@saruman>
 <546B874B.8060700@linaro.org>
 <20141118180039.GJ6179@saruman>
 <546BAF07.1050605@linaro.org>
 <20141118204708.GR6179@saruman>
 <546BBB36.5080606@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <546BBB36.5080606@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 04:33:42PM -0500, Jorge Ramirez-Ortiz wrote:
> On 11/18/2014 03:47 PM, Felipe Balbi wrote:
> > Hi,
> >
> > On Tue, Nov 18, 2014 at 03:41:43PM -0500, Jorge Ramirez-Ortiz wrote:
> >>>>> you have no clue what these mean, do you ? How about reading the USB
> >>>>> specification of even http://www.beyondlogic.org/usbnutshell/usb1.s=
html
> >>>> Unfortunately I do.
> >>>> It was easier to temporarily hack the driver code for a test - while=
 I
> >>>> was at it - rather than modifying the host code.
> >>>> Since you asked for them, I though you would read the logs and wonder
> >>>> where the funny ids where coming from.
> >>> why do you even need to hack the host driver for these ? The driver
> >>> shows a Printer Class interface and the linux host side driver should
> >>> bind to it without any issues.
> >> the hack was on the gadget side.
> >>
> >> the usbhost test code in charge of sending the file to the device had =
the wrong ids.
> >> to save time -since I was modifying the gadget driver code and only fo=
r the
> >> tests (it is not part of the final patch) - I hacked those ids on the =
printer.c
> >> file.
> >> but anyway. lets move on. I removed those, recompiled the usb host cod=
e and sent
> >> the new traces.
> > then the host side needs a fix because it shouldn't really care about
> > the device ID, rather it should care about the class being printer.
>=20
> absolutely.
> however if you use libusb_open_device_with_vid_pid then well, these thing=
s happen...

heh :-)

> >>>> That hack above would have given you an answer: so I kind of know wh=
at
> >>>> the ids are for. honestly.  anyway, will send the new logs - it took
> >>>> me a while to find and modify the host test code.
> >>> Which host test code ? Why don't you just use lpr or even cat file >
> >>> /dev/lp0 or something like that ?
> >> it is some proprietary code that links libusb -part of a different pro=
ject: it
> >> was useful as it generated some metrics I was interested in.
> > I would be surprised if lpr doesn't work for the same purpose.
> >
> >>>>> do you want to debug that and find the culprit since you're already=
 at
> >>>>> it ?
> >>>> probably: I still need to get used to this process, thanks for beari=
ng
> >>>> with me on this.
> >>> no problem.
> >>>
> >>>> I spoke to Ricardo Ribalda three months ago while I was doing this
> >>>> stuff.  but yes, I might work on this -after I finish with this
> >>>> patch!- since I have access to the hardware locally.
> >>> cool, that'll help.
> >> notice that the original PLX driver was still far from the theoretical=
 5Gbps
> >> target (I was expecting to measure at least 3Gbps and could only get 1=
Gbps).
> >> So 1Gbps should be the target to meet on the kernel.org net2280 - do y=
ou agree?
> > this depends on a whole bunch of things. Mainline is a lot different
> > from PLX's kernel tree, I'm sure.
> >
> > It also depends on how many PCIe lanes you're using. Just because USB3
> > guarantees 5Gbps bandwidth, if you use a 1x PCIe connector, you'll never
> > get that ;-)
> >
>=20
> yes, that is why I purchased a Lenovo ThinkServer TS140 just for this
> integration.  it has one x16 Gen3 PCIe slot, one x1 Gen2 PCIe and one
> x16 Gen2 PCIe (x4 signal).  so this should be enough.

right, assuming PLX PCIe card actually supports that :-)

> on the host side, I have good server as well.  So really, there is no
> excuse to not get this right unless there is a problem in the plx
> silicon but from the Windows based metrics that I saw I dont think so.
> The only think I am missing is the USB3 analyzer I used to have in my
> previous company.

yeah, that helps a lot indeed. I'm always using my trusty beagle 5000.

--=20
balbi

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbAr9AAoJEIaOsuA1yqRErKIP/jbh36qjkRjYfc453fNt2Vx3
D94NAXd9rX7O/H4m3owdy7CGruVqj1ykFU/eIvIa0nTDns+cXpfqmoc4vDs6GpEy
TlNry4H3lG781ZLOcUbqehiZI7GQJfuJ4KOgf3I0J8kpqqmYjMkA3QN9Aaxsn/jx
XASrNfjFrHja+sY1kG2zgGgh56R92nD8htKl1kChQTsfkjYZGe+Y6tAtgU2Pj6II
lOcnf5KXXo35JKXnnef6HjjTgJqo3nAKm5krL8xY2u43L/qty3W6+HObfbCvwdBI
S27WQ4Q7FiSBwVjxVAI7n3x9iYjZ7XkujRZ7krtLl0or3J7b33ac5FFq8+4U7TxS
DceutcUNuNuj6Jrz0YmK+caWClmZYP8QUK2D2pBDt8num5xRdzva8s4EWTUfGS+V
Yk5lPBQNUkIeUZEP9ZQOE1IpSZXaBB9ykl1Eu9S2xHvF0Yp5WbeRzLRa5QcBMbsb
v0LteLG5KqWUmKvuG/9xtdvVW4U09w8EVmBzL2Uh+roCVnjnaJU433OX6J4jjlxt
+HVgCwbCylszHKtVtpC35mm1NyG04liNrjJodS28Wg+0C0a/vgBXm6nbFBY3tSrs
3t3p53s6zAdAZ48AaLTnXOy5KddsfsCWQzeOFDVHuikBBJ8rXC7FyO1KW8hQQCdc
zZjbrgiC88GZiDxERBIb
=F6+s
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
