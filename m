Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaJONFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:05:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:12210 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbaJONFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,724,1406617200"; 
   d="asc'?scan'208";a="589394662"
Message-ID: <1413378213.2412.13.camel@jtkirshe-mobl>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 06:03:33 -0700
In-Reply-To: <20141015125934.GB23154@mwanda>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SYO2aaU8prczJEYBldqB"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SYO2aaU8prczJEYBldqB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-15 at 15:59 +0300, Dan Carpenter wrote:
> Or we could fix it but add a multi-line comment with lots of capital
> letters and exclamation marks.  I guess we would need to make a
> function
> since this cast is in several places.
>=20
> void *silence_buggy_casting(u32 pointer)
> {
>         /*
>          * DANGER! DANGER! DANGER! DANGER! DANGER! DANGER! DANGER!
>          * FIXME!!!  We know this cast is totally buggy.  The BCM
> driver
>          * doesn't work on 64 bits.  But no one knows how to make this
>          * work.  Oh well.  Let's silence the GCC warning.
>          * DANGER! DANGER! DANGER! DANGER! DANGER! DANGER! DANGER!
>          *
>          */
>         return (void *)(long)pointer;
> }
>=20
> Something really ugly and gnarly like that would be hard to ignore.

I thought I remember Greg saying something about getting rid of this
driver anyway, but I could be wrong.  If Greg decides to keep this
driver around, then I think we should something like your suggestion
above.

--=-SYO2aaU8prczJEYBldqB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUPnClAAoJEOVv75VaS+3OlPoQAJCZ7hR0NiiKkfAVdSSnmZDR
Jb5GLoc2+mEnq8MFz8r61qsHcXs9cFpKQ+27EiJF6xXwBzsxjJhgXNsgrfYOdpnQ
252u9obalgYFkshqkdF6yRGMCwiXi2nksXiAa9fhXy9Xl3sIGCDyDg9YF0K/H84/
JUtL45lXgaG5Kv49N4LJz/RvwrvrIuY9pO3BGKvWokZ7NEDO3JOm6v6tW7KboQLd
pzGlrtiiuKlPMjOoDJGAsnk2MHU8BHNHAkflI9bAYP6oO/7VG6PsUAmNeKCWfGr9
PGTMy5v1a0Vq8me7+6LJyUM2LCD18p4dGawGeB+/vX5o7LNVevgN5fX1jjOIAomy
naiE9vvzO+EnXlWZA7yHWvlSzorRwMwkCQwK+dIjcdXqjIwPqNfFcgt4oc4zY0GM
DXVOYOp2NknTFlHj2Kn9++VkxnVcOaIU8MQRHcuIN4gkmfx57NXYYv8grtu2a8e4
OQM9lR6qTkWxef9K9clOZPCtPT9UqM8U+bGghf1qp/KKPXYfU4poVYlaGUCEFyW3
Mi9+pjudlPseZSSUGqZoH28wH0piWULEkxJLnoamuH50vBtCVCUon9v13RYjAcek
AC6deYmK1Ucz6FyOxKXXrxZ/y4DGUcUL6mQRoBwI0YzSktSDORVaFrSe91Yd0o7z
8KRGo2kZnFeaMbX0Jbte
=KlSm
-----END PGP SIGNATURE-----

--=-SYO2aaU8prczJEYBldqB--

