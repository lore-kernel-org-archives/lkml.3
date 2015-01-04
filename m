Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbbADWBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 17:01:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59278 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbbADWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 17:01:20 -0500
Message-ID: <1420408867.5686.145.camel@decadent.org.uk>
Subject: Re: [PATCH net-next v1 1/7] net: ethtool: extend link mode support
 to 48 bits
From: Ben Hutchings <ben@decadent.org.uk>
To: David Decotigny <ddecotig@gmail.com>
Cc: Amir Vadai <amirv@mellanox.com>, Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Masatake YAMATO <yamato@redhat.com>,
        Xi Wang <xii@google.com>, Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Date: Sun, 04 Jan 2015 22:01:07 +0000
In-Reply-To: <1420405017-23278-2-git-send-email-ddecotig@gmail.com>
References: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
	 <1420405017-23278-2-git-send-email-ddecotig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ea6PWPqluhAEhoEOcaA8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ea6PWPqluhAEhoEOcaA8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-01-04 at 12:56 -0800, David Decotigny wrote:
> From: David Decotigny <decot@googlers.com>

This is mostly fine, with just a few minor issues.

> Signed-off-by: David Decotigny <decot@googlers.com>
> ---
>  include/uapi/linux/ethtool.h | 130 ++++++++++++++++++++++++++++++++++++-=
------
>  1 file changed, 110 insertions(+), 20 deletions(-)
>=20
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 5f66d9c..61e7734 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
[...]
> @@ -123,6 +140,46 @@ static inline __u32 ethtool_cmd_speed(const struct e=
thtool_cmd *ep)
>  	return (ep->speed_hi << 16) | ep->speed;
>  }
> =20
> +/**
> + * MAKE_ETHTOOL_LINK_MODE_ACCESSORS - create the link_mode accessors
> + * Macro to generate the %ethtool_cmd_supported_*,
> + * %ethtool_cmd_advertising_*, %ethtool_cmd_lp_advertising_*,
> + * %ethtool_eee_supported_*, %ethtool_eee_advertised_*,
> + * %ethtool_eee_lp_advertised_* families of functions.
> + *
> + * Macro args:

Delete the 'Macro args:' heading; that's implied by the @ prefixes.

> + *  @struct_name: either %ethtool_cmd or %ethtool_eee
> + *  @field_name: name of the fields in %struct_name to
> + *      access. supported/advertising/lp_advertising for ethtool_cmd,
> + *      supported/advertised/lp_advertised for ethtool_eee
> + *
> + * Generates the following static functions:
> + *  @ethtool_cmd_supported(const struct ethtool_cmd*): returns
> + *      the 64b value of %supported fields (the upper bits 63..48 are 0)
> + *  @ethtool_cmd_supported_set(struct ethtool_cmd*,
> + *      ethtool_link_mode_mask_t value): set the %supported fields to
> + *      given %value (only the lower 48 bits used, upper bits 63..48
> + *      ignored)

Delete the @ prefixes from these headings.

> + * Same doc for all the other functions.
> + */
> +#define MAKE_ETHTOOL_LINK_MODE_ACCESSORS(struct_name, field_name)	\

I think the name should begin with ETHTOOL but it's not a big deal.

[...]
> @@ -1192,6 +1273,9 @@ enum ethtool_sfeatures_retval_bits {
>  #define SPARC_ETH_GSET		ETHTOOL_GSET
>  #define SPARC_ETH_SSET		ETHTOOL_SSET
> =20
> +/* Do not use the following macros directly to update
> + * ethtool_cmd::supported, ethtool_eee::supported. Please use
> + * ethtool_(cmd|eee)_supported(|_set) instead */

The ending */ belongs on a new line.

>  #define SUPPORTED_10baseT_Half		(1 << 0)
>  #define SUPPORTED_10baseT_Full		(1 << 1)
>  #define SUPPORTED_100baseT_Half		(1 << 2)
> @@ -1223,7 +1307,12 @@ enum ethtool_sfeatures_retval_bits {
>  #define SUPPORTED_56000baseCR4_Full	(1 << 28)
>  #define SUPPORTED_56000baseSR4_Full	(1 << 29)
>  #define SUPPORTED_56000baseLR4_Full	(1 << 30)
> +/* TODO: for bit indices >=3D 31, make sure to shift 1ULL instead of 1 *=
/
[...]

I don't think that comment is necessary; the compiler will surely warn
if someone forgets.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-ea6PWPqluhAEhoEOcaA8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVKm4KOe/yOyVhhEJAQqenBAAqKqgR51wdo8VOmQ1sCRNP1JmUo5WwkVe
O/vPE5KZ77oZvkFbonJMuV6MWoZcf+YD+ZmYPxGgXPs2Oa6JqC2WLQWv+WZjPffE
wjE6+RWYJEusVZLa/2FJRgZjFSd6Zoum/S19v1UEY/w8tyut0Vwv1SZ04kylxA+7
p9xwfLPyE8gA/tP+2K6RvPq2eVhLpEdTnCPEAVKgU7+Fpl2bGmIarm/5PkFTBO9v
7yMNZ32jFQ/2ND5FEioAi3ADBzPaZu61rexi4G77I7cUgsQiL91ktjo6c3shT3ye
ZF67TSDqJxUNvvZ/H9PVKzXP6/NL4ZCM0UyaVsAxAVRN+BDckMfqCvW6AkvjCFqC
FTajgnUUeNv1efdwTWEvf2YZ5Wh+5hgzbFVD2QmDnhS3yNJcwJ9e5drLtnnDOPVe
XgUUug0Pvvs7W6mEwXBMaJ7Bu+ASQwuvBZPM0iws5XzSPTa4a+WOWdIJnxxTj1w2
Dc6BM5ixgmVg071noq/K7M6twYsH/2qplTdLUBgx6o7JcV/NnOsxyWYJ3NKff/fV
OlY8IXiuGUey6EJo2TzH8XJHWw0t2QFYNG+0zrhos2wKsRoHZ67bbtTWledqgWQY
kN1H/lUz8F95/jtPAJQdbwaoa2kmpkpNpEDwiD/p1+SV5rPd1MePniMqCluJTFOB
nMlle7d6W1w=
=2W5U
-----END PGP SIGNATURE-----

--=-ea6PWPqluhAEhoEOcaA8--
