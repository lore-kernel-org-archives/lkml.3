Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3JVIMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:12:54 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63111 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3JVIMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:12:50 -0400
Date: Tue, 22 Oct 2013 10:10:20 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for Oct 21 (panel-simple.c)
Message-ID: <20131022081019.GA15640@ulmo.nvidia.com>
References: <1382369814-7582-1-git-send-email-treding@nvidia.com>
 <5265B6A2.4090404@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <5265B6A2.4090404@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2013 at 04:20:02PM -0700, Randy Dunlap wrote:
> On 10/21/13 08:36, Thierry Reding wrote:
> > Hi all,
> >=20
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> >=20
> >         git://gitorious.org/thierryreding/linux-next.git
> >=20
> > A next-20131021 tag is also provided for convenience.
> >=20
> > Gained a couple new conflicts, loads of build failures. I've tried to
> > fix the most obvious ones, but as a downside haven't gotten around to
> > write up the specifics about the conflicts. I might still do that
> > tomorrow, but I figured most people wouldn't have time to look into
> > those anyway given that they'll be busy with the conferences.
>=20
> on i386:
>=20
> drivers/built-in.o: In function `panel_simple_probe':
> panel-simple.c:(.text+0x3c7ca): undefined reference to `of_find_backlight=
_by_node'

Hi Randy,

Thanks for running this. I'll come up with a patch to fix this, since I
originally wrote of_find_backlight_by_node().

Running the randconfig that you provided yielded some other interesting
warnings, though. There are a few occurrences where gcc compiles about
functions not returning a value, which is caused by people assuming that
BUG() never returns. But it happens that your randconfig also unsets
CONFIG_BUG, which turns BUG into a no-op and therefore causing gcc to
rightfully complain.

Before attempting to fix these, I was wondering whether that would be
considered useful. I personally think that we should eliminate warnings
as much as possible because it helps filtering out genuine problems. But
the BUG Kconfig option also depends on EXPERT, so I guess it's usually
not even visible and possibly not worth bothering about.

Thierry

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZjLrAAoJEN0jrNd/PrOhxo8P/j5nnW9B1jemQVFH1511Afhh
MJ/w5wEfOyu8XyVKaesQhrLP3qtYqamRTRd5ATCMDTlMBDfgO7O+79ynZyRBUR0x
6RYeS4mx3W2yd04NRKJe628TA/2+PYG+Kd9/8zYeeYwBhhcsDTY/PXuXqhRXBy2r
11lfsYG7pYJH1QDVAwWM0c9Hlj6h7xyYh0+yC4tBYJR00hSRBcyPNNMzDD3so8pT
Q7E6ojOzBbW6mn/Smo53mfViz/dAfL+hndRXflYKi0DKP3WM2SuhvM847QXg2qUv
3Qm1tuPf/7K2M/hIXeCnOe9aeKGKDXoV+q6kSPnBNUXgMXtP+MljLpdpjlBS4hex
LRpg4cP7OGHvEoNJBKz5u2GbouowUeEwb3tkXK3TCGzojYD+AJhJ8UiK2E1vgPX6
3Ys+HtzC7hZJ9hs/rUeNc34gYxXWVg8sqZZjOUlVF9EffAPahP6oYfNRilRyWEhj
kRUOdGLdxhBP2OJtELahBgLfHXTiascyBQG6VzIcCV42gdbo2pPay+14LXGP7lr2
TBc95CaAtMxVBZCR9Yry/dkno1oTmZARWBQt/AWrTH6PYI9/MtwB3C69+WKNqN9M
newpo+Nnl84GmXGGRYclAwKCZCUyJi3K3vdhXuAiWyFm6nqFLCjcmtv4JvdmS53Y
QfG87rZMHaEJ3Uq6szkU
=CzMp
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
