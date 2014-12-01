Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaLAENJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 23:13:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33827 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbaLAENF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 23:13:05 -0500
Message-ID: <1417407157.7215.127.camel@decadent.org.uk>
Subject: Re: [PATCH v7 28/46] vhost: make features 64 bit
From: Ben Hutchings <ben@decadent.org.uk>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Date: Mon, 01 Dec 2014 04:12:37 +0000
In-Reply-To: <547B3B61.3090801@cogentembedded.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	 <1417359787-10138-29-git-send-email-mst@redhat.com>
	 <547B3B61.3090801@cogentembedded.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qy6KHeFStlY1bi18Qj3Z"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:1079:d8f7:d09f:54f7
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qy6KHeFStlY1bi18Qj3Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-11-30 at 18:44 +0300, Sergei Shtylyov wrote:
> Hello.
>=20
> On 11/30/2014 6:11 PM, Michael S. Tsirkin wrote:
>=20
> > We need to use bit 32 for virtio 1.0
>=20
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Reviewed-by: Jason Wang <jasowang@redhat.com>
> > ---
> >   drivers/vhost/vhost.h | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 3eda654..c624b09 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -106,7 +106,7 @@ struct vhost_virtqueue {
> >   	/* Protected by virtqueue mutex. */
> >   	struct vhost_memory *memory;
> >   	void *private_data;
> > -	unsigned acked_features;
> > +	u64 acked_features;
> >   	/* Log write descriptors */
> >   	void __user *log_base;
> >   	struct vhost_log *log;
> > @@ -174,6 +174,6 @@ enum {
> >
> >   static inline int vhost_has_feature(struct vhost_virtqueue *vq, int b=
it)
> >   {
> > -	return vq->acked_features & (1 << bit);
> > +	return vq->acked_features & (1ULL << bit);
>=20
>     Erm, wouldn't the high word be just dropped when returning *int*? I t=
hink=20
> you need !!(vq->acked_features & (1ULL << bit)).

Or change the return type to bool.

Ben.

--=20
Ben Hutchings
The first rule of tautology club is the first rule of tautology club.

--=-qy6KHeFStlY1bi18Qj3Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVHvquue/yOyVhhEJAQpWRQ//Rgnx+WWqV4UjzYHQPoSp6MvIL26bBpxJ
7C2q0p7pb3Q+8Dokc89hPc7aedPmELhhMTZZIVYgL53K64s6DB9ii4hiCdOT7UXB
GRwazzsQznU3rXk70elpjJ1ZL1vuRWo1vbSXrWQ7eiQKFo7IOjOjNiT6FA90/xWd
PcNMNCRbHozLd8cUOMagxS00GhfkqkHof/qgkTcLelGztI1T1TX+bHXmkXELzvhx
4HZxU3ycVX5Bmn4Q10fmiG0DEO/IOJUaaXL78k2V0LnW77zabrkQ+131SsEA/IPR
Wh2nsZDbaE5VFKoTmlFfPYfQh6W9xl+/kMNN+Fal08aFnosyuHdXQlSPLvuiy0Ro
Exox6/tXqcpzXPHnGh2/JxbTVldUghesNVONgEOqfUibJzwQczaSwL9hDksqYiMQ
DRac881Mev5Yz7VvHADWGaloZbuAWzgMggpI2FX7+gcs7JYz40Xn/C7BPMeoCB0M
UwMMtETiDpXFfFUQsDUL5CFf/Iueyge7+mYEj8A0kMv5a5lZ1lxEy5GnpFiNcqiZ
2K1VwAWdb4epcIbBJjEnqBiQAQVMSo6DkEdH5KYtXHShjtCk27/pB6q5sFRFC/el
UUYm+6ayfOY4SIXiWKyLdaGgKGS7qLd3xeOKjeEUz+uJbO/FABemNuqR75Sr4UDU
+wCIopnAhxk=
=KwA+
-----END PGP SIGNATURE-----

--=-qy6KHeFStlY1bi18Qj3Z--
