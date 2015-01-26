Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbbAZPxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:53:40 -0500
Received: from sauhun.de ([89.238.76.85]:56444 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbbAZPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:53:38 -0500
Date: Mon, 26 Jan 2015 16:53:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: do not try to load modules for of-registered devices
Message-ID: <20150126155335.GA13494@katana>
References: <20150116080722.GA7813@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20150116080722.GA7813@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2015 at 12:07:22AM -0800, Dmitry Torokhov wrote:
> Trying to register an I2C device asynchronously (via async_schedule() cal=
l)
> results in an ugly warning from request_module() warning about potential
> deadlock (because request_module tries to wait for async works to
> complete). While we could try to switch to request_module_nowait(), other
> buses, as well as I2C itself when not using device tree, do not try to lo=
ad
> modules, but rather rely on the standard infrastructure (udev) to execute
> module loading, and we should be doing the same.
>=20
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Sounds reasonable. Applied to for-next, thanks!


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxmL/AAoJEBQN5MwUoCm2Qz8P/0+iUOpc+ME4+Ea0LAsaC22Q
1iWpQiu1qFpVbNYBinXWuXSOwGD6YhjhlVmLVJ7F3cVL6ZV3ugEcWh9M6jG5IZL2
cFZVnEiIYMFwXZxVbqUhBHkWQOqFww0fVtwdSWUFL9WICxGzbeCgBDPp2Hqi1g/G
xKqKHkEwVRCbEcIJMIHyhl+pnfSKiq0C/ikulXyKTaVO/8V7tTxJ1SWLhLxIxN43
t5DcFUV6ON+ALrv0Vtmb7Uv4fZxis/116QBylOYPbtUD4EBTo68UQmBEwI4IWJVc
z1ejg6Y+NH5BTJHmDpDqaX9lzLny0J/LV2nOp0CL84mIBrpe8RXu2Oz/YSQWSiG5
rKy0ZLyY0S1fQlgUW7V1nZ2Xl8WjmE3hVWxTRLRlCDOikDE8e8fPWRUIBfHa68eb
c//fSSeT3Asrgj0hmQC8OE+IA6hxk2dgBt1GoFcM0cpfTMSu3njsZu8nlymfIN/g
UBUx0tb0tLrFJ/38tZeRyoNRjNXUtChcAf9K5C2sccWs8IzlDFA8on8qL07le/Wy
rqexf3PUlxlF0ts3CQs9obubIZsWNues5hiB+yB2xln5TXpxtj7Z/VgnZdKQaueU
Xood08tEKrZmcow3Ug0MHAEuIgXfBK0Wa79pxigNkftHOpB1PayxGcpNrY5z/OJh
TbYb5wfj0MNO29EtLUW6
=IlbU
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
