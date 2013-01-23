Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3AWEVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:21:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3AWEU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:20:59 -0500
Date: Wed, 23 Jan 2013 15:20:44 +1100
From: NeilBrown <neilb@suse.de>
To: device-mapper development <dm-devel@redhat.com>
Cc: mpatocka@redhat.com, Guangliang Zhao <gzhao@suse.com>,
        linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/3 v3] add resync speed control for dm-raid1
Message-ID: <20130123152044.3726fb4e@notabene.brown>
In-Reply-To: <Pine.LNX.4.64.1301222033290.4723@file.rdu.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
	<Pine.LNX.4.64.1301090034200.29917@file.rdu.redhat.com>
	<20130116082109.GA2154@glzhao-laptop.site>
	<Pine.LNX.4.64.1301222033290.4723@file.rdu.redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zVE4vsHjutQTEIU.CG/q.he"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zVE4vsHjutQTEIU.CG/q.he
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Jan 2013 20:44:41 -0500 (EST) Mikulas Patocka
<mpatocka@redhat.com> wrote:

>=20
>=20
> On Wed, 16 Jan 2013, Guangliang Zhao wrote:
>=20
> > On Wed, Jan 09, 2013 at 12:43:21AM -0500, Mikulas Patocka wrote:
> > > Hi
> > Hi,
> >=20
> > I think it is very good that your patches could be used for other
> > targets(snapshot, thin) after reviewing yours, but I find some issues
> > (maybe not, please correct me if I am wrong).
> >=20
> > >=20
> > > I did this already some times ago.
> > > I'm sending my patches in the next mail.
> > >=20
> > > Basically, my and Guangliang's patches have the following differences:
> > >=20
> > > my patch: uses per-module throttle settings
> > > Guangliang's patch: uses per-device settings
> > > (my patch could be changed to use per-device throttle too, but withou=
t=20
> > > userspace support it isn't much useful because userspace lvm can=20
> > > reload the mirror and per-device settings would be lost)
> >=20
> > We couldn't force every devices in the system hold the same throttle,
> > IMHO, per-device settings couldn't be ignored.=20
> > Setting the global value by the parameters of module is a good way, and
> > it could also be used to set the default value in my patches. In this w=
ay,
> > the global setting wouldn't be lost, and we could also adjust every dev=
ice's
> > speed.
>=20
> It could be good to have per-device throttle.
>=20
> > > my patch: uses fine grained throttling of the individual IOs in kcopy=
d -=20
> > > it measures active/inactive ratio and if the disk is active more than=
 the=20
> > > specified percentage of time, sleep is inserted.
> >=20
> > I think this policy might not be able to represent the exact write spee=
d,=20
> > while other modules(such as md, drbd) monitor the real IO speed.
>=20
> But you don't want to limit raid resynchronization to a certain speed. A=
=20
> disk has varying speed, it is faster in the beginning and slower in the=20
> end.
>=20
> So if you want to limit raid resynchronization so that other tasks have=20
> faster access to the disk, you need to limit percentage of time that is=20
> spent on resynchronization, not resynchronization speed.

Sounds good ..... not that easy though.

But if the disk is otherwise idle, I want 100% of the time to be spend on
synchronisation.  If it isn't otherwise idle, I want a much more modest
faction to be used.

Getting this "right" is very hard.  You want to resync aggressively if there
is no other traffic, but to back off quickly to some small background rate =
if
there is any other traffic.  That is what md tries to do.

dm-raid1 has an extra complication.  It is used in clusters (clvm) where
multiple separate hosts might be accessing the device.  So the host which is
driving the resync cannot know what other IO there might be.
In that case the only thing that seems to be practical is an maximum sync
speed that can be set by the admin.

NeilBrown

--Sig_/zVE4vsHjutQTEIU.CG/q.he
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUP9lHDnsnt1WYoG5AQLkZg//XRJXQcolJuyKeqbEzYGb3dBEa0iSLmSA
oLReWEjrLjTANIi7BbnwdkLkPf4z8o4YX/EV3WahBSj2zAGLIIBgGgAuNAX4hLW2
dJL+87QZZkN7JFZcyutF2pn9X/VkPKMoVWHLvMHnKQ34ZsTKDshT7Dwsi3qrhqTe
du9H9DlA4BWt9SvKG53n2WupbyGidcXoXpXdFygH5vBLq42Fbe0XDLMLEoPtb//b
ScYyUIIP71qar6kJgs6s2LjnWFL3lZK0KfcqRrMLB0AepJXri7BfW6WP16C9T2Ut
5RygynE/Ef6tGPciVfSf7X1G8DILEOYKkpppO0Q1ylu66g1y+5ASOPPGDhfoldPw
K0fVO1W5swy6KN75U1LoMN4fwKQT8fIcHCDGdtnzhGmyqAbsIMk5AbVpNM4DJ5uv
3ao9vN0E7TNMiC5SwhBrW4xXDVXaLblhvg//Ym+vtbWwUjIMSCHYjty+GPQ9XWmR
GT26CKlBWcs/ZS52nhHcJYHY2qxaaw9HUiqJHg+RvjjZTqMBw2PtBinvOAJl+sC4
2BAy/9/HxbBvKIJ9Nh0d5PlVZw2GDJHR6UhAuRTDFyLzjnaanH8pl2oJ1AL3XANX
YOrvIOlSfV30s6QXg9NQq53iFsbnuwwAvDoLptuwCavoRCLOSHAhmscLL3uGmIo9
7X3tzdjegSE=
=4qQg
-----END PGP SIGNATURE-----

--Sig_/zVE4vsHjutQTEIU.CG/q.he--
