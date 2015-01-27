Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbbA0PZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:25:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33608 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbA0PZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:25:05 -0500
Date: Tue, 27 Jan 2015 09:24:56 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] usb: dwc3: add ULPI interface support
Message-ID: <20150127152456.GC13776@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-7-git-send-email-heikki.krogerus@linux.intel.com>
 <20150123162443.GH8585@saruman.tx.rr.com>
 <20150126114610.GA28539@kuha.fi.intel.com>
 <20150126193528.GF6660@saruman.tx.rr.com>
 <20150127110925.GE28539@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <20150127110925.GE28539@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 01:09:25PM +0200, Heikki Krogerus wrote:
> > look at your patch again. In case DWC3_ULPI isn't enabled, this file
> > won't be linked at all. You're using stubs, so taht's fine.
> >=20
> > In case it _is_ enabled, you're breaking out early if you can't register
> > ulpi interface, meaning you're exitting probe() (which, in fact, seems
> > wrong as I want to be able to run dwc3 with ULPI enabled on a platform
> > that was configured with ULPI+UTMI, but uses UTMI PHY).
> >=20
> > I still think this patch won't work in all cases.
>=20
> OK. So in case of ULPI+UTMI we'll try the ulpi interface, and if it
> fails, fall back to UTMI. Or can we use some other method to determine
> to which interface the PHY is really attached to in that case?

I think we would need a phy_interface_sel pdata/DT binding for those
cases. It should be optional and probably only needed for a few odd
devices.

--=20
balbi

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx63IAAoJEIaOsuA1yqREyqYP/0QqTWO1jkkYzOHk3KRzBTR2
xXjG3fiHt/epquflE+Nm2EHCQFcm0s+UNOmYCNArK8tB+Uu15WJqS18qXKuYtsro
x6NuS4n1cVUgXasYkAb+CX2rCAJhjJbFJAQAoTDyQy9egsaNsV9TALgFYMtGZ+vt
s9v3RNKuyJi4MOW4hLrkVM73AaIJPplXmDGSKH9taX/i57VgoL+J7QRrgOUfs3ip
9+WqzANM0mtouO2cbKCxBs6Bfzc9kACB55oPyPfZKlisTy/lvh5PXck0U+tyxK+0
PrcgWFbqBo+3AVREehtzqvWjbFRsjnqCdo2A66uqu7xdvN/DDrNehaWmHx2ljBG0
gS+at1Iaj1eBQOpnKc/0ktZqhNAYip84A3qD31BluZQhfNhMJscHygXZ/Xw5XG40
6s1O6e/QpBFoyzW8mXdOKURseD5I0iRmfiwzolj/haQHYZ+ksrbCK1WjIHMonWMD
U/9xivuoguICFpNTfrXd4+BtILq0O2MVwTtszaN89G9nURsan1lEwx8DXfugGXqp
6Hf3JsLK/TSWwLbufqq8b7tloqhDnEZsGO3QsiZxLsiH0TuLId3MoVNDNnOw65KY
lFWZ5Ag6JfCW6zp1hk+ZZY714tfBjkpE4kGQ/EIFn7F4Y5sqKWB179RGg2eAi6JW
H9uBAwpkriwgnifDZlyo
=4LKA
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
