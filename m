Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaCDXgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:36:45 -0500
Received: from ozlabs.org ([203.10.76.45]:48909 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaCDXgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:36:43 -0500
Date: Wed, 5 Mar 2014 10:36:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140305103636.3185c4b4f3e7a3b6ecdbed2f@canb.auug.org.au>
In-Reply-To: <20140304080655.GD10579@lee--X1>
References: <20140211132552.68b0802fd8742c6d72dfa738@canb.auug.org.au>
	<20140304140318.06e7a535ed06e9432e5df7d9@canb.auug.org.au>
	<20140304080655.GD10579@lee--X1>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Mar_2014_10_36_36_+1100_Q8uGbWhRzuasC0dC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Mar_2014_10_36_36_+1100_Q8uGbWhRzuasC0dC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Tue, 4 Mar 2014 16:06:55 +0800 Lee Jones <lee.jones@linaro.org> wrote:
>
> > > After merging the mfd-lj tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > drivers/mfd/tps65218: struct i2c_device_id is 32 bytes.  The last of =
1 is:
> > > 0x74 0x70 0x73 0x36 0x35 0x32 0x31 0x38 0x00 0x00 0x00 0x00 0x00 0x00=
 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xf0 0x00 0x00 0x00 0x00=
 0x00 0x00 0x00=20
> > > FATAL: drivers/mfd/tps65218: struct i2c_device_id is not terminated w=
ith a NULL entry!
> > >=20
> > > Caused by commit cc493e30e3a1 ("mfd: tps65218: Add driver for the
> > > TPS65218 PMIC").
>=20
> -rw-r--r-- 1 lee lee   6320 Mar  4 15:20 tps65218.o
>=20
> Hmmm... I'm having trouble reproducing the error. My toolchain
> doesn't complain about the lack of a terminating entry. I have fixed
> the problem and re-pushed the branch though. Would you be kind enough
> to re-test it please?

I assume that the error comes from some post processing that happens late
in the allmodconfig build process.

You current tree build fine, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Mar_2014_10_36_36_+1100_Q8uGbWhRzuasC0dC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFmOJAAoJEMDTa8Ir7ZwV4KoP+QFIAjbfG2BF1nY+eVOYiSak
LNoKiB+KABQNDIr81JEux9/NG/eS5c6H7h2wYGSSb9tfquDyv49OLqC2VhEag9Rb
cXu+cqUDosk5fC6t4zLxDHXtoTgnj2tdrR/L9bhr64fpplLxBrRhXgQDMaj/qJm9
CjEYNA1LkThjUmPouBQSDGsxz3y8X4wK+giaB2t50w3H0lqA78ZTOM1/L9lLZPGw
y/hh1BVoSADlqa9oCUBQ41yw54jpaupUMwAA7UocaMLH+VKE9vW0kTkMLxd3VX+X
l8nGJnE6SiQipS3VUdAPNB8EImmhLfxVN4vwgR9iJtm4E1opczY0cS2o4SQ8BgDl
MWVL2+ym+Dx996zW26fIBCqY25Uee6rMjHpio6tCHvb8GQ03ZU0I+F/rViss7kZJ
alpGwGk8Gu+D76+//FJGQRAkwqnRrRa4xKKoD8V4Y3M4eUNk5xIpDDYm2K8aHno3
Yf1K9hwEQCW0tyj/yW6KZXNJHw3P2tN8RG1gRgheCrAgq3wEpYPszevLvb98DEOs
ZdfeD9l8+KN7Ll1ZIgoOwQnrPs4Revm+d5JCVYWA0glfY6MJldQ0sM5Pphzu0yBw
TqZaWobJs+KFzG1I8rUJuvhhkZg9lnkDMVofJf+SJOeIAy1MmKpODev0egphPVUi
r6x4z6LCvcVj+/FEf1pH
=HzLA
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Mar_2014_10_36_36_+1100_Q8uGbWhRzuasC0dC--
