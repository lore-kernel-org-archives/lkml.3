Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaEAPPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:15:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40169 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaEAPPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:15:07 -0400
Date: Thu, 1 May 2014 10:15:00 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Zhuang Jin Can <jin.can.zhuang@intel.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: fix burst size corruption
Message-ID: <20140501151500.GC6355@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140501211424.GE30575@intel.com>
 <Pine.LNX.4.44L0.1405010941550.1152-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405010941550.1152-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 01, 2014 at 09:45:17AM -0400, Alan Stern wrote:
> On Thu, 1 May 2014, Zhuang Jin Can wrote:
>=20
> > > again, you found a bug on the gadget driver. Fix that. composite.c
> > > guarantees that for those functions which don't pass bMaxBurst,
> > > gadget->maxburst will be set to *at least* 1.
> > >=20
> > I agree the real fix should be in the gadget driver. The patch intents
> > to prevent hibernatition from being corrupted by a bad gadget driver.
> > If OEMs develop their own gadget driver forgetting to call
> > config_ep_by_speed(), it'll turn out to be everything works except
> > dwc3 hibernation, and they'll complain to dwc3. f_ffs is an
> > example has SuperSpeed support but doesn't call config_ep_by_speed().
> > It's just for robustness, and dwc3 is not doing anything wrong.
> > It did cause me a long time to figure out why the hibernation was broke=
n.
>=20
> You could include the check, for the sake of robustness, in dwc3 -- but
> if it fails, you should write a message to the kernel log saying that
> the gadget driver needs to be fixed.

Also, if we're adding something to dwc3, we need to add to other
USB3-capable UDCs too. Namely dummy and marvel's.

cheers

--=20
balbi

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYmT0AAoJEIaOsuA1yqREwpQQAKC9G6VYzp+l3IILP8SRaxqE
AMaU93d07t8b8jSUHVlmWHjkhQcZC2hvLZ1RXiQKALeqvXeIuZlZ9T/s5IEOpAUC
qAMt+MDIkZYE+rgUP9vn+4qo/c57J+Cs+0OJUwdv9EBCgBbwCHLLxMHD/Um5qLoP
a4/9VMfecjMeqMI2Mfb2FRPOvMiKQwdG+NIjBNTEfeI0Q3bk1m8djGoxgzXEgnWC
D4sRq2SsFP3Q0nlzEVRtfG0uqFewj+SOPOHO/4342tj/psLzjXQAo4mD0JPD1aI4
tuk/0EupPCoNsgFNieWxBqOzFDVTOcOzIkpwPyi13LAkQjI6HHiPKweBC2PY07YS
hY+88bQuhsg6WipVNxbsHFtbwtBZABLvpjcMSPYN/ddRgTyihmzY1ACFeicflsy/
sz9NvavqSBpO7AwneIkB0mB+gDbLFR+X3c0/5iVM2M2x5pgughWNqD/bYJ7R2HFq
KnajoKuLg0LfUl6ZwRf5UCG7r6kRdetp0yAqhWVyGHAefGtZy3UJV3qX5mbd4vFe
5Haw7bK4baxtkbJkCxI7GJCljqbLOcHiBoDzktuKiZWPssf52+Rc0w0CLPqhDS9F
nItf2C2jYLSGUh5g9XlQrPZUwokRoGHQOBMvyKMB8779LveoRtwd/Dl8ZJaVRQHV
oMSeF43BIfvPegtZCFJ/
=stcS
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--
