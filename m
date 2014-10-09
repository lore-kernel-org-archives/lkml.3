Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaJIUf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:35:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59603 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaJIUfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:35:54 -0400
Date: Thu, 9 Oct 2014 15:35:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141009203505.GD25729@saruman>
Reply-To: <balbi@ti.com>
References: <20140904184021.GA13421@saruman.home>
 <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
 <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org>
 <20141009162656.GE16002@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <20141009162656.GE16002@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 09, 2014 at 11:26:56AM -0500, Felipe Balbi wrote:
> > I'm thinking it's not the slot pointer itself that's bad, because
> > __radix_tree_lookup() dereferences that to test if it's populated
> > before returning it, and slot life-time is guaranteed by RCU.
> >=20
> > That would only leave garbage in the slot itself, crashing during
> > page_cache_get_speculative().
> >=20
> > I'll keep staring at this change, but nothing stands out to me yet.
>=20
> alright, it's pretty deterministic however. Always on the same test, no
> matter which USB controller, no matter if backing store is RAM or MMC.
>=20
> Those two undefined instructions on the disassembly caught my attention,
> perhaps I'm facing a GCC bug ?

no, probably not a GCC bug. Looking at your commit, however. Man, it
does quite many things at once. Moves code around, adds new functions by
refactoring (and changing) code, renames things, changes int offset into
unsigned ints. Should not be too difficult too to miss a bug in there.

I'll continue digging here.

--=20
balbi

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNvF5AAoJEIaOsuA1yqREvJIP+wQJ3fR8DoSTWlOFZH1MCSeP
pdwbMse8Z8VBC5zRXxF8HMIRGc7ve95qTnDs0TQdhvIR2/EMDXxhDQ8DLnT04JuO
/azKTutBsdK8Axe/czbTMNUspplcVpyWgFuPU9f3rgre5QhTJXryNUz1H3+tnAc2
cwA/8j6wqbVxVIpwZW/Kdozg8QI+T4TO1VGHnsWwYNhjIGnOM5QgMPHDIQJdJc37
SkMifnZTrtwBRGc1xhLPCNuQ/FoHh3Cu4LXKM90sOWMjRcTNr1dK/hnwM7fEVZJF
ByemvzJVxA8EOcoOOUuFoa5J3ow28XNg+kRTIps0PauVyPBL/Xza5JaURMMb97/F
VFd7INn467ZnBsZxnUDt0qjx/0GYwujTrlJbbp0QPKfjhO7dGgGqa3VJXTXV5eRQ
njeUqdcEAgiuPU6CqwboLAgSjODUTE3v3jUdc2EBsq1Hazop7+1cvxCseuKLlc68
r6GiLCn2mvYFIHz1125v/5pGxA6OfkRjaS8A1/U4tA1Wzf0dp/MKi749YfWQ13bD
SfyWycfBI4gbnZb2ZQqGw4htjnzg31ObQCZLTMjn0j0jzftL7TFWily+9Y3L4WQ7
6RetlWcIoxH0iiLqsk3RwtrtaztC2fSu7J7pH3KgbttUzJ7GBIfTXf774MgwIZhd
16HADnJ9B5NEtw608Lgd
=CsDM
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
