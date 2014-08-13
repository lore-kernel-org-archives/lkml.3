Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaHMMk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:40:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33349 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMMk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:40:58 -0400
Date: Wed, 13 Aug 2014 13:40:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        perex@perex.cz
Message-ID: <20140813124046.GS17528@sirena.org.uk>
References: <1407926840-8576-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
 <20140813110844.GF15833@opensource.wolfsonmicro.com>
 <20140813113841.GP17528@sirena.org.uk>
 <20140813121637.GH15833@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yzaxKxdLwpve41j"
Content-Disposition: inline
In-Reply-To: <20140813121637.GH15833@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm_hubs: Fix DC Servo readback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3yzaxKxdLwpve41j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 01:16:37PM +0100, Charles Keepax wrote:
> On Wed, Aug 13, 2014 at 12:38:41PM +0100, Mark Brown wrote:
> > On Wed, Aug 13, 2014 at 12:08:44PM +0100, Charles Keepax wrote:

> > > Also I think the situation is more complex for example on version
> > > 4.4 of the datasheet for wm8994 the WR_VAL fields appear to be in
> > > register 59h. Which is not consistent with this.

> > There was a change in the DC servo between revisions of the WM8994 (at
> > revision E from the look of the code).  This isn't documented in the
> > datasheets as they only document current silicon.

> Indeed, but this patch sets all revs of wm8994 to use register 57h.
> The lastest version of the datasheet has this register at 59h
> although some of the older versions of the datasheet (which likely
> match some older revs of the chip although no way to tell which one
> just from the datasheet) have it at 57h.

Yes, I'm agreeing with you - I'm pointing out what Nikesh has missed
(you can see this from the changelogs as well).  The patch will break
anything using older devices.

> I think basically we need to get some clarity from hardware here
> on which revs use which address and update this patch to match,
> but either way it looks likely that this patch doesn't address
> the whole picture.

This code got rather a lot of attention...

--3yzaxKxdLwpve41j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT61zLAAoJELSic+t+oim9dooP/iyksCT1x63bCtvyU3mhbMSr
/B4Y4rCB/HmIc1Fkb/B4phoXOuG8EJ1LkUXQUMFznv/Iar2Lev+QB2RrpjLfw5Id
GItzLPna6pQ+OUwr0zv6lXWlg7I+SBhiXnqraggQi18J5XKC+Epf9zEOeQ+THQAD
b+/XB48n6RQ3TTEhBJZSROoi3qXHqvxihQZrGDLhuMc8WlvmbHjRclIHwPahoaQ9
QlxDwGvSfx6iv8RTgRVynmHkfG5zsheKXgumu+hQnpKC0aL39/KH15Wjaf/UogDY
sFQUwM8mOkHm9FsgyOrBkz37x8kzkLg/VFSvjYZv6evF07EDQbAMxG4+A5iC3jIb
DNEM0zRnXu1yWDARV+Dd9lZCNjTQIeW4GSQIbDl31Xk/ORNB+QG9KqEJcee9LYnh
MTtG7jAro/exG22a8q6O09kLNQsfhjVz77qlcx+aeDwOYjjoxJfZeLiiyGJ9wo9v
uFJNK0J4LPoE2KBu0mFLAylH3I7VAI531iwARXEr+uZZnN0cEM9wIoMgz9F5PNn/
fN1LWHYFdB0rqQBkufXAnUsdCTXQ0S6igGhIbe1JKh9EeaWM4Z3MXIcGpvK4xb3L
mwipEb2jYFQwB2Gd7epzzOS61njZoEuoxYXi/49y3zxVJ3x+haAd/6gtS+lWnVow
EYUBNw+Q+I1aY8B6ZsFc
=ZVWI
-----END PGP SIGNATURE-----

--3yzaxKxdLwpve41j--
