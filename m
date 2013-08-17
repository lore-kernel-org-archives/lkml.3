Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3HQLRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 07:17:53 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35840 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3HQLRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 07:17:51 -0400
Date: Sat, 17 Aug 2013 13:17:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130817111747.GB1536@mithrandir>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
 <20130816210637.GC2198@kroah.com>
 <20130816215530.GA14464@mithrandir>
 <20130816220807.GA6848@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <20130816220807.GA6848@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2013 at 03:08:07PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 16, 2013 at 11:55:31PM +0200, Thierry Reding wrote:
> > > > +	list_for_each_entry(private, &device_early_list, early) {
> > > > +		struct device *dev =3D private->device;
> > > > +		int err;
> > > > +
> > > > +		if (dev->bus =3D=3D &platform_bus_type) {
> > >=20
> > > Why special case the platform bus?  We are trying to move things off =
of
> > > the platform bus, don't make it harder to do that :)
> >=20
> > I heard about that, but I must have missed the thread where this was
> > discussed. Can you point me to it?
>=20
> I thought it was on lkml, but it might have been limited to linux-arm
> and the ksummit-discuss mailing list on one of the threads there.
> Sorry, I can't recall it at the moment.

I think I found it. It was limited to linux-arm and ksummit-discuss.
Interesting read, thanks.

> > > Not that I really like the whole idea anyway, but I doubt there's muc=
h I
> > > can do about it...
> >=20
> > Well, getting feedback from you and others is precisely the reason why I
> > wanted to post this early. There must be a reason why you don't like it,
> > so perhaps you can share your thoughts and we can mould this into
> > something that you'd be more comfortable with.
>=20
> Ideally we would have the rest of the system up and running (i.e. sysfs)
> before having to deal with devices and drivers.  As it is, you are
> "special casing" a number of special devices on special platforms to
> work around architectural issues on those platforms.  Stuff that ideally
> would never need to be done, except for crazy hardware designers :)
>=20
> So I understand that it is needed, in some special cases, but that
> doesn't mean I have to like it...

So the rest of this thread seems to be going in a slightly different
direction. If indeed we can come up with a way to limit the early code
to setup only the bare minimum and not register all kinds of data
structures for later on, then this "workaround" shouldn't really be
needed at all.

I think it would be nice to ultimately have a single driver that would
know how to do early setup that will be enough to get us to initcalls
and do the full initialization once the regular .probe() is called.

> > To be honest I don't particularly like it either. It's very hackish for
> > core code. But on the other hand there are a few device/driver ordering
> > problems that this (or something similar) would help solve. I'm
> > certainly open to discuss alternatives and perhaps there's a much
> > cleaner way to solve the problem.
>=20
> As this usually is needed on a case-by-case basis, I'm hoping that your
> case really does need this, right?  If so, there's not much the kernel
> can do except add hooks like this to make it work properly.

Well, the most obvious cases where early initialization is needed are
interrupt controllers and clocks. Those used to be setup by platform
code and was isolated to arch/arm (I guess the same is true for other
architectures as well). That way everybody could do what they wanted.
We've moved a lot of that code out into drivers/ but a side-effect of
that was that some of it wasn't turned into proper drivers.

Perhaps the current solutions are all fine and I should just ignore that
they irritate me.

Thierry

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSD1vbAAoJEN0jrNd/PrOhiooP/j+C8x+YubrG+fkQXpYGlWAH
H2+RWZ+q0HJx2soP4HWxxNZx/e+eIL0rpucTUqEOP2W48An+S4MnP9dGWhXCqa1P
SjxSW5LOh9EWlseRHmOtfw1NrOSWFjS6Qavh0Hn6jBiRwgxFmZ9wMIP/dFw8TGOa
xTXYDQIlrA6qMyC7y5zQfCWTWYCwB2Kc5cHqiN2x5Xp3X51FWnQdPJs/uzLkr11T
aBR5dZWIYJTCZ8fP9kjeYCCIO3rgp4F/jQ74u4Mq5ly9qrsCWAfdlSZxlP1AboWm
2reHu3E5ejguN4hCIRIsgFSgXqHhbwNVNzZdBltubYKj4z1Oj0RnlMuWHj60RFIy
nQolykqBllmwl1+Ys27sHQt6nGicXKIZoJV0basSyWMW9RPTPdurfoLhRE2lGhUP
rIodXPOWEvLhLbDUy57QysKBGUlHG/kDJcOpLjTAyCC+D1AzaJbzZh8aPlZwdA/D
yiwpMTt8RZDeHEGw1UVLvgysYyjhI3E+8OZgoOZN+qqcpDK/RV2rOXZgjE4HGXEe
gISpBzQVEo37VghYonQ7crR4qVpp2CdWRNz6wHJc+Aw8f+VTHxUc3IpQEhpTgdQG
4MleGQ2uvY1mX9MenX+Eq4DwQXdmKwyq4MZiLnupze1MsVPjY8DvOMAeCuElFcAK
8hAPxxyjglmTcHRj6KZ6
=PX/3
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
