Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbaLLBb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 20:31:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:32891 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759321AbaLLBbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 20:31:55 -0500
Date: Fri, 12 Dec 2014 02:31:49 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] TTY: add slave driver to power-on device via a
 regulator.
Message-ID: <20141212013149.GB16599@earth.universe>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215944.4127.4186.stgit@notabene.brown>
 <20141211225847.GB11666@earth.universe>
 <3884A980-C9EE-42A2-8D23-DF65FEC61DD2@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <3884A980-C9EE-42A2-8D23-DF65FEC61DD2@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

On Fri, Dec 12, 2014 at 01:46:33AM +0100, Marcel Holtmann wrote:
> > NACK. The compatible value should describe the connected device. You
> > did not connect a regulator, but a bluetooth chip! DT should look
> > like this:
> >=20
> > &uart1 {
> >    bluetooth {
> >        compatible =3D "vendor,bluetooth-chip";
> >        vdd-supply =3D <&vaux4>;
> >    };
> > };
> >=20
> > I think it would be ok to use your generic driver to handle the
> > specific compatible value, though.
> >=20
> > Having the proper compatible value means, that there can be a more
> > specific driver later, that other operating systems can expose the
> > device as some kind of /dev/bluetooth instead of /dev/ttyXY, that
> > userspace is able to know there is a bluetooth device connected to
> > /dev/ttyXY by parsing the DT and results in easier-to-understand
> > DTS.
>=20
> I think that is up to udev to be able to make this a nice device
> node. However the device node name is pretty much irrelevant.=20

Ah that was not about Linux, but about $random-os using DT. Just
ignore the device name its not important for the argument.

> What you want is enough meta data to tell that there is Bluetooth
> chip behind this TTY.

Yes, that is what I tried to say :)

> From a Bluetooth stack perspective only hciattach needs to be run
> to get the N_HCI line discipline up and running for that chip.

Yes, but with the metadata from Neil's proposed binding you do not
know, that there is a bluetooth chip connected, so you need to do
this manually. Not very nice, when it could be done automatically.

> However what would be interesting for hciattach would be a
> possibility to expose the Bluetooth manufacturer. Since the init
> routine is different for each manufacturer.

Yes and it may be, that a manufacturer breaks its init routine at
some point. The problem is not much different from other devices
and normally solved through the compatible string.

> So if that could be encoded in the DT, then that would be
> certainly helpful.

All needed data should be encoded when specified as in the following
example:

&uart1 {
    bluetooth {
        compatible =3D "wi2wi,w2cbw003";
        vdd-supply =3D <&vaux4>;
    };
};

Note: wi2wi is not yet in
Documentation/devicetree/bindings/vendor-prefixes.txt

-- Sebastian

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUikWBAAoJENju1/PIO/qaB2UQAJyPw3+4tNUfepvVjUcVOcMg
meEqyk9BQer1nQPWlUmgVcyb8ukwfh68tOGTTd3sMnATk4d1rpuPtDgCtTKJWSEC
r1hPUcdSy2ccPmIGTPaEpM6BmmIJeL/0eSFzEUOh/kTZU8sbO92WhUiUrDG8+z2L
TujjxZ8QMy4WUmzs9fsLUUNcaAiz1vHdg3xyozNMG5vRxJpYTnYhdHb+j+Z9MT6V
e19hRNCM4hsFLTmEg+s+GcQnw/5jrhzTJuE8uzwdROqWr26dvYz+CA5FGweiCLNG
bMMrMJZdB632JF79x4q4ZTCzGvg5HDxBKWCpVIqPVF9HCQ7TwRqDn7uiBqzTVHtI
4ZyFS4wE8PKkiFWCpWDmhaQFiT5MePVVGkQ7F84IeJqleCcgXANpRFu8nLXphOgY
r7clnLNUkwSLA6d+z7N5GUerWJPH32yNwbeNkixyWPpPCTTqUQ71j3NMZFIn+KHS
ikAeWlAeKBbxO7fi1ZtL7zSW30zbLROUY8J6Oz9Wj35gyV+AyaQnPrJ69ffJzqyA
gkqdObhSclNf0ArmzXAVxi84ltC6DIUpUtDxLQ9O9ZTw4Cs7sRxlNVie/hhQaoDj
IwpyzUy+fZ6atKe6jWn21KrHrogjP5IiqWOUbVqc41jOk5nKvjKtY4jNhA/GNmS3
dNl7iPgCvA+o0DMUm/LR
=+EbL
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
