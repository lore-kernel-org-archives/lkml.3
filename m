Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3GPHPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:15:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab3GPHPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:15:37 -0400
Date: Tue, 16 Jul 2013 17:15:27 +1000
From: NeilBrown <neilb@suse.de>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: Re: 3.10: discard/trim support on md-raid1?
Message-ID: <20130716171527.7c6cb722@notabene.brown>
In-Reply-To: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
References: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/josIMGk77MvVE7fa4G=43Ib"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/josIMGk77MvVE7fa4G=43Ib
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jul 2013 06:34:19 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
wrote:

> Hello,
>=20
> Running 3.10 and I see the following for an md-raid1 of two SSDs:
>=20
> Checking /sys/block/md1/queue:
> add_random: 0
> discard_granularity: 512
> discard_max_bytes: 2147450880
> discard_zeroes_data: 0
> hw_sector_size: 512
> iostats: 0
> logical_block_size: 512
> max_hw_sectors_kb: 32767
> max_integrity_segments: 0
> max_sectors_kb: 512
> max_segment_size: 65536
> max_segments: 168
> minimum_io_size: 512
> nomerges: 0
> nr_requests: 128
> optimal_io_size: 0
> physical_block_size: 512
> read_ahead_kb: 8192
> rotational: 1
> rq_affinity: 0
> scheduler: none
> write_same_max_bytes: 0
>=20
> What should be seen:
> rotational: 0

What has "rotational" got to do with "supports discard"?
There may be some correlation, but it isn't causal.

> And possibly:
> discard_zeroes_data: 1

This should be set as the 'or' of the same value from component devices.  A=
nd
does not enable or disable the use of discard.

I don't think that "does this device support discard" appears in sysfs.

I believe trim does work on md/raid1 if the underlying devices all support =
it.

NeilBrown



>=20
> Can anyone confirm if there is a workaround to allow TRIM when using
> md-raid1?
>=20
> Some related discussion here:
> http://us.generation-nt.com/answer/md-rotational-attribute-help-206571222=
.ht
> ml
> http://www.progtown.com/topic343938-ssd-strange-itself-conducts.html
>=20
>=20
> Justin.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/josIMGk77MvVE7fa4G=43Ib
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeTzDznsnt1WYoG5AQLYORAAxI0uViK8CnJkfi6wCZreFZQk6wqgt3iQ
+uwiJRavtXFYnbgCl41CUp/PRSyR5pPnyQNUY6sgZQS7GSzGLUqqzOdnOW/um3c6
HSd6f8lCgOufvPXFnkJ0tkFQJihXol29u2lqElsNeKt807FV51v1jVA+0zyyeu51
f12HZZnl1i+Pvf9MJlvDh7VSNeLvG4qyDqfZcDJwb0fL6D/Hx7je1WX+RKrOJO3K
iuwaNRH8Al1bB2caRYn3MYMCzQNsjktKUFESbPO/TVbYXCg99q/bjkrKxaQiZcCY
OcfqMpvHu3S2X3Whha1NLnKq/sCctRWgUYqTm6tmp+TizGbMy8nwDSIp2zxV6ywx
/jKxzbYLkzItuhI+UVQHAhgBmHh+WuzgBHYkCSaW4c6QcRJoPDlaye38tfYxVpF5
dxc/Khx1PgYOr4Wd6EJ4bVOQb4Sj2gsP6cpqd60Rn01vUbNd4PqlgfVBkKHtsbB9
60Afah6QFuvbbrI7yXGqm9ka9qbBt27fD4MANX+LQWry3YUEWvANQaIpZGy2RDzP
FHkvHylcDFZDBJjSW/LKHR2KM9cC9VVl45mJMtoAscOf3WP0MCloKtHo9XomxJdn
RHq7Gy5h7A9dqiMERs7cvicfml7lM7vq+uGovT/o6Ej+Bvjp0xsexOEgqYk5KPa7
oDZ0tSjTZtw=
=7A/Y
-----END PGP SIGNATURE-----

--Sig_/josIMGk77MvVE7fa4G=43Ib--
