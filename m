Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab3BFUjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:39:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3BFUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:39:02 -0500
Date: Wed, 6 Feb 2013 21:38:54 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 2/8] gpu: host1x: Add syncpoint wait and
 interrupts
Message-ID: <20130206203854.GA1012@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-3-git-send-email-tbergstrom@nvidia.com>
 <20130204103032.GB27443@avionic-0098.mockup.avionic-design.de>
 <51108A94.3060501@nvidia.com>
 <20130205084255.GB20437@avionic-0098.mockup.avionic-design.de>
 <5112BD26.5060800@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <5112BD26.5060800@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:aJLf3t4xi4QQ9ZHALFw2MqnazLWcoA82WcbC+QfV7pu
 gEFXcFzy/2urs6mOuCEs5Rqy9/3SjegrLO+iQX+U6POJ19k4zB
 f66+j72sTY2e9Ly1ie4V6Zpnr44T+z36gMcDAwFGShQUNdUSYF
 g2jAf4Dk29dpomRIGywMymY1zw0QujdJGpNWJIaeScgoXceJbZ
 2LQtiMAsoQLAEoQEn60WnuMg1GR8mzvMxJc5JqLD+ucrAyHWCu
 gZdrI3xPOnGSRTb9gkVcXemQGrCjap4/i5N+zq/n7S/T1YJyvd
 se3FoSzzu6E35FVOnSBCRehjoJXmVVuhUBId+qTTCvX/168DQr
 6rPQCy7c7G7oQeAiXCofPIt/WtEb2cyFxStqxAhTpjuDXPyK7J
 TRINtyh4YLZa07WHgPQeoIuScx170krdXE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 12:29:26PM -0800, Terje Bergstr=C3=B6m wrote:
> On 05.02.2013 00:42, Thierry Reding wrote:
[...]
> > Or if that doesn't work it would still be preferable to allocate memory
> > in host1x_syncpt_wait() directly instead of going through the wrapper.
>=20
> This was done purely, because I'm hiding the struct size from the
> caller. If the caller needs to allocate, I need to expose the struct in
> a header, not just a forward declaration.

I don't think we need to hide the struct from the caller. This is all
host1x internal. Even if a host1x client uses the struct it makes little
sense to hide it. They are all part of the same code base so there's not
much to be gained by hiding the structure definition.

> >>>> +void host1x_intr_stop(struct host1x_intr *intr)
> >>>> +{
> >>>> +     unsigned int id;
> >>>> +     struct host1x *host1x =3D intr_to_host1x(intr);
> >>>> +     struct host1x_intr_syncpt *syncpt;
> >>>> +     u32 nb_pts =3D host1x_syncpt_nb_pts(intr_to_host1x(intr));
> >>>> +
> >>>> +     mutex_lock(&intr->mutex);
> >>>> +
> >>>> +     host1x->intr_op.disable_all_syncpt_intrs(intr);
> >>>
> >>> I haven't commented on this everywhere, but I think this could benefit
> >>> from a wrapper that forwards this to the intr_op. The same goes for t=
he
> >>> sync_op.
> >>
> >> You mean something like "host1x_disable_all_syncpt_intrs"?
> >=20
> > Yes. I think that'd be useful for each of the op functions. Perhaps you
> > could even pass in a struct host1x * to make calls more uniform.
>=20
> Ok, I'll add the wrapper, and I'll check if passing struct host1x *
> would make sense. In effect that'd render struct host1x_intr mostly
> unused, so how about if we just merge the contents of host1x_intr to host=
1x?

We can probably do that. It might make some sense to keep it in order to
scope the related fields but struct host1x isn't very large yet, so I
think omitting host1x_intr should be fine.

Thierry

--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJREr9eAAoJEN0jrNd/PrOhgwYQAJnrakyABYmZHnCmfPf3gQRy
D+qFtofkAwbvSmHGT1ULEn7A7u91dqfZaWPgrXoFbpSaevf2JUvhN8sgnzsppjxa
ajutLt9SbFZmdjJexDf2RHHMwJeF+89hP8GOMxBcd7UQ+pdoAKfhjOihCvcDQL90
DiY0rMXl/sUSnCJ7ERk1oUPXb4Sn9I/QxZMSTQB3gxcp4lC3pDNXx5gDkThuXkpZ
gI1RnCtLmiEgTIAkxlvu6oe3dKpztVYl2urqC45ORRcXPGx3bxbo49v5XuqgeGNU
hr9/JorQJt2biRUFzmyFrpJ782Ral3YIHiwugtvVjrz1yWBUk55Rg4pqt/3DrL3Z
D0IuIluJrTDq+hhxr3TxV1635O9DnKBklSxXtGehq3EqhJfjWKBk65ndaHE33Ob8
SD0n+m3Y2JgASV8MNsa2ErfuBm9H95Ed/3VyglO3qK3eGr9dSI/irRbOXjWfsVsH
Lac7LTO9NYnnbGmeBmenPKVL6iibsCRO5DmFIPrCHNqweouvLghGLKVX7t0Lzvx+
Q2rgvq09f6LtNAZ1ifEmmWXjbyxeDPEeOh8Vh4KsEzAW6zakcJ1qBQ0QkPA43jU/
kxjCXiQkooIR0rB9U2TkfLcfHF7HoJoadrsBbLlGonaGc9oRqPI8wKDQ4zJ6VZLx
wSAx/RbqJ9utFbiBun1q
=OMAw
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
