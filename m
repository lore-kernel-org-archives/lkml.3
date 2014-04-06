Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaDFNAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:00:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58205 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbaDFNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:00:49 -0400
Message-ID: <1396789244.22689.121.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH < v3.10] ipc/msg: fix race around refcount
From: Ben Hutchings <ben@decadent.org.uk>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Date: Sun, 06 Apr 2014 14:00:44 +0100
In-Reply-To: <20140326101218.11221.74072.stgit@buzz>
References: <20140326101218.11221.74072.stgit@buzz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pa31kIrzH+W9QI94Pk0G"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pa31kIrzH+W9QI94Pk0G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-03-26 at 14:12 +0400, Konstantin Khlebnikov wrote:
> In older kernels (before v3.10) ipc_rcu_hdr->refcount was non-atomic int.
> There was possuble double-free bug: do_msgsnd() calls ipc_rcu_putref() un=
der
> msq->q_perm->lock and RCU, while freequeue() calls it while it holds only
> 'rw_mutex', so there is no sinchronization between them. Two function
> decrements '2' non-atomically, they both can get '0' as result.
[...]
> In the mainline this has been fixed in v3.10 indirectly in commmit
> 6062a8dc0517bce23e3c2f7d2fea5e22411269a3
> ("ipc,sem: fine grained locking for semtimedop") by Rik van Riel.
> That commit optimized locking and converted refcount into atomic.
>=20
> I'm not sure that anybody should care about this bug: it's very-very unli=
kely
> and no longer exists in actual mainline. I've found this just by looking =
into
> the code, probably this never happens in real life.

Queued up for 3.2, thanks.

Ben.

> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> ---
>  ipc/msg.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 7385de2..25f1a61 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -296,7 +296,9 @@ static void freeque(struct ipc_namespace *ns, struct =
kern_ipc_perm *ipcp)
>  	}
>  	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
>  	security_msg_queue_free(msq);
> +	ipc_lock_by_ptr(&msq->q_perm);
>  	ipc_rcu_putref(msq);
> +	ipc_unlock(&msq->q_perm);
>  }
> =20
>  /*

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-pa31kIrzH+W9QI94Pk0G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU0FP/Oe/yOyVhhEJAQpVJg//eBq4VYX/yWW1yVF+B6wixB8Kh3Ifz8n3
2Af2uvv366uOu7xsLsPzSl8P7jKiI1PtQ0XFj/uLk2U0ZypYw+6brt1Amkg5ePCV
zcGr03h4zMetjnEatRwkLrFvIyelrf2aE/EEfCpYbeIf0p9DDdtepJTu8JKi7tBr
rQr9nNT1WD0+BbVxu/Ohti7Nt4tG3doI/tVtqe41z+076HTRL510X8evFP8CtUBG
L3D73SKOZ1R6UJAL4FERpgP+GGYxnDd2g4tghuI67eMJ4eDkWRjQWk2vNy4mNGh7
34BW1ZPALgr/BAohuaZp2bJdrW8KWTCIr4vnnYhYvkSigyOJGeeYXrOUgL0GvuZK
Gg+QYMGcMLOdBwXZfg8Dn+IDsFrHcvTMwtIN+ekZabxX8Bkm2m0YOOmj09fkP9GM
+diKi/CO/lanUy1CsaihEpzlG8pEYhFuyC8ZMLh0A09c2MRo2RRwfs98j+sY2h94
DUhci8Hd83tPjkq4QYHBWhHozYjwt2wc7nep/lHMC3sliXUHvwq5NUh1j9FO9BZr
yRZ04ZEAlQ6oHGv7J9EuUaRTSky20TqbcurbNA3fNjQPDQSGV2+bIcQsD6nohBDZ
T7twiPId7EHq2G7Fl4iJGA63LETnhvhlb1EdWOm3pEol0duy85J1bZ52PXoM+I3d
o2NNp/4KHDY=
=UWgo
-----END PGP SIGNATURE-----

--=-pa31kIrzH+W9QI94Pk0G--
