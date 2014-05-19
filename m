Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaESKkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:40:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:55605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaESKkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:40:17 -0400
Date: Mon, 19 May 2014 12:40:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
Message-ID: <20140519104011.GY30445@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRcNICV7MHA2HUNl"
Content-Disposition: inline
In-Reply-To: <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRcNICV7MHA2HUNl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 10:43:14AM -0700, bsegall@google.com wrote:
> I just did notice however that sched_cfs_period_timer reads
> cfs_b->period without any locks, which can in fact race with an update
> to period (and isn't fixed by this patch). If this write doesn't happen
> to be atomic (which is certainly not guaranteed, and is entirely
> plausible on say 32-bit x86, much less other archs), we could read a
> partially written value and move the timer incorrectly. Pulling the
> lock/unlock out of do_sched_cfs_period_timer should fix this easily
> enough.
>=20
> unthrottle_offline_cfs_rqs could cause similar issues with its unlocked
> read of quota, and can also be easily fixed.

Ben, will you send patches for this?

--QRcNICV7MHA2HUNl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTed+LAAoJEHZH4aRLwOS6syAP/AzUH13bNGCvA2cS3BCUdgVH
+7OjuG9f+Q+z9bNOXJMN+BfoXVAK0P6X8nNSWwBOd6gIqP+Dg/TNfW/Ynji50Iug
BA3f5Wu9fNYNk+KywQvhWkHESgAulWSe85g6JrxFrxnqMnIBV90P0i/6/JJQgCiv
+GLHb5s3QpWtGR/C5M5wPsewr3MkEHDNyNObA0UuIyypgGCxWSCbJ3NRi0eRuXeE
zFe905Yl1ibovdC73Q/jQ6Qov75aoQxsPOV/w7+CXzKyfbBFJY3f7a1Z18QYLCAA
vU0h0cnG+9RSNivcL0H3fgzdmFYzM7X9RmspHC2CS3ph8Cbir70AHbkYL+MEHka8
A3v7fKOIEl5twx5L2ff0ZDGitpb9TWAlkNsXCdU8ivmun4wZH/zXfWHCKSTL5J8h
IWaTj937J2tYOVTaVtJ1p6QxYyD+jxyk87yZftaYb+Al6uSVvmpDIG8zfzddluKL
A6czGoWllkXHPbGkW60nLxg7uvZFCn6fTq0ib2wR4fkGkixOLEK+rIR+lq5f5kAp
PuPGQDn3Yjvvfz6xJw3E4EQCq/UAhU/PAnf226ZleYrlTtMnt9GprvgJHg8MAFOl
BkFUtXI6jSYk53hDXEvC9nB1ezK/lAJiw2L9VosiDFZx4HAZ6HsizikGo3Qvy6Y4
wymJoDkS8aLObycCpuNB
=Vyx7
-----END PGP SIGNATURE-----

--QRcNICV7MHA2HUNl--
