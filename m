Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaHAOKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:10:05 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44144 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaHAOKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:10:03 -0400
Date: Fri, 1 Aug 2014 16:09:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/io.h: reorder funtions to form logical groups
Message-ID: <20140801140956.GA1913@ulmo.nvidia.com>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <20140718205953.GA21964@ravnborg.org>
 <20140719125937.GA18566@ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20140719125937.GA18566@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2014 at 02:59:37PM +0200, Sam Ravnborg wrote:
> From 929c64c1aaf378b767e0ed89826b6bb12449df15 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 19 Jul 2014 14:47:43 +0200
> Subject: [PATCH] asm-generic/io.h: reorder funtions to form logical groups
>=20
> Reoder the functions so the various functions are grouped
> according to how they access memoy.
> For example __raw_{read,write}* are now all grouped.
>=20
> The benefit of this grouping is that one can easier find all
> IO accessors of one type.
> To do so a few more #ifdef CONFIG_64BIT had to be used.
>=20
> Add a small boiler plate comment for some of the groups to
> better let them stand out.
>=20
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>=20
> Hi Thierry.
>=20
> This is my attempt to bring some order into io.h
> with respect to the order the functions are defined in.
>=20
> In a follow-up mail I also said we should delete the _p variants
> of some methods but I then learned they are for slow IO access.
> So these I have left as is.
>=20
> And introducing static inline for all functions that are pure macro
> substitution is also left out for now.
>=20
> Please consider if you will take this as a follow-on patch.

Just a short update on this: I've pulled your patch into my series and
then thought I'd make a last pass over these and send out a new version
but then I started noticing a few more things that I thought I could
quickly clean up as well. One thing led to another and I'm now up to
double the number of patches. I still think it's worth doing, but
unfortunately it's become somewhat more complicated since it now touches
a couple more architectures and even some drivers (/dev/mem (!) and
sunzilog).

I'm almost through sorting out the remaining issues I think, but it'll
take me another couple of days to rebase and squash patches and run some
build tests to verify that things don't break somewhere in the middle.

Oh, by the way: would you prefer that I keep your patch separate or
shall I just squash it into the one that has the major asm-generic/io.h
cleanup?

Thierry

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT25+0AAoJEN0jrNd/PrOhe30P/ineumK56L2BTvHKxwre7TvU
ktlIGWcQyCqWV0swR3nVvJRJJzPcqW+vsi0nIbHDBN9DK1s0iYpS4htTxDL/9li0
r3vSlqlbuNmGBmlEh8NzTOVXIrlYy6o3wEAYm8CcmEwCpV8BPvHw1z/Fj4l/spYh
ehWwbVPSsSb12xFPpDDb1crmPzmXR/kKQ6rWjID1GWVqbNjnxFPopEb+otgYLTtB
mgixDgJ36t/uS+JWJM4iQX6YuJUySlsIV3z+sM+n4wJlfJyn7Zdn86Bw2m9wiYtI
lRXJm322gcegEwxwgDbilSGnnYzszmOFtguhba1LKXXP4vvRqgGwPMbunUVqvsl2
CBY5IdN/luYydPLt2x2pALPxt+B9zqQUczUCwa83boNDsCZm2f8ff+qaPxQShDJp
ta78e9JX37oT+DvjjBOU7wIrwOMOnKfIumBDj3+GAMdYhvp1HeUPjKvfacKTQtZx
uQU/r9rBZ7JLlCqQiCv6lnHpWAZp31ZqA5JIrMCvdG9V3kTLikxbY0LBgz77v3km
/l3gbQrlnxikfRoOmsj0yha6J+E6bLbTLBtYt605nLxqxmTUMg5w/m6986orMq13
BGKQAgpmBQU5KxgVptK1oTeeZf79QPzonQckAv+DlM1BRugNRR4iBgmXX7hCFh/L
GCFW0WaQB8rcPmFyYllk
=Dp+w
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
