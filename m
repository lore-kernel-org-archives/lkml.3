Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3LDJlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:41:19 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:61642 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3LDJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:41:13 -0500
Date: Wed, 4 Dec 2013 10:40:11 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Scott Wood <scottwood@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] OF: base: match each node compatible against all
 given matches first
Message-ID: <20131204094010.GO19943@ulmo.nvidia.com>
References: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386078720-8756-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <alpine.SOC.1.00.1312032210480.25191@math.ut.ee>
 <529E614B.3070307@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9kDAZ2EyO0AcRYa"
Content-Disposition: inline
In-Reply-To: <529E614B.3070307@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s9kDAZ2EyO0AcRYa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 11:55:07PM +0100, Sebastian Hesselbarth wrote:
> On 12/03/2013 09:14 PM, Meelis Roos wrote:
> >>Currently, of_match_node compares each given match against all node's
> >>compatible strings with of_device_is_compatible.
> >>
> >>To achieve multiple compatible strings per node with ordering from
> >>specific to generic, this requires given matches to be ordered from
> >>specific to generic. For most of the drivers this is not true and also
> >>an alphabetical ordering is more sane there.
> >>
> >>Therefore, this patch modifies of_match_node to match each of the node's
> >>compatible strings against all given matches first, before checking the
> >>next compatible string. This implies that node's compatibles are ordered
> >>from specific to generic while given matches can be in any order.
> >
> >I think I am on the CC: list because of a CPU detection problem report
> >on sparc64 (183912d352a242a276a7877852f107459a13aff9 (of: move
> >of_get_cpu_node implementation to DT core library) caused trouble and
>=20
> The reason you are on Cc is that Thierry added you on last patch
> version. I cannot see how above commit should be related with this
> one, but maybe Thierry can comment on it.
>=20
> >was reverted). So while your V2 patch does not cause any visible harm on
> >the same Sun E3500, my gut feeling is that an additional patch would be
> >needed to actually test it (a patch like
> >183912d352a242a276a7877852f107459a13aff9).
>=20
> This patch deals with matching a node with more than one compatible
> string on a (unordered) list of matches. Although not related to your
> issue, it is good to hear that it causes no harm on DT-mature archs :)
>=20
> I tested it with ARM and l2x0 cache controllers, where the specific
> of_device_id (marvell,tauros3-cache) is sorted after the generic
> one (arm,pl310-cache). The corresponding node's property is
> compatible =3D "marvell,tauros3-cache", "arm,pl310-cache".
>=20
> Without this patch, of_match_node always hits the first match that
> equals _any_ of the above compatible strings. With this patch, it
> hits the matches _in order_ of the compatible strings.
>=20
> >Is this correct or am I missing something?
>=20
> Thierry?

I added Meelis on Cc because he found a regression with my original
proposal (107a84e61cdd "of: match by compatible property first"). That
got later reverted in commit bc51b0c22ceb (Revert "of: match by
compatible property first"). Here's the commit message for reference:

commit bc51b0c22ceb
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jul 10 12:49:32 2012 -0700

    Revert "of: match by compatible property first"

    This reverts commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6.

    Meelis Roos reports a regression since 3.5-rc5 that stops Sun Fire V100
    and Sun Netra X1 sparc64 machines from booting, hanging after enabling
    serial console.  He bisected it to commit 107a84e61cdd.

    Rob Herring explains:
     "The problem is match combinations of compatible plus name and/or type
      fail to match correctly.  I have a fix for this, but given how late it
      is for 3.5 I think it is best to revert this for now.  There could be
      other cases that rely on the current although wrong behavior.  I will
      post an updated version for 3.6."

    Bisected-and-reported-by: Meelis Roos <mroos@linux.ee>
    Requested-by: Rob Herring <rob.herring@calxeda.com>
    Cc: Thierry Reding <thierry.reding@avionic-design.de>
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

So if Meelis still has access to the Sun Fire V100 and Sun Netra X1
machines that regressed last time around, it'd be great to get this
patch tested on them to verify that it indeed fixes the problem and
doesn't regress.

Thierry

--s9kDAZ2EyO0AcRYa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnvh6AAoJEN0jrNd/PrOhu3gP/2tQfYXGQI628ZSYs8/OApe2
x/W2/NsDNuf0BWlMWPtaRitFhInT4n2L1/4SYzGrBffsgqF3ibZcstpW/2glFUgS
VN6u2zeMsjyiNhBG9oTowpTQ13XfEnxeaTuYCDCrO6GllvJHOObrU/Hb4tKNx2Zl
PqdJpBRMFTuBTQDWR+kv4FCSH87mDgP/rAcKuVLrwSH8s7McU9xaHYoUwIZlP/go
eiwFR1uAdu2TVLWP9bm6jHK8z9T2vE0SVAMqw3MRUgCDMUIQnRQvFYwQkGMBxUFo
uoYz+YvKVOnRsypIR4MIIODQfNlh7SKekh1JIh4Jt2jp1D/9ICYnYP5ISA1knEqG
by6ggRy25e11EEIRvLkj+QWCoipR2dDLkKEUBLjSF1R0+j500A+Bkjv3qebY9fFX
iH8Uhd8LOE4/IMbq2N8DcIEuvH6QLec+kseFWaZhfC+vawgWdbNLI7WmOmPJI5gN
9mD+qLJukuYoGEJU4t4KvBj7eUCbgwjhZYYow00U2VNNcFShjDLc+ynuk4Bkpr3v
s8joCqcU1bRUH8HMJaaIMMIV6w+6IIWQvcvWd6zj8opOzdXeW6ywEGisQkRQG/bf
FKrw4LitfxOE9ZevUjyHgfCXNkKbtZ0TOUpXKaoCvv5tDgkTOziRYseCXdqpT5pT
mqTuRF9pdFhWE8XFb2EQ
=KdAV
-----END PGP SIGNATURE-----

--s9kDAZ2EyO0AcRYa--
