Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbaLWQYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:24:16 -0500
Received: from sauhun.de ([89.238.76.85]:54427 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaLWQYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:24:14 -0500
Date: Tue, 23 Dec 2014 17:23:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Walter Lozano <walter@vanguardiasur.com.ar>,
        mika.westerberg@linux.intel.com, Romain.Baeriswyl@abilis.com,
        atull@opensource.altera.com, raymond.tan@intel.com,
        carlpeng008@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] i2c: designware: Avoid initcall and initialize the driver
 like a regular one
Message-ID: <20141223162357.GA4467@katana>
References: <1419272149-28716-1-git-send-email-walter@vanguardiasur.com.ar>
 <20141222190233.GA1014@katana>
 <549982BE.3080500@vanguardiasur.com.ar>
 <20141223152621.GA3692@katana>
 <54998B1A.9020208@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <54998B1A.9020208@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >> This means there won't be any early users of the I2C platform driver i=
n this
> >> scenario.
> >=20
> > There won't be with platform as well.
>=20
> Oh, OK. Then maybe you can clarify why all those i2c busses need to be
> registered with initcall in the first place?

Because they want to access PMICs early to have voltages ready when
other drivers are probed. This, again, is DT/platform independent.
All this is cruft from the pre-deferred-probe era. And pretty annoying
to deprecated although I'd love to do that.


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmZcdAAoJEBQN5MwUoCm2mSsQAJFeJsOsjQ92KcWrD3lKsdQq
n8WfIN1qhmXsmZUKmmdlrnfvwrxcI9SLtPCoSkJXvEKFFqtuLoa936hAgNdmw21P
Nq2jkFiot7saUvJ1LYRkcou/O9sa/lKeRRy0Asapq3kpTyeEmOfTsxWMi7GtMaRD
4lU/8mReMXE0WAllk/cYna64uKyAoRaEvskEwN43VF52ljqFIw5Llle1Pfy+OgXR
6PQ/nh4Mo2PSsnMAT8vShkETPXDlRjnzCPk7qN0DZ4dyEctPwVny1qQrv2WFYgok
VJdEmBXqbl1I78Tv5r+RJ1eOyHjb56gfgMusO6QtPUi3n7esfmYXRQBx7ITmSi/B
fprfEQMurj05crA9o7zys7WhYPjEM+s6FQmTO/NBSZuljPbPwQD59qRN72Ts2cZl
on9czLOJ5CwnKIn2wMk2rKoS8uuTT8rHdqJ07hntHCMH3bnAhKe1G78PAvcnMcT5
zjRIiMyu029WCZGzjodXcU/VObsjrIMxoqn+LAsMblJE8YaHQfOjSt4WsyPcONzP
dDQs0p49xygI1M0B8DueQLCpzzD8StTavDjMTSQhYnEP7+0zXUlZkdSC/cLwA6ME
fQGlf75BtbQXPQd5zfvDr5UQb9FxSLlqhmxKG5abm3KilDE94F3UOGeWoE3xEZ9s
0GDeG22x8/Szxi8lVWO1
=j7Wv
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
