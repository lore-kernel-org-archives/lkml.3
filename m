Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab3G1VPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 17:15:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36050 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723Ab3G1VPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 17:15:42 -0400
Message-ID: <1375046132.2546.30.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 71/79] ext4: fix error handling in ext4_ext_truncate()
From: Ben Hutchings <ben@decadent.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 28 Jul 2013 22:15:32 +0100
In-Reply-To: <20130728114053.GA19995@thunk.org>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204730.256399621@linuxfoundation.org>
	 <1374960811.3607.15.camel@deadeye.wl.decadent.org.uk>
	 <20130728114053.GA19995@thunk.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ifp+QnY4RJULAuGb6y4I"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ifp+QnY4RJULAuGb6y4I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-07-28 at 07:40 -0400, Theodore Ts'o wrote:
> On Sat, Jul 27, 2013 at 10:33:31PM +0100, Ben Hutchings wrote:
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -4386,9 +4386,20 @@ void ext4_ext_truncate(handle_t *handle,
> > > =20
> > >  	last_block =3D (inode->i_size + sb->s_blocksize - 1)
> > >  			>> EXT4_BLOCK_SIZE_BITS(sb);
> > > +retry:
> > >  	err =3D ext4_es_remove_extent(inode, last_block,
> > >  				    EXT_MAX_BLOCKS - last_block);
> > > +	if (err =3D=3D ENOMEM) {
> >=20
> > Positive ENOMEM?!  It looks like this value is bubbled up from
> > __es_insert_extent() which returns the usual negative error codes.
>=20
> Nice catch.  Yup, that's a problem.  I'll fix this upstream and mark
> it cc:stable.
>=20
> Until this goes upstream stable kernel maintainers can either: (a) fix
> up this patch by making the line read "err =3D=3D -ENOMEM", (b) hold back
> this patch until the companion patch to fix this goes upstream, or (c)
> apply this now, since it's otherwise harmless and it does add error
> checking to the ext4_ext_remove_space() call.

We do need that second fix upstream first.  I agree that this seems to
fix a bug and doesn't make the ENOMEM case worse.  If this is applicable
to 3.2.y (I think it isn't but haven't checked yet) then I'll go with
(c).

Ben.

--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-Ifp+QnY4RJULAuGb6y4I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfWJ9Oe/yOyVhhEJAQrxAg//bHpGWi+DkbJFIOyZi2UmdMoGzx/iAyWe
AqIFzZv6+vi7uYAVW0J8aWvqSIMCJ+EMNpL0/Um/tttlXoNc1DUcHPJKWwQ7QEae
EADRqAAkmLfo8edGd5ZNKqircWl/O5eiIun88P8c1mufYiQQcJ5gmg+N1dtR+cZi
dkZI41okPOOKvl4/krkrhR29tSHEQONGFrRqWf689HFLFkSdeRPp/qe3/3KKCfkB
HsL5zEfCttykwd/nQz1t3WXJaSmltMQ/vxN56qtOLawsc2y4R7HpgSMxggiNzrZ/
Qh5ZVV1gSp0gfuLQsNiMBscWJWr0v2CJLVr9m3qBhaRsbn2+QcglDDor2N0k98J8
R3AozP4vm3DYB53dZJROw8ZDYzLDkcw25ebMQRuERTvRwrFn8G83GJpNI0MKhfA7
3VHVPse6Q00UcThWZaVRC0o9W//4IsAMnLzfrwx4JOmjhg3Gi4SJBxt/zbXfk13q
JeIthpoduZgvN9LfUBdxmTv4MORfunkx2PO3sNn95VQXtcuwPokXJYrlxB6DvoDa
VUuF9hdjGNSLS94km9B6vPhfSWi+kF1GChV0JX7ViTJEQOfmlA5qEEA+B68wuoPC
LoHzuJ62camRSRTnT1+U3d2n5d1OgkyQ4CufAyD4J8MFYFh1jhj7ROPOryBEkRMV
ofuQuwiExaE=
=r/RM
-----END PGP SIGNATURE-----

--=-Ifp+QnY4RJULAuGb6y4I--
