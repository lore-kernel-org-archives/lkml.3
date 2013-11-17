Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab3KQSbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 13:31:16 -0500
Received: from sauhun.de ([89.238.76.85]:53876 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab3KQSbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 13:31:07 -0500
Date: Sun, 17 Nov 2013 19:31:03 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: jacmet@sunsite.dk, khali@linux-fr.org, dianders@chromium.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] I2C: busses: i2c-eg20t Do not print error message in
 syslog if no ACK received
Message-ID: <20131117183103.GC8577@katana>
References: <1384710380-5976-1-git-send-email-wernerandy@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <1384710380-5976-1-git-send-email-wernerandy@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2013 at 06:46:20PM +0100, Andreas Werner wrote:
> Using the i2c-eg20t driver and call i2cdetect or probe on the bus,
> the driver will print a lot of error messages if there was no ACK
> received.
>=20
> i2cdetect normally print a table with all the available devices. If there
> is no device on the address, the table will be empty.
> Currently with the i2c-eg20t driver, the table is not visible because
> the error messages destroy the table.
>=20
> Error message: pch_i2c_getack return -71
>=20
> This patch prevent the driver to print the messages to syslog.
> The pch_i2c_wait_for_check_xfer function is the only one who is
> calling pch_i2c_getack, so we can delete the function and add the
> read to pch_i2c_wait_for_check_xfer.
> If no ACK is received, the Message will be printed as a dbg
> message.
>=20
> Fixed print message to be a one liner so we can grep for the
> error message.
>=20
> Tested on Intel Atom E6xx and Eg20t Chipset.
>=20
> Signed-off-by: Andreas Werner <wernerandy@gmx.de>

Applied to for-next, thanks!


--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSiQtmAAoJEBQN5MwUoCm2ib4QAIBOkEpjaML9eHUh18g22GBU
40Lk+Xudn8NEKYrMWVXQSjTdwL7eck5SKgelvuesH3Y0rnx3irChMRQjZnz9TB80
lk51njEiqRg7rOn9Dp1Ab/6wYW6MSdKLOFt3R7VY0rwEc02z0s1NwOjMMxawPoVy
ci3BXfu/9iUHlSzd5KyAmvyEFTASt2PySqeO2ohEbEav1p846pxpPHyTk458C1GI
6TXY4fQSNG4Dz2KEyUdENfLfsvXuU9739w0yn4cAj8J/wYqCbayGrNohJsNdqXuN
iIagb0tsNYrjTV7wTFU9jJe7Hq10bAe9H/u6ItKdshQYKxE1N3ioAmI6UBUMVTi4
2CeR9wOo5iNcSKr6O14CR8PVAmKchMlb24kBsEMXPfTRbZR7peTE4P7pPJcP5sGi
W1W8t8piGoglgPFZOsSwRhSwEk/j3b0IcksS2z3PYy2NIX3zdJyW4AlYrGEkDeWP
9EOaZFY80rnmrCdu3qCamz2bHVuvWGsu9ZiKmBTKw+skL4IFA2xlB2pGLX5StrSn
LG7W+q0c8K6rPeirEKBIPbU57wASuOHSfLVETW1Sg7Unoh6vMHkl3WxpEBZc24IU
os4pvohTqm1IKP+l64JHCEeWxnM6D7PdJFWW4H/EKP4VCa8mDF/xSJrY9KKMDqdp
1yLOEZzfkRqP3LyP9Gp8
=uXQG
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
