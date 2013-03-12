Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3CLTzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:55:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49894 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196Ab3CLTzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:55:49 -0400
Date: Tue, 12 Mar 2013 19:55:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V2 RESEND 1/2] regmap: irq: Add support for interrupt type
Message-ID: <20130312195546.GH19942@opensource.wolfsonmicro.com>
References: <1362673997-6762-1-git-send-email-ldewangan@nvidia.com>
 <1362673997-6762-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PK5kSfjks5jzTD3m"
Content-Disposition: inline
In-Reply-To: <1362673997-6762-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PK5kSfjks5jzTD3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2013 at 10:03:17PM +0530, Laxman Dewangan wrote:

>  /**
> + * The Regmap IRQ type Index
> + * REGMAP_IRQ_TYPE_NONE is used for setting inital value for clearing type.
> + */
> +enum {
> +	REGMAP_IRQ_TYPE_NONE,
> +	REGMAP_IRQ_TYPE_RISING,
> +	REGMAP_IRQ_TYPE_FALLING,
> +	REGMAP_IRQ_TYPE_BOTH,
> +	REGMAP_IRQ_TYPE_LEVEL_HIGH,
> +	REGMAP_IRQ_TYPE_LEVEL_LOW,
> +
> +	/* Last entry to get maximum index */
> +	REGMAP_IRQ_TYPE_NR,

Why can't we just use the normal IRQ_TYPE macros?

> + * @type_reg_sub_offset: Suboffset for type register if type mask are
> + *              accomodated in the multiple register.
> + * @type_supported_flags: Supported interrupt type as per interrupt.h.
> + *             All supported flags are ORed.
> + * type_mask: Type mask for getting related register bits.
> + * @type_value: The type value in array form to set value for a given flag.

This is making my head hurt, it's a bit confusing - I'm having to think
too hard to understand what all these different fields do and how they
interact.  Especially type_reg_sub_offset which feels like it must be
part of a wider feature to support a greater range of register layouts.

Can you clarify a bit please?

--PK5kSfjks5jzTD3m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP4g1AAoJELSic+t+oim9bzYP/jqiZNPB9D5Api8mNcyh8DFU
NJvOKp/bnaRAxrUhm3NyxKgdx8w+jNDdfA95Sj/fh495N+OzN3q3vGzcZvRqOB73
tlfUAXybUKITGEP3IoVn//gxwqxtklrp+0OQqcKpgDenW3bjd00edjS7LU9bsjG/
0zaKvfi3i1WkUphbFKluq6gVnsx/6EL0GDNG5nT/pCyeTAcg/Ry76KW6QzR0ccbV
EiF4Ij5JgKI6fapzR4nsMuAdH2xy7SaGrV7rcHQoaZKWuLWh7zzf44w9CJd+dZaE
95fI6WoErcGvAhpH7LqIjthALvXpwz385NADIJ3+KZpZVaDCqn3uWj/YNS3t7pYZ
t2rFtErSe6efA6WfNrz6NgCGO+6LQTyiQl0zM721SyPxXLJsc7a3DkQu953LbGDD
84waaFVUHRZaVXKo0RWSRwuLQ51FSVvPjcttmF8zKWAQ3UW1K+uGI54ow6pF6aGg
nVQrGK73S90PfPq8kKRxTdwkCr2T3iGr/XF5BOKSgum5Hf3ns7BGz9PVrSCJmn9u
RXdvcg9WscQ7+RDQervjJqvXily33NMka0pr0H7BIuG3OaC6b4tVPHu6qUKb49iT
Z3LPMJose9/gXjaiZ4FFzwz0kyDRtSqh21aHFu3NoXJBzZIhjYRYEymy0YIlhnbc
0HVBprFTb23OrqTEa3TG
=8hB6
-----END PGP SIGNATURE-----

--PK5kSfjks5jzTD3m--
