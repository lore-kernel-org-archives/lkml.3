Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3EIPo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:44:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60005 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3EIPoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:44:25 -0400
Date: Thu, 9 May 2013 16:43:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>,
        Ming Lei <tom.leiming@gmail.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130509154352.GG3200@sirena.org.uk>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
 <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
 <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com>
 <20130509135017.GD3200@sirena.org.uk>
 <20130509141444.GV18614@n2100.arm.linux.org.uk>
 <20130509143702.GE3200@sirena.org.uk>
 <20130509150750.GW18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Content-Disposition: inline
In-Reply-To: <20130509150750.GW18614@n2100.arm.linux.org.uk>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2013 at 04:07:50PM +0100, Russell King - ARM Linux wrote:
> On Thu, May 09, 2013 at 03:37:02PM +0100, Mark Brown wrote:

> > That's clearly a "don't do that then" sort of thing; while we don't want
> > to be unhelpful there's no guarantees with this approach.

> That's not a "don't do that then" thing, because in this case it's
> unreasonable to say that.  The display subsystems like fbdev and
> DRM represent quite a sizable chunk:

> - Base DRM is around 200k.
> - DRM drivers typically around 100k each.
> - Base FBdev is around 100k.

> It won't take long before you're into the territory of having a
> significant portion of your kernel being display drivers of one
> type or other, much of which won't be usable on any one specific
> platform.  So to say "don't build your display drivers as modules"
> is an unreasonable position to take.

Sure, it's unhelpful for distro style kernels.  Like I say, 90%.

> > Another option here which is more in tune with deferred probing and
> > hotplugging would be to switch the delay over to be time based rather
> > than initcall based; do the shutdown at some point based on the time the
> > last resource was registered.  That still won't cover everything
> > though we could make the delay tunable.

> Yuck.  That's crap design.  Really, time based stuff is crap.  I've seen
> this too many times with the gnome crap in Ubuntu 12.04 - where if you
> boot this off SD card it will complain that some applets fail to start
> (and sure enough, half your panel is missing.)  Boot it off eSATA and
> it works 100% reliably.

No argument here, there's a reason I immediately went to the "make it
tunable" fudge factor.

> A better solution may be to avoid the problem in kernel space altogether.
> That's already done in the past with the scsi_wait_scan module.  Make the
> the shutdown of stuff a separate loadable module which userspace can load
> at the appropriate time to trigger the shutdown of unused resources.  Or
> provide a different method for userspace to trigger that action.

> With that kind of solution, it is possible to know that the system has
> finished booting (many userspace implementations already do this with
> stuff like not permitting login via network until after the system has
> finished booting despite sshd et.al. already being started.)

This works fine for boot but if we're going to solve this properly and
asking userspace to make changes we probably ought to be trying to
handle the actual hotplug case (which the current bodge doesn't cope
with at all) as well.  A similar tactic with asking for handshaking from
userspace for hotplug notifications should work though it'd be a bit
more hassle to deploy.

Or perhaps given that it should be simple for userspace and there's
probably other uses for the information we just put the hook in there
anyway even if this particular problem gets a better solution later on.

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi8Q1AAoJELSic+t+oim9zw0P/R1PEq2M9dy/Rqlr8IcSVnRE
L/JoQabZMGcbf3zSATstsMlYPbYxuLUQnnv+3hxJ2e2bEBe/BZ6q5R3/Nj6dFExQ
aNoEfyFfMgj1gcCbw+j8jLZRsFts/KJODMuTkLntdVRxvH+fwvDO6k+FKsYEKFdY
+Zpv3EqGr5UgBkvSP/hYVr1G/cJOTE42NPnsYUzWdjy95KdVeBOWUGpHyp1L//Kt
blOWKii+Db8zYkOf5UY/viWkYcSgGAvaLw/5HBdDCDFaNJ1k9uy1qHZ9Ld2uRg+i
c8bnv9rUz8nFtM7fVU/CWJPfWihMkDT8zREhQt00amrpyavSBTcjtWXEOlBoOfYY
QYzaLHuVSSHIlihYHZ5a4YsPsC+4zbjTj/t6fbXMXbNfkyuxQw6S04F5L4rnZ9PD
Qp6tAV1yqGC+a8zl7fi4ok4d0QgRYsn07cRF1Sb3YHtmClLS7TSLokcvNifTIM6C
hO4THZ/8mDbY3V4Z8d//sc4079BLN6dgplhBBFQb8QeFDISv+nf4hS8YOa5Ckc5n
3wklHGTCDc6cslgLx60HGoIKt0ScNmBAkZvp5vtLO3xABmBvpD36Y/90bTcdMg9m
eFc5fOWPLPOK/4X23TEfI8PrtxsdDWqXo/rBTETjNpSp4MsxBs2eCQNH0XcimKlm
pe4s/gz0SwBdmEtpPCJb
=fcdI
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
