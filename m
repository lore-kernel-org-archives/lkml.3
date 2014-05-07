Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbaEGMzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:55:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbaEGMzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:55:53 -0400
Date: Wed, 7 May 2014 14:55:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/clock: cleanup, remove wrap_{max|min}().
Message-ID: <20140507125548.GL30445@twins.programming.kicks-ass.net>
References: <1399463338-15507-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Content-Disposition: inline
In-Reply-To: <1399463338-15507-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 08:48:58PM +0900, Dongsheng Yang wrote:
> I am not sure why we need the wrap_{max|min}() in kernel/sched/clock.c.
> But I checked the implementation of max() and min() in linux/kernel.h, I think
> we can reuse them here rather than introduce a new function named
> wrap_{max|min}().

wrap is a good hint there.. they're supposed to deal with the clock
wrapping. Of course 2^64 ns is a rather long time (~584 years in fact),
but that doesn't mean we shouldn't care.

And no, min/max don't do the right thing.

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTai1UAAoJEHZH4aRLwOS63I0P+wRmIeVGoHtTtO/i3I1vxq7I
No5WMj1cmEzg33Es5Yi475aqxG8dey4NTfWNdeJ6bPRHltB5MCa+LFdF32gNQO09
PqrL/0e4yj9qM8Jb/qxOJu3dmnRxEdAmQhiVKf5ogPZfooLojDzQsLQvYdEuuank
PlY7K/QedA68SQ8rucwJGESh63q5M+PxofwEg+i0OeSA6L2iWwK0ptAEputCKvs3
6Nqc+wB8EA20v3u9m1TaBOFqCH/GqUWnhvEoKHHps7jsYlsR+CN1x7jL/BuOdf7W
KDBFVPE2hJsgb6InhE7EkwUqIpNze5dJyT9pY7VcGQJSWoXgIdOGb2ES2t9sJX3i
Ey5QEj6NJEs5uuFP7de6Nxv7OLf6/+AQGI5a6eF/h3WpusXaaH4OTYxJ+w4ql+ek
SswG0pICn4I8Dy6oUeJpQucWQOa0EPcvKouszPB6dztZdtAyBy5nqF89O7OJTMRD
iZVE3hXNfqio8T//FDcYbR2Hyg7HxpiiwNVdcLuChCTjzGmViAlr6Qgu4PIWuRJG
w/TMaGBFnWtoFxeLizX+gXJxsgcCXkyGgg0oGNFB7+5+dRA1cVng1jZsnaj/HG2V
l+9wyWl1J95BEWCTN29ELQB4cuUmDtDehU2MATb9JT4nRuqr491YnMcpaakvO7oi
1MoZkjzOQ25jLgqbWmmz
=TsNX
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
