Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbaFSLvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:51:46 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52848 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaFSLvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:51:42 -0400
Date: Thu, 19 Jun 2014 13:48:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com, ccross@google.com,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
Message-ID: <20140619114825.GB28111@ulmo>
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103711.15728.97842.stgit@patser>
 <20140619011556.GE10921@kroah.com>
 <20140619063727.GL5821@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <20140619063727.GL5821@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2014 at 08:37:27AM +0200, Daniel Vetter wrote:
> On Wed, Jun 18, 2014 at 06:15:56PM -0700, Greg KH wrote:
> > On Wed, Jun 18, 2014 at 12:37:11PM +0200, Maarten Lankhorst wrote:
> > > Just to show it's easy.
> > >=20
> > > Android syncpoints can be mapped to a timeline. This removes the need
> > > to maintain a separate api for synchronization. I've left the android
> > > trace events in place, but the core fence events should already be
> > > sufficient for debugging.
> > >=20
> > > v2:
> > > - Call fence_remove_callback in sync_fence_free if not all fences hav=
e fired.
> > > v3:
> > > - Merge Colin Cross' bugfixes, and the android fence merge optimizati=
on.
> > > v4:
> > > - Merge with the upstream fixes.
> > > v5:
> > > - Fix small style issues pointed out by Thomas Hellstrom.
> > >=20
> > > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> > > Acked-by: John Stultz <john.stultz@linaro.org>
> > > ---
> > >  drivers/staging/android/Kconfig      |    1=20
> > >  drivers/staging/android/Makefile     |    2=20
> > >  drivers/staging/android/sw_sync.c    |    6=20
> > >  drivers/staging/android/sync.c       |  913 +++++++++++-------------=
----------
> > >  drivers/staging/android/sync.h       |   79 ++-
> > >  drivers/staging/android/sync_debug.c |  247 +++++++++
> > >  drivers/staging/android/trace/sync.h |   12=20
> > >  7 files changed, 609 insertions(+), 651 deletions(-)
> > >  create mode 100644 drivers/staging/android/sync_debug.c
> >=20
> > With these changes, can we pull the android sync logic out of
> > drivers/staging/ now?
>=20
> Afaik the google guys never really looked at this and acked it. So I'm not
> sure whether they'll follow along. The other issue I have as the
> maintainer of gfx driver is that I don't want to implement support for two
> different sync object primitives (once for dma-buf and once for android
> syncpts), and my impression thus far has been that even with this we're
> not there.
>=20
> I'm trying to get our own android guys to upstream their i915 syncpts
> support, but thus far I haven't managed to convince them to throw people's
> time at this.

This has been discussed a fair bit internally recently and some of our
GPU experts have raised concerns that this may result in seriously
degraded performance in our proprietary graphics stack. Now I don't care
very much for the proprietary graphics stack, but by extension I would
assume that the same restrictions are relevant for any open-source
driver as well.

I'm still trying to fully understand all the implications and at the
same time get some of the people who raised concerns to join in this
discussion. As I understand it the concern is mostly about explicit vs.
implicit synchronization and having this mechanism in the kernel will
implicitly synchronize all accesses to these buffers even in cases where
it's not needed (read vs. write locks, etc.). In one particular instance
it was even mentioned that this kind of implicit synchronization can
lead to deadlocks in some use-cases (this was mentioned for Android
compositing, but I suspect that the same may happen for Wayland or X
compositors).

Thierry

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTos4JAAoJEN0jrNd/PrOh+H0P/jtiabvudLyPpDql5VmWtVG+
Sbzos2XB2Q4JHWVrC42Exeettc9k2CfgV9MhOYTyqyFMmRlO9ReomvpmUAZ1UiZT
ppcO4xHkuEAOfpnkLCMvOFjDh2RiD2NNFANiPbRXMdDwzlD7RRGa7z6r3gbmuuGX
aoaz0tdko1MaOCLqHaHVRHxb4lLM4edCw4KzgDQBbbdTFL4ikEuN0g9K6N3zMyUm
OOoiivg0R8t+c+jaDVK9xM9DDnirX1yQB/M4e7rTk1GY4Y5MmtU+o9BqO4QVrsql
Qe+UpS/OYEzxU8EacFYius15cyEl6u1ExLDcFjoN//4yXNVx3pTzXf6+ZdT/3P5T
GK+/fWBto5bWh7/Jme04cM4e4MFHDED9F2zwMO74O7dsbXf/qSgpZr+yY7ADza4B
JOI2z1NNd9bzwWeA2FV3lsEv+DHQM5fCrAFsDyhHu7vcB09RJ+ycc253C/kURlyT
FNoN4vZxwtD0PwQeqo+e8lfYkZFOqxQwmNW3QzbstSUswFCBE2mRFGawKAHCGto5
sP7sqenyYPD4CQXFN1XVYGKVhAiwAyiQKoZaS6LX9v5+6yVGBsgOiph7Bce8O1hb
sL6JQ6VqpMqYI6Ff+AA7KkRWNpjOiIBR5Hu5qrc0dE/K1Zt3O6YoeDS907tjsz2H
sUx2YWeML5JghjpGZApT
=P7uv
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
