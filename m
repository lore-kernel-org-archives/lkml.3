Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3GQC50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:57:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41524 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3GQC5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:57:24 -0400
Date: Tue, 16 Jul 2013 19:57:20 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soeren.brinkmann@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 3.10.1] System does not wake up from suspend
Message-ID: <20130717025720.GA1267@skorgonTP.att.net>
References: <20130715043625.GA2162@skorgonTP.att.net>
 <20130715045400.GU32054@1wt.eu>
 <51E39BAB.4060308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <51E39BAB.4060308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2013 at 12:20:19PM +0530, Srivatsa S. Bhat wrote:
> On 07/15/2013 10:24 AM, Willy Tarreau wrote:
> > On Sun, Jul 14, 2013 at 09:36:25PM -0700, S=C3=B6ren Brinkmann wrote:
> >> Hi Greg,
> >>
> >> since upgrading to 3.10.1 I find my system not waking up from suspend
> >> from time to time. Unfortunately, I couldn't figure out how to reliably
> >> reproduce the issue. Sometimes it works just fine.
> >>
> >> All I know so far:
> >> On 3.10 I had my system completely freezing a few times. But that did
> >> not seem to be related to suspend/resume. I never experienced the
> >> behavior described below on 3.10.
> >>
> >> On 3.10.1 I hit this bug a few times, that my system did not wake up.
> >> I.e. the screen stayed black and the power LED kept flashing. But
> >> nothing brought the system back up and I had to longpress power to res=
et
> >> the system.
> >> I had none of the system freezes like the ones described above anymore.
> >=20
> > Fortunately, 3.10.1 is very small. The only patch it contains which is
> > related to suspend is 18/19 (cpufreq ondemand governor). Maybe you're
> > having a problem with cpufreq on this machine in fact.
> >=20
> > You may want to try to force it to performance mode or powersave mode
> > and try for a while, it is possible that both 3.10 and 3.10.1 will work
> > fine.
> >=20
>=20
> Or, you could try applying the patch shown below on top of 3.10.1 and
> see if it fixes the suspend/resume regression for you.
>=20
> https://lkml.org/lkml/2013/7/11/661
>=20
> (Just apply patch 1, not the entire patchset).
So, this didn't end well. With that patch applied I end up in a kernel
panic on suspend, reproducible - well two out of two is a small test set,
but anyway. Unfortunately too late to get any information about it
and my logs don't show anything either. But it's seems worse than the
rather occasional hangs on resume on the vanilla 3.10.1 kernel.

	S=C3=B6ren

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAEBAgAGBQJR5ggQAAoJEE3EUu+tZnRfH6wH/0B/IHzGyYe5wQ5G2BD+ePY0
4JVhGPX2GgtWkgXvj8P59GMm74cBuHJwj/CPpf19otBtUQlnOeh6QlKQzrP0KkG/
8+yQSjFJZJJ20dTbrLRpF7kGQPgyU5gFDHAFhHhuwelSX/p4si0Ru4nAOKQBIr0c
m+8Zm9hLRIOlpsMCAhpI/+JoGn9uBWBYIIzV3DKI3rCTIiTMzRBBllz0bVhd70Si
R9aNLwrb/AQHwFhrVi3D5sY6Q6GAUa+L9gma0Rv6Yw/qapfYwG9k1dCT0f37wma6
q27X53jKQ3TRo5QDIp3X1mXnmHMBqqwgibMIjhRAUm6mtH/Rfe8pKdgIE7rZ+GM=
=CCL/
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
