Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaKFQZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:25:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbaKFQZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:25:30 -0500
Message-ID: <1415291113.3398.63.camel@decadent.org.uk>
Subject: Re: [RFC][PATCH] x86: Make x32 syscall support conditional on a
 kernel parameter
From: Ben Hutchings <ben@decadent.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2014 16:25:13 +0000
In-Reply-To: <CAMuHMdVn7ERrXZBbzLZxWFnUhZdXectLMDoVKucte5Zr-U3Mow@mail.gmail.com>
References: <1415245982.3398.53.camel@decadent.org.uk>
	 <CAMuHMdVn7ERrXZBbzLZxWFnUhZdXectLMDoVKucte5Zr-U3Mow@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9dTudckZDEQnHZZNk+hQ"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9dTudckZDEQnHZZNk+hQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-11-06 at 09:02 +0100, Geert Uytterhoeven wrote:
> On Thu, Nov 6, 2014 at 4:53 AM, Ben Hutchings <ben@decadent.org.uk> wrote=
:
[...]
> > diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.=
c
> > index 4ac730b..7a6e66f 100644
> > --- a/arch/x86/kernel/syscall_64.c
> > +++ b/arch/x86/kernel/syscall_64.c
>=20
> > +static int __init x32_enable(void)
> > +{
> > +       BUG_ON(system_call_fast_compare_end - system_call_fast_compare =
!=3D 10);
> > +       BUG_ON(system_call_trace_compare_end - system_call_trace_compar=
e !=3D 10);
> > +       BUG_ON(system_call_mask_compare_end - system_call_mask_compare =
!=3D 10);
>=20
> BUILD_BUG_ON

No, these can't be evaluated at compile time because the symbols are
external.

> > +
> > +       if (x32_enabled) {
> > +               text_poke_early(system_call_fast_compare,
> > +                               system_call_mask_compare, 10);
> > +               text_poke_early(system_call_trace_compare,
> > +                               system_call_mask_compare, 10);
> > +#ifdef CONFIG_X86_X32_DISABLED
> > +               pr_info("Enabled x32 syscalls\n");
> > +#endif
>=20
> I don't think it hurts to print this unconditionally.
[...]

It seemed like it would be unnecessary noise in an x32-only system.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-9dTudckZDEQnHZZNk+hQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFug8ee/yOyVhhEJAQoKaxAAxlNen9V//M+W97RGU9+v3G9qL2tn6FsA
zbJC+fBhSdElpv5BK5D1oNxHoG4rlgWaD8H4QIhFXjV5fPk4GhDeT0z6cmrSTClW
Lb15A+OPJRTuAbin6mwNHH0de4OpC1e+a6Sn8E239aey8cFP+/Xd6Ja5mjpYajzM
6cf/6Zv8EE8jl+aWLqWhiNryPoBZDen2or7oeM+OiM5dEUG4uOw6mvEPeYZ1yA9a
kq3CdrjQSKvXVhKyptLFqt7ARwLyfphZ1/Cc66hgmNu77xBOMeSvd8HQN6VQaSx0
QuGBxeprMqG63VJ0MG67meKDARqX/IJOengC2sb8CglQ/M5zTHAWWhDpSZ1vYHPw
Xd5SQcqUaFsrUrtwsri1ujKrWgRGzqsqFwRKF7fqQuM9fM3Cxd/ZP0rbcS9dn30T
BEq01+ueUVT6A/we6Zjq8nXwwk+Fk6af016s5fTlATmxUX7PSDG1Xsya0tMJD077
mfFg8RuZEb+vgoxi1/42SB+H515sqYm1iC4Xytqu9r98u1xS7ePbA2KwF5iWZyrw
kQU/vE90eHrblIcEsHXLwK40Z371h6LA48ef6AteItZCiP6F6RPa6LLH+P4vh5tt
bdfN813QbFXWh7tBx+R5RJjGIos0xeayo5SEAggCDcKkwY7SJsuWHSCPdueBv9lH
TNIXfKipKVo=
=qGUT
-----END PGP SIGNATURE-----

--=-9dTudckZDEQnHZZNk+hQ--
