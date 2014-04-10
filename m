Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161090AbaDJR5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:57:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935688AbaDJR5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:57:49 -0400
Date: Thu, 10 Apr 2014 19:57:48 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, cocci@systeme.lip6.fr,
        backports@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: add pycocci wrapper for multithreaded
	support
Message-ID: <20140410175748.GK14815@wotan.suse.de>
References: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com> <1397152289.4757.28.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n83H03bbH672hrlY"
Content-Disposition: inline
In-Reply-To: <1397152289.4757.28.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n83H03bbH672hrlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 07:51:29PM +0200, Johannes Berg wrote:
> On Thu, 2014-04-10 at 10:48 -0700, Luis R. Rodriguez wrote:
>=20
> > You just pass it a cocci file, a target dir, and in git environments
> > you always want --in-place enabled. Experiments and profiling random
> > cocci files with the Linux kernel show that using just using number of
> > CPUs doesn't scale well given that lots of buckets of files don't requi=
re
> > work, as such this uses 10 * number of CPUs for its number of threads.
> > For work that define more general ruler 3 * number of CPUs works better,
> > but for smaller cocci files 3 * number of CPUs performs best right now.
> > To experiment more with what's going on with the multithreading one can=
 enable
> > htop while kicking off a cocci task on the kernel, we want to keep
> > these CPUs busy as much as possible.=20
>=20
> That's not really a good benchmark, you want to actually check how
> quickly it finishes ... If you have some IO issues then just keeping the
> CPUs busy trying to do IO won't help at all.

I checked the profile results, the reason the jobs finish is some threads
had no work or little work. Hence why I increased the number of threads,
depending on the context (long or short cocci expected, in backports
at least, the long being all cocci files in one, the short being --test-coc=
ci
flag to gentree.py). This wrapper uses the short assumption with 10 * num_c=
pus

> > Since its just a helper I toss it into the python directory but don't
> > install it. Hope is that we can evolve it there instead of carrying this
> > helper within backports.
>=20
> If there's a plan to make coccinelle itself multi-threaded, what's the
> point?

To be clear, Coccinelle *has* a form of multithreaded support but requires =
manual
spawning of jobs with references to the max count and also the number thread
that this new process you are spawning belongs to. There's plans to consider
reworking things to handle all this internally but as I discussed with Julia
the changes required would require some structural changes, and as such we
need to live with this for a bit longer. I need to use Coccinelle daily now,
so figured I'd punt this out there in case others might make use of it.

  Luis

--n83H03bbH672hrlY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTRtucAAoJEPep4JnvMe6zKwwQAJzp/5EPovOEEUXLkUyECIri
6Q0ON8bFRdjT+Jd8bqvIYY0Z8vaahZ5Heb8YpLJJSQzofkD4r3JV839Qk++HlxWz
XmdtHXlRf2VVUMbZxdMRdUL6movFFPPviyI3xVs0Neg21pMd2jIM9djTkfwcjryP
miJZBrSKv2/1MZM6KbaXcQ475gh9k0eOKbzlJ3AF0R7eeIMyCx62b1nAb1xJa4n6
vhOGdPFUViHGcaDSI3sJgoElx42bqh8iXXAnWySk78iPAUocqxaZwq69Buh6Lqyr
CdB9uGXjlLdgU4X4Gn1Zxada2zppDmL6zPa7fgSqT84ExNdTS6QfnFU1hEsPPIE6
ZOP75g4YnAefdpUKlHkjEyvvFD/0jbBf21QDDEusnhJnVSluk2z5XF6Jx6IOuQMj
mYkfr12mYEUh5kBZCWnAVH5iuq2PQOBkXUrLyMh3UJ9qUrMPiUQboBAJCF04CE2B
sQjgXO+j4TbNE1Lz7pNMN/qippCV1OJjxndL18DAYoWKNbbc/6gjf8zhLqpxpQy+
p8gvh6kwBuW7oJgH1G+/KtyIXvHm+MpVejwbmOQRm/iEVlLUzAMF2YeKKdNF34+V
M4EvU/f18BmJ7oX+7fQzrZK9SzrobX0sB61mN7dOJjOMVjW+CMOKIsFK67/oC9CZ
4JvicP/Ny24oNKrTmUyV
=I8jn
-----END PGP SIGNATURE-----

--n83H03bbH672hrlY--
