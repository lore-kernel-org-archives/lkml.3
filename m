Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab3GPCML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:12:11 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45013 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab3GPCMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:12:10 -0400
Date: Mon, 15 Jul 2013 19:12:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soeren.brinkmann@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 3.10.1] System does not wake up from suspend
Message-ID: <20130716021205.GB2162@skorgonTP.att.net>
References: <20130715043625.GA2162@skorgonTP.att.net>
 <20130715045400.GU32054@1wt.eu>
 <51E39BAB.4060308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <51E39BAB.4060308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
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
Thanks for your answers. I'll give this one a shot and fall back to
forcing a different cpufreq governor if it doesn't help.

	S=C3=B6ren

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAEBAgAGBQJR5Kv1AAoJEE3EUu+tZnRfzmEH/1CNeAUt4i6izWDw6qA+Je79
E/mWz0+ujFgHq/EIQmFAaG186HvpcNlMJpv688uGM3pIyZpuHBzkUj/qTWsalXyz
qef8cOpZ30C3fyye3aVCXIRgIDpY1a808F1FFtm8V2qOwORPorDmLL/pE3zmOiLu
kADoWgpGG3/WpfborTpaCE9cnlncixi1ELBqrq8Majf8HdJjwJk6kqqqmfcpNbFz
YVUrQ0HCLuMoER7Jcix0zWu4FNS5IT6gJ0CLrN4vi52kbeM4M4rbhKrltrPCuNdQ
jlh24d6m4ToTwYQiQQeK+ObCcQmv6CCIQMKjUt6gE0XxxVoMe2GS0xgS8Wg1lsU=
=tgsY
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
