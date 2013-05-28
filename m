Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab3E1Kjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:39:33 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:43937 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab3E1Kjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:39:31 -0400
Date: Tue, 28 May 2013 12:39:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: "airlied@linux.ie" <airlied@linux.ie>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>, xorg-devel@lists.x.org
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
Message-ID: <20130528103927.GB11547@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
 <1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
 <20130526101243.GB1652@mithrandir>
 <51A30372.6080907@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <51A30372.6080907@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2013 at 09:55:46AM +0300, Arto Merilainen wrote:
> On 05/26/2013 01:12 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Fri, May 17, 2013 at 02:49:44PM +0300, Arto Merilainen wrote:
[...]
> >Thinking about it, maybe it would be good to have two separate error
> >codes. Keeping -EAGAIN for the case where a zero timeout was passed
> >doesn't sound too bad to differentiate it from the case where a non-
> >zero timeout was passed and it actually timed out. What do you think?
>=20
> I agree, in this case it would not look bad at all. However, user
> space libraries may loop until the ioctl return code is something
> else than -EAGAIN or -EINTR. Especially function drmIoctl() in
> libdrm does this which is why I noted this isssue in the first
> place.
>=20
> If user space uses zero timeout to just check if a syncpoint value
> has already passed the library continues looping until the syncpoint
> value actually passes. Of course, we could just modify the ioctl
> interface to "cast" this return code to something else but that does
> not seem correct.

That doesn't sound right. Maybe drmIoctl() needs fixing instead. Looking
at the history, drmIoctl() was introduced to automatically loop if a
signal was received (commit 8b9ab108ec1f2ba2b503f713769c4946849b3cb2).
However the ioctl(3p) manpage doesn't mention that ioctl() returns
EAGAIN in case it is interrupted by a signal.

I'm adding Keith as author of that commit and the xorg-devel mailing
list on Cc to get some more eyes on this.

Thierry

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpIlfAAoJEN0jrNd/PrOhQtEP/3+n8ImyaRLnpyeTcvi+cKPA
pfYqJU2x1riJJy6BRKlMWJrmTBt/9mLXDB2OKSLuCo/VxFNliN/YAkX9WjsLNH3P
fT8ZY8YbktJ6dGGE3kT8kO21zIQdY7L7OBlJxREni48OQvC91L4NCMo8ssbIhFsE
2myUDC5fnB/rE+LYH+UJLsTQW19CGAOQFZUirQeXuYtHH3R+fmo5kX8HN7EulHaN
leC6COlUf3jvzQcRIdNQugrP6xUt4lfuOHLG7Ep/77IQBUXESsuXqOnF86czRKPg
PDsOr6kpZ8FOJ3dO6zldkpKSVLzDgPnwQ0fO/w1Eprnwc+5wJAdmhEEPnK1dCd1D
k03VOa6KFUdpH8OI0MQJgPWLKjJpONimp0GQhQyouY9pKUQoo17WH0mMRC4gjZmF
1252xvVQTew65cbsG3faW+4sDqzT0G+tv664DtszBBCa8DmajPm8xyly1dmP6pYZ
WyNF3lM6IGSmZDhjadCDCB1Bey44QyLXzDWrYaBWfXvkb9kmrVaPpx+oHpjyz1eo
fwuw4CEN0U2l4ZI5x7Op2ZBFG4i8lNab6KZAMOhLeppYxmQN+/ixAccpoymNtP8i
SGAAQ2gzSR8jxQ0m94p8SzXiaB7d/MTGM5y4gNfHDM/Q69x+SOT6dXs2Qi/VJQM+
nGoqYOYp5Ok93HdrQJHn
=mVZ8
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
