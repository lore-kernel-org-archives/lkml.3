Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3AMGDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 01:03:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab3AMGDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 01:03:23 -0500
Message-ID: <1358056981.4514.73.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 13 Jan 2013 06:03:01 +0000
In-Reply-To: <20130107192057.GA17401@redhat.com>
References: <20121228190352.097882544@decadent.org.uk>
	 <50DEA41E.6010409@01019freenet.de>
	 <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>
	 <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk>
	 <20130107080532.GA2984@redhat.com> <20130107081003.GB2984@redhat.com>
	 <1357568256.26822.18.camel@deadeye.wl.decadent.org.uk>
	 <50EAE3E1.4010809@01019freenet.de> <20130107165458.GA16705@redhat.com>
	 <50EB162B.7020903@01019freenet.de> <20130107192057.GA17401@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-h1JaPFxdgiiTWBFwUX+L"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h1JaPFxdgiiTWBFwUX+L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-07 at 20:20 +0100, Stanislaw Gruszka wrote:
> On Mon, Jan 07, 2013 at 07:38:35PM +0100, Andreas Hartmann wrote:
> > Stanislaw Gruszka wrote:
> > > On Mon, Jan 07, 2013 at 04:04:01PM +0100, Andreas Hartmann wrote:
> > >> Ben Hutchings wrote:
> > >>> On Mon, 2013-01-07 at 09:10 +0100, Stanislaw Gruszka wrote:
> > >>>> On Mon, Jan 07, 2013 at 09:05:32AM +0100, Stanislaw Gruszka wrote:
> > >>>>>> To be clear, I have all of these in the queue:
> > >>>>>>
> > >>>>>> be03d4a45c09 rt2x00: Don't let mac80211 send a BAR when an AMPDU=
 subframe fails
> > >>>>>> 5b632fe85ec8 mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_B=
AR_FAIL
> > >>>>>> ab9d6e4ffe19 Revert: "rt2x00: Don't let mac80211 send a BAR when=
 an AMPDU subframe fails"
> > >>>>>>
> > >>>>>> and I'm intending to drop/defer them all.
> > >>>>>
> > >>>>> Patch 3 is a revert of patch 1 (questioned patch). Please apply a=
ll 3 patches,
> > >>>>> or only patch 2.
> > >>>>
> > >>>> No, actually all 3 patches have to be applied. Because last one, e=
xcept
> > >>>> revert, include flag IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL settin=
g in rt2x00
> > >>>> driver, which make patch 2 work.
> > >>>
> > >>> Andreas said that that after ab9d6e4ffe19 there was still a regress=
ion.
> > >=20
> > > That's not true. There will be no regression after ab9d6e4ffe20. The
> > > only thing is that solution is not perfect. But perfect solution requ=
ire
> > > lot of changes i.e. is not -stable appropriate (and does not exist cu=
rrently).
> > >=20
> > >>> But maybe he was confused.  I know I'm confused.
> > >> :-))
> > >>
> > >> No, the thing is:
> > >> rt2800pci misses an appropriate handling of aggregation (which meets=
 the
> > >> requirements of mac80211).
> > >>
> > >> Both workarounds, mine and the new workaround from Stanislaw (which =
is
> > >> nothing more than a restricted version of my initial workaround), wo=
rk
> > >=20
> > > Your workaround broke STA mode on some environment.
> >=20
> > Why are you sure, that this workaround doesn't break some other devices
> > running in AP mode? We believed at that time too, it wouldn't harm even
> > STA. But this was wrong for some (which?) devices.
>=20
> Because it make behaviour the same as it was before 3.2, which introduce
> those issues.

After reviewing the various changes, I agree that applying the three
patches looks like it will restore the old (3.1) behaviour of rt2x00.  I
have reinstated them in the queue for the next 3.2 update.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-h1JaPFxdgiiTWBFwUX+L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPJOFee/yOyVhhEJAQrOGg//VuyMPCbzQ0U3htJyVlx9yZSQrGKXrdx9
qc924w+Ixhxm9gR1tG5SOQNx2H/ZQFwZBbwSqBUou1S9Xfc9d3ec0UnNycKHUOAL
kC63UkNr10Zj/4MZeAvO1vdaSV1RO5FhA1DWEHAgXdA/5k1i2mBspQuii8+re7Pt
qp4tTXGSkh8xftz1AonvxwTzXPSZMXJH8DTX+tYPkvW2hwAJdvbB48TRxITGUe9Y
0woaHFGzbyqsnwO/+R6ClDgd7ap4p/JUSRoX0vptZQhX+y8IVbqPzHD3LnUaAEDJ
0DkY0JJj1kJSHc42ZXRfuJJeShzyhCmXZ71jghQtZiW2lWtOQ6aYuRmEGsIrl+D4
AbTc3xyoAaNLLhpLwdDm1LjY2D50xha/7tLrdYOQDcrandr0HG6s4K39I7uxkbdb
q5ovNi8yKfWGayevJfxf7k1NJWeItrVOcuU4hjIEIN68SPs8mx6aCgs2tAzJ9KeL
9BqnioxEx0Aq5tRNwjc4TJt4LzLt+Fava5lCbEj9DkzpWFZt/e6JgjQhKGfd8a5Q
fXDU+7wWNqeBZgWqa4Zjbazro6W6sVvsGhSq129nofhPFuKPBewtOlY1Tnx8b6mk
YMkf3MQorhnhSlP+xKGCFluVbyicJJF0gv98s4KhDw6ulI+E52vbJN0ArLXlAHyq
r4+EeLjjCdY=
=q2V6
-----END PGP SIGNATURE-----

--=-h1JaPFxdgiiTWBFwUX+L--
