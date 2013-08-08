Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3HHAga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 20:36:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37267 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367Ab3HHAg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 20:36:29 -0400
Date: Thu, 8 Aug 2013 10:36:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-Id: <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au>
In-Reply-To: <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
	<CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
	<20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
	<87zjsted0c.fsf@linaro.org>
	<20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Aug_2013_10_36_14_+1000_/ajgsiOJz2ZQQW1b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Aug_2013_10_36_14_+1000_/ajgsiOJz2ZQQW1b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Aug 2013 10:22:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:
>
> More quick testing with an empty file: v3.9 is OK, v3.10 gives
> CONFIG_MODULES unset.

Bisecting gives:

cfa98f2e0ae956feca935573e977d7661a9561b9 is the first bad commit
commit cfa98f2e0ae956feca935573e977d7661a9561b9
Author: Yann E. MORIN <yann.morin.1998@free.fr>
Date:   Wed Apr 24 22:00:04 2013 +0200

    kconfig: do not override symbols already set
   =20
    For randconfig, if a list of required symbols is specified with
    KCONFIG_ALLCONFIG, such symbols do not "have a value" as per
    sym_has_value(), but have the "valid" flag set.
   =20
    Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>


And reverting that commit in v3.10 gives me CONFIG_MODULES=3Dy.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Aug_2013_10_36_14_+1000_/ajgsiOJz2ZQQW1b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAugCAAoJEECxmPOUX5FE4s0P/jC9yZP09HCIs47RCxbgn7V4
npuz6spGDerVrdj/NlbxGZQoUocQQJUH/U/+7vdIbI64EZY99DybUmjW6ZxN97VN
PstI6genZ7M0cWwcQfq6fqjD64rtb/dcHKOoDJZf/4XRU8LwHH74eqPDY5gMOqTd
JJMX1LxQZ9OdzD1p8/kRwgb/QB/g/fWsB7ytCJzjawOvb8TUMVamxvDJEUeKUV/R
NiH5DBjTWB4yRi6qCF/siFIi8AYN78XqpXcqW9xEE9ZI9qc7Bq+yCKHbbUKYDtJM
NXKZZ53zMN9c5JTGO7dyHMwEO26YsyGOPjDlV4f5L4+tjJmsHPVCy6puOapwX2UR
rPLERHm+TEHr02ig/3ymtMVW1OHmdmTx9Oxzg8SnyPDQ/rFim0WJxBDswQi411EE
r1wgQQBvyTnf1lMXKifKj9fvm1dIkcP17qrmyW6pJNu54ILou3S/kDqDu354Rmth
deWLW2DmH3pFOFoO4n2dHHnD1q4osOZxi6QlBBN2E+tsyUv36LzE28Wk0HLoSeo0
wq9g8zvE2KwAXDEQytMg7ZL/DZ0UgnGQnqt393zydxLfNi0D6csypxu+nV2dgJvO
X8kSgOdpp/9yEpkErvfx40d/Ip24NGLYvfOC6HKES4QrodapcGGqG5f3GYQfyIuC
QSTb8xz9sFCjhIKwHLIa
=7oHy
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Aug_2013_10_36_14_+1000_/ajgsiOJz2ZQQW1b--
