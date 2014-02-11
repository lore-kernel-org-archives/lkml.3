Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaBKQuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:50:23 -0500
Received: from s3.neomailbox.net ([178.209.62.157]:5247 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaBKQuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:50:21 -0500
Message-ID: <52FA546B.1060008@meshcoding.com>
Date: Tue, 11 Feb 2014 17:48:43 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Calvin Owens <jcalvinowens@gmail.com>, Joe Perches <joe@perches.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC: "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ieee80211: Print human-readable disassoc/deauth reason
 codes
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com> <1391661863.30094.56.camel@joe-AO722> <1392030546.4128.11.camel@jlt4.sipsolutions.net> <1392050359.2507.10.camel@joe-AO722> <20140211012523.GA2739@gmail.com> <1392082740.2507.49.camel@joe-AO722> <20140211163738.GA32043@gmail.com>
In-Reply-To: <20140211163738.GA32043@gmail.com>
X-Enigmail-Version: 1.6
OpenPGP: id=43FD7307
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TqvpCLocJD7n3wtgTEobcJsUN51HG72Ag"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TqvpCLocJD7n3wtgTEobcJsUN51HG72Ag
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/02/14 17:37, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that in addition to the numeric value in the kernel log. Thes=
e
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity=

> issues.
>=20
> Changes in v2: Refactored array of strings into switch statement.
> Changes in v3: Fix style problem, use simplifying macro for switch
> statement, eliminate temporary enum variable.
>=20
> Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
> ---
>  include/net/mac80211.h | 10 +++++++++
>  net/mac80211/main.c    | 57 ++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  net/mac80211/mlme.c    | 12 +++++------
>  3 files changed, 73 insertions(+), 6 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index f4ab2fb..d18acfe 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2971,6 +2971,16 @@ struct ieee80211_ops {
>   */
>  struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
>  					const struct ieee80211_ops *ops);
> +/**
> + * ieee80211_get_reason_code_string - Get human readable reason code
> + *
> + * This function returns a string describing the @reason_code.
> + *
> + * @reason_code: Reason code

Kerneldoc is not properly formatted here.
The "@argument:" clause should be on the line right after the function
name (as explained in Documentation/kernel-doc-nano-HOWTO.txt), e.g.:

/**
 * function_name - blabla
 * @arg: I am a good arg description
 *


Cheers,

--=20
Antonio Quartulli


--TqvpCLocJD7n3wtgTEobcJsUN51HG72Ag
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+lRxAAoJEEKTMo6mOh1V/n0P/ilGrLK6JIBczuqPncKiB3kl
/5Md+JunEkQW7VVv4eey3bZZvINx1lZ8VerScSeHQRlUGg/eUFS2i4xkpd5hdL/m
A9Py9IWCXrOpidUNiQzx9iG7lg8gmWwkxiXPezC9+pEBqe7n823L/OFS2NonizHv
SqOJjhTaykOQAgKf1mBL+YV5WOUydV3BNK91pjraSrJBHYxHAv4OBBuNRJuat4E9
wDjVVrW4s1haC0UK/cD8l0e35MWC3Sjdvozsda2PZxzDDKd8VRyHrnT2i3yHOdgt
9i9TeuPYeYyB8+PVlPrxK/aCXnL9yuOwItQ62n0aipiLL7oqNCErCIgXMnABL8GH
mC6Ku+TVhBJ97FVLmw45eIh+zvEGKzRXnv0jUIi3kS5bg926NOPvgNgr23uyatIW
dWauzn2AicyxCVBBwwpdIBHgy5jFYhXc3BGd4Ih8fBClplOXWEVFS30hw9xk+YUK
a/WokptTV5SyHCucpXulZKbXE9E6qSACjRjz8ybTrvFABQQPfZc+T83eN6ktpJeS
SSdMrLK7lNk8dz8alq/zmGbYWAesFAEcPr3RiWKM1l7vuZ92eV5mTru6c124fqP7
QApBrh7qqTVVHi0i54EmE+qoTGA62+D0t2WX6Nko9SSnNrWaKHQvjF9JvfaFLNjl
J8TaKAgAZdcZfpyzjAgG
=PHgj
-----END PGP SIGNATURE-----

--TqvpCLocJD7n3wtgTEobcJsUN51HG72Ag--
