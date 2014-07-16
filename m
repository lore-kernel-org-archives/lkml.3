Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725AbaGPRxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:53:07 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:47348 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaGPRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:53:03 -0400
Date: Wed, 16 Jul 2014 12:52:59 -0500
From: Greg Donald <gdonald@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: find_busiest_group divide error
Message-ID: <20140716175259.GA5956@gmail.com>
References: <20140714165659.GA9289@gmail.com>
 <20140716152736.GD19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20140716152736.GD19379@twins.programming.kicks-ass.net>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=0x42C14D83&op=vindex
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 05:27:36PM +0200, Peter Zijlstra wrote:
> Could you confirm if reverting caffcdd8d27ba78730d5540396ce72ad022aff2c
> cures things for you?
>=20
> Otherwise there's two very similar issues, see also:
>=20
>    lkml.kernel.org/r/20140716145546.GA6922@wolff.to

Cured.

I reverted caffcdd8d27ba78730d5540396ce72ad022aff2c which did nothing as
far as I can tell, then I removed the
two lines from http://marc.info/?l=3Dlinux-kernel&m=3D140552264825755, then
I added back the one line from
https://bugzilla.kernel.org/show_bug.cgi?id=3D80251#c8.

I ended up with

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dc2927c..7c3674d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5848,7 +5848,6 @@ build_sched_groups(struct sched_domain *sd, int
cpu)
=20
                group =3D get_group(i, sdd, &sg);
                cpumask_clear(sched_group_cpus(sg));
-               sg->sgp->power =3D 0;
                cpumask_setall(sched_group_mask(sg));
=20
                for_each_cpu(j, span) {


Thanks.

--=20
Greg Donald

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTxrv7AAoJEHjl9MlCwU2Dn7QH/Rz84G/xIlQxqucY0fgrB18y
wUmPR8ELg5721kSlCRT7m/adlAF5tHIB/a+iCXY4RliYH99E4NNjy0clnHGroXpD
H+JPqSfBv9VoWe3tsWstsWC19rJRxMz+ShIq3LBDxcEWTFxq3rwG6rs00VWFRilP
a9wLcqyvUP3nJoXsLSZl7PSP6kmVoONodA4eyUGkcPKko4cbvYJQwb6TmXOXFcD+
wUOiZvYsZpaiZxwoK5Nt0k/kAUNlYmEDJUZPNmZDKNumTTk1gDA7iaCAx4vjp0vc
th6UH3z4U5inDKHxj8+1Ws34CDSSCLgWWEtiIA2IwJWeSSO324raLn9XDtt3ItQ=
=oW2W
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
