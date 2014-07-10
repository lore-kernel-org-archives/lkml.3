Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaGJIZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:25:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbaGJIZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:25:26 -0400
Date: Thu, 10 Jul 2014 18:25:19 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] autofs4: support RCU-walk
Message-ID: <20140710182519.79120b90@notabene.brown>
In-Reply-To: <1404978220.2609.25.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<1404978220.2609.25.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6_S0IDb.PbJmwE_p+Hjy7NX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6_S0IDb.PbJmwE_p+Hjy7NX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jul 2014 15:43:40 +0800 Ian Kent <raven@themaw.net> wrote:

> On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> > autofs4 currently doesn't support RCU-walk - it immediately
> > aborts any attempt at RCU-walk to force REF-walk for path name
> > lookup.
> >=20
> > This can cause a significant performance impact on multi-core
> > systems.
> > I have a client with a test case which spends >80% of its time
> > waiting for spinlocks with a "make -j 40" on a 40 core system.
>=20
> Right, sounds worth the effort.
>=20
> >=20
> > This patchset aims to remove most of these spinlocks.  To be fully
> > effective in the particular case it needs a second patch set which
> > makes NFS RCU-walk friendly, but one thing at a time.
> >=20
> > This has only been lightly tested so far so I'm really after feed-back
> > rather than to have the patch set accepted, though the first two
> > patches are trivial and could be taken immediately.
>=20
> I've only scanned the patches so far, I'll need to spend a bit more time
> on them before I can comment.
>=20
> I'm going to be pressed for time for at least several days so I won't be
> able to get to this right away.
>=20
> I expect the submount_test I use to stress path walking and expire to
> mount transitions will likely be a good test to use. I haven't used it
> in my personal environment for quite a while now so I'll need to have a
> look around and see if I can still find a suitable set of scripts.
> Otherwise I'll need to decouple it from the RedHat automated test
> environment.
>=20
> >=20
> > The last two patches are the most interesting so review comments on
> > those are particularly welcome.
>=20
> Again I haven't looked closely at these but don't you mean the last
> three patches or am I just fussing over an obviously straight forward
> patch 3?

Exactly right - that thirds last patch was "obviously straight forward", so
is naturally the one that I have already found a bug in (the patch assumes
that autofs4_check_leaves returns a different dentry, which clearly isn't
true).

I'll repost it, probably on Monday.

>=20
> Thanks for your effort Bruce,
> Ian
>=20

    http://www.youtube.com/watch?v=3D_f_p0CgPeyA

(Usually when people get my name wrong they call me "Ian", so you calling me
Bruce is both slightly ironic and quite refreshing!)

Thanks,
NeilBrown

--Sig_/6_S0IDb.PbJmwE_p+Hjy7NX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU75N7znsnt1WYoG5AQLg/Q//S9cmPIEJSSuHqRW8g6+UkW7SrK4UzFVs
R0MokL1o3JpJTWDGymRZUwHwJM0x2oycGynPIi/EKQiSUtIizkvo5fCrFc1iwwf0
/MNXsXR1wylgOO4iRw1zZR4Zcj51QxMSf6oSOWS7YJdF+rSWIk+aArOlRya/F0qk
wkns5O7J+Y0yRtg6P8fE8eH2y3uRh2m7GVxqYqoL8g0yC9C5N840DkY56oKwO16o
qudU6vBcl2mQZbhvr6gRoRwJcIdM5OVylp738uz8euTzoEmnVEMAH08Awh0kLn6F
RjVE5PAlc7+zQfckMK9I3BJWl3aSvV+W+uNHIiAitopgowFQ0s9VsZWp4GCNceQz
uJpdg6ixH/TXCzHH1za1h7ga99G8W9CfELLOy/FGNXArQSQCoiK9dbSMeal5AB/b
tTySJLGbT8lqTslCj90Vt1eU9PMsj2nWbZLAFWV7gvLK6Ip9IS5GkhPQwCoIpkYc
7pNBuz6LSKCNKSmqwTtebNT5pNbl4ZRQdB1iJYmUWCqZJ9NNR+ENg/EXMnb/k1c3
0zKuUsMMmfekUYY3Z44fCQtmPXhfDG4UUNyeIQK0eJRZ4Gir6oPyB9a3IiMhBDi+
4BlgINOtLrYayCimblePJmZNaosEanH3gO5FYVll69+6wseVi7ur53FiD1PVLSfo
51QgjEHEHJY=
=ErsM
-----END PGP SIGNATURE-----

--Sig_/6_S0IDb.PbJmwE_p+Hjy7NX--
