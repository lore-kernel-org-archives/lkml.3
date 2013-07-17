Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3GQN16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:27:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33759 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab3GQN14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:27:56 -0400
Date: Wed, 17 Jul 2013 16:27:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Rong Wang <wr011235813@gmail.com>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130717132736.GA7614@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
 <20130715165209.GA6000@kroah.com>
 <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com>
 <20130717075706.GC5291@arwen.pp.htv.fi>
 <CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2013 at 09:04:54PM +0800, Rong Wang wrote:
> Hi Felipe,
>=20
> On Wed, Jul 17, 2013 at 3:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
> >> > The question is since we default GADGET, so the g_mass_storage.ko is
> >> > installed early but connecting to a host PC
> >> > is randomly, But the udev has no idea when a host PC connects our de=
vice.
> >> >
> >> > So we consider it's reasonable to let the udev know the GADGET devic=
e state.
> >> > Is there any alternative to our question?
> >>
> >> I thought we already export events for gadget device states, have you
> >> looked for them?  I can't dig through the code at the moment, but this
> >> seems like a pretty common issue...
> >>
> >> Felipe, any ideas?
> >
> > we already expose that in sysfs. IIRC udev can act on sysfs changes,
> > no ?
>=20
> I do not know if udev can polling sysfs file content change. I'll study t=
his.
>=20
> But the change is triggered by calling usb_gadget_set_state, and I find
> composite framework do not call this. Then we should do this common work
> in every udc driver?

yes. Only the UDC driver knows when the controller is moving among those
states.

--=20
balbi

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5pvIAAoJEIaOsuA1yqREfLQP/2DmltfIrOsyyRcOpgAcGWMu
A638TGxbU+oowzLe1ysq3joNDL0qB608EwHd3JiSaJgz4uszsflXeQmiGfGGA88K
gTyIaeJMJDQihMRUOT7KdxXxfbOONYgu+wCtOHZt7nG2CuxnvmU+ECJJvZX38A5m
cbZILCtYCvWlIGe/vK06dbWQ8zkcLcKD1wMlRRaH7xyanw8hPs8kJuYMVyjZK4Pm
hwByW3x+BIohrIObtX9/BV2TOm0kT83GeMN6nA4UodcDwlX5mMSFMKk/r5OpT7pc
qOjOt7iivEVaKXqIxc/sW1SJ3mbDYLjAW4056yP7360GdWI0sil2m/GK3jw+Gw8E
ln+LMyYxpXtBLF6O2Wm4OttbsKsP4p9yUhGTtBCr+W60P2FQO4PIGoinUvX9/tIc
cyhB3K1oyi4hsTvFd6qAnjiOFQOmSFMgZ8upaMb1ERkGOG5K2bpDnfvDJaUqO1MQ
q3LE8/xZSEA2bePieYAEL8ZeeQMsUTg9hDSwDO/lDiXVZy1dgQTgPgnbdNNFL8/Z
DBYfvDQ5jlg83aErqrwdMU8Csns9MBP9QLkTrTFYt1K0DYHRDREiRdefnwpqGd+4
SLT3qmOC9y/ZL8ZUFYfzsSoFweFBFG6inbPAY3waFbIPByY2rmc1hAnQD5fLsex/
Vl4uVPdDqQiLNBDXCbw6
=pyud
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
