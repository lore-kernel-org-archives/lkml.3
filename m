Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaBRBoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:44:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40981 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbaBRBoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:44:14 -0500
Message-ID: <1392687834.10088.17.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] workqueue: Document exceptions to work item
 non-reentrancy guarantee
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        stable@vger.kernel.org
Date: Tue, 18 Feb 2014 01:43:54 +0000
In-Reply-To: <1392493119-9277-1-git-send-email-peter@hurleysoftware.com>
References: <1392493119-9277-1-git-send-email-peter@hurleysoftware.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YpuvPmv+Tr5QojJhW38R"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d8bb:639b:205c:713a
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YpuvPmv+Tr5QojJhW38R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-02-15 at 14:38 -0500, Peter Hurley wrote:
> Since commit a2c1c57be8d9fd5b716113c8991d3d702eeacf77,
>   workqueue: consider work function when searching for busy work items
> work items whose work functions are re-assigned are no longer guaranteed
> non-reentrancy with the previously assigned work function. For example,
>=20
>         PREPARE_WORK(&work, funcA)
>         schedule_work(&work)
>           .
>         < funcA starts >
>           .
>         PREPARE_WORK(&work, funcB)
>         schedule_work(&work)
>=20
> funcA() may run concurrently with funcB().
>=20
> The work item non-reentrancy guarantee is a crucial design guarantee
> which, if violated, may not have obvious consequences. For example,
> the entire firewire subsystem expects the as-documented per-work item
> non-reentrancy guarantee, which was the behavior prior to the above
> commit, not the per-work function + per-work item behavior since.
>=20
> Document the known exceptions to this guarantee.
[...]

It never would have occurred to me that you could safely change the
function for a work item that is already scheduled or running.
Especially given that PREPARE_WORK() is just a simple assignment (i.e.
no serialisation).

Perhaps there is a need to document more generally how PREPARE_WORK()
can be used, not just this quirk of reentrancy.

Ben.

--=20
Ben Hutchings
Nothing is ever a complete failure; it can always serve as a bad example.

--=-YpuvPmv+Tr5QojJhW38R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUwK62ue/yOyVhhEJAQrmdw//ZktygV//PrU5mDg7sAWrAN6tntnoFXMh
s2isoDEE2vsPJK2XbCXS2PDTdTFUmwT2R3mqPCg7SVv3OMUDQNlL1LWwHfROevLR
Sn9Dxri7+vn2zE+OkEL8o7bTzH7R7MeqyVV94AjVyye3D1RxaoO5KLbROErrXcT7
R6ub6vQYSDyhZi8raVjcmIgA8oi5xJea5O4Q2WJaxB80B+4HzEMs+rYB+KHjpBCx
lynjJTkpwGdttz5G4tag+kPeQ4GUttNQV4UUBV3kYX+Z5VM6TK9rr84OkMHGGjGs
+WYghC4u0x3yGR25MVBUVLAuyNpk7H0OzNiB0z4BF734u+YwugmPEt3aKyHR/8lN
u3auVThykRCFh8hxbst1/sQ2xoJ1id34RS3ZiMMRC7qCIFwJthcsYctM9Zr6GsiC
NFD3UPanORk9EmcKOid5jDmm6JZwV5aTQe0HS9REfFE8qeuVyVvoz2+NUIIkjSda
6P3FLuszFBirg/FxDX9zF34SGoWR59eu+Hy+Wh8FSmmFR34Sbj6Y4RR5Aufe8VtD
boTKScqrHJ6Wt9oXWnxv77cCe5dAsP1SYDBUVtlMAcGc8fH1GYZNTi0Ed4PPD6yC
eIntcb4YtyOhKqrWjMG+YQbWB3nrIObqGotxe2LnOe4LuOOC/s8VPnRRkbyBmRjZ
XH399hv5GPI=
=n5Wy
-----END PGP SIGNATURE-----

--=-YpuvPmv+Tr5QojJhW38R--
