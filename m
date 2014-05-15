Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaEOIzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:55:36 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57821 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaEOIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:55:32 -0400
Date: Thu, 15 May 2014 10:53:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] drivers/base: Add interface framework
Message-ID: <20140515085324.GA6434@ulmo>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <1399995050-28435-5-git-send-email-thierry.reding@gmail.com>
 <20140513175713.GS3908@phenom.ffwll.local>
 <20140514003215.GA21520@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20140514003215.GA21520@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 05:32:15PM -0700, Greg Kroah-Hartman wrote:
> On Tue, May 13, 2014 at 07:57:13PM +0200, Daniel Vetter wrote:
> > On Tue, May 13, 2014 at 05:30:47PM +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >=20
> > > Some drivers, such as graphics drivers in the DRM subsystem, do not h=
ave
> > > a real device that they can bind to. They are often composed of sever=
al
> > > devices, each having their own driver. The master/component framework
> > > can be used in these situations to collect the devices pertaining to =
one
> > > logical device, wait until all of them have registered and then bind
> > > them all at once.
> > >=20
> > > For some situations this is only a partial solution. An implementation
> > > of a master still needs to be registered with the system somehow. Many
> > > drivers currently resort to creating a dummy device that a driver can
> > > bind to and register the master against. This is problematic since it
> > > requires (and presumes) knowledge about the system within drivers.
> > >=20
> > > Furthermore there are setups where a suitable device already exists, =
but
> > > is already bound to a driver. For example, on Tegra the following dev=
ice
> > > tree extract (simplified) represents the host1x device along with chi=
ld
> > > devices:
> > >=20
> > > 	host1x {
> > > 		display-controller {
> > > 			...
> > > 		};
> > >=20
> > > 		display-controller {
> > > 			...
> > > 		};
> > >=20
> > > 		hdmi {
> > > 			...
> > > 		};
> > >=20
> > > 		dsi {
> > > 			...
> > > 		};
> > >=20
> > > 		csi {
> > > 			...
> > > 		};
> > >=20
> > > 		video-input {
> > > 			...
> > > 		};
> > > 	};
> > >=20
> > > Each of the child devices is in turn a client of host1x, in that it c=
an
> > > request resources (command stream DMA channels and syncpoints) from i=
t.
> > > To implement the DMA channel and syncpoint infrastructure, host1x com=
es
> > > with its own driver. Children are implemented in separate drivers. In
> > > Linux this set of devices would be exposed by DRM and V4L2 drivers.
> > >=20
> > > However, neither the DRM nor the V4L2 drivers have a single device th=
at
> > > they can bind to. The DRM device is composed of the display controlle=
rs
> > > and the various output devices, whereas the V4L2 device is composed of
> > > one or more video input devices.
> > >=20
> > > This patch introduces the concept of an interface and drivers that can
> > > bind to a given interface. An interface can be exposed by any device,
> > > and interface drivers can bind to these interfaces. Multiple drivers =
can
> > > bind against a single interface. When a device is removed, interfaces
> > > exposed by it will be removed as well, thereby removing the drivers t=
hat
> > > were bound to those interfaces.
> > >=20
> > > In the example above, the host1x device would expose the "tegra-host1=
x"
> > > interface. DRM and V4L2 drivers can then bind to that interface and
> > > instantiate the respective subsystem objects from there.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > > Note that I'd like to merge this through the Tegra DRM tree so that t=
he
> > > changes to the Tegra DRM driver later in this series can be merged at
> > > the same time and are not delayed for another release cycle.
> > >=20
> > > In particular that means that I'm looking for an Acked-by from Greg.
> > >=20
> > >  drivers/base/Makefile     |   2 +-
> > >  drivers/base/interface.c  | 186 ++++++++++++++++++++++++++++++++++++=
++++++++++
> > >  include/linux/interface.h |  40 ++++++++++
> > >  3 files changed, 227 insertions(+), 1 deletion(-)
> > >  create mode 100644 drivers/base/interface.c
> > >  create mode 100644 include/linux/interface.h
> >=20
> > Hm, this interface stuff smells like bus drivers light. Should we inste=
ad
> > have a pile of helpers to make creating new buses with match methods mo=
re
> > trivial? There's a fairly big pile of small use-cases where this might =
be
> > useful. In your case here all the host1x children would sit on a host1x
> > bus. Admittedly I didn't look into the details.
>=20
> I have no problem adding such "bus-light" functions, to make it easier
> to create and implement a bus in the driver core, as I know it's really
> heavy.  That's been on my "todo" list for over a decade now...

Greg,

Do you think you could find the time to look at this patch in a little
more detail? This isn't about creating a light alternative to busses at
all. It is an attempt to solve a different problem.

Consider the following: you have a collection of hardware devices that
together can implement functionality in a given subsystem such as DRM or
V4L2. In many cases all these devices have their own driver and they are
glued together using the component helpers. This results in a situation
where people are instantiating dummy devices for the sole purpose of
getting a driver probed, since all of the existing devices have already
had a driver bind to them.

Another downside of using dummy devices is that they mess up the device
hierarchy. All of a sudden you have a situation where the dummy device
is the logical parent for its aunts and uncles (or siblings).

The solution proposed here is to allow any device to expose an interface
that interface drivers can bind to. This removes the need for dummy
devices. As opposed to device drivers, an interface can be bound to by
multiple drivers. That's a feature that is needed specifically by host1x
on Tegra since two drivers need to hang off of the host1x device (DRM
and V4L2), but I can easily imagine this to be useful in other cases.
Interfaces are exposed explicitly at probe time by the device drivers
for the devices they drive.

Even though this was designed with the above use-case in mind I can
imagine this to be useful for other things as well. For example a set of
generic interfaces could be created and devices (or even whole classes
of devices) could be made to expose these interfaces. This would cause
interfaces to be created for each of these devices. That's functionality
similar to what can be done with notifiers, albeit somewhat more
structured. That could for example be useful to apply policy to a class
of devices or collect statistics, etc.

If you think that I'm on a wild-goose chase, please let me know so that
I don't waste any more time on this.

Thierry

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdICEAAoJEN0jrNd/PrOhBwAP/i+iIT3AdG89PvbhnVagiUde
ZG01XHzGWc0AcoLvYss602zVkafW3ArC+uZUlVBm22NmFeE4zU162p3eWwf0kjs7
Nb1RCj53QgUFBXJXZZNkSy6qVtcE9rEc9JTaTJMbK4WhV6+l2nicbFP5KjLzVDpN
LPrD7MiDTIjL2hPfnjaVq94bJ/GkfgkOSmU2O7GPaTLYrJpnYhtee0hHLb0tx8MY
lYRbsGQxMo5W83nTcmzOKle70SiRIYeOo68dHHWpgaMFWmwLT3Pb3Z5/QvfeDLvQ
PPomdxhk65GqPjtHgReihwT2nGT7gWq9nJTQe8GDtrGvN4nGqakpC+tl0wB4Ph91
MV49yvX5JClOwap+CQPyPQfWfPz0LttLRLmXhf2b8aF2n/N4s+r8VD/qibhywH7S
CpXzRrRYXv9H1QNR7N8/WxvLCsc4RHrFkjYYJz3vs846t8KS1mE+sVvV55t5IwOT
df6f2BZt+NL75crE7J+OhLGHqTJVOdhg7LW4U4gWkGoXmSDlpvlNwtSJ3MwNNTQe
rW8cBAXwyLWJLbW6FBe65YJ/ugDifT6hJDkGnKOAEaoLepQC0vh+GN/ojUTHPbxM
bdTNYzkYX8c9771hr32nfWt+8U1I201MeEOhLmH/HRbs7byZRlpCDYXo5lzf55ZI
e5W1RwhzGlAGx7f51Q02
=8Lje
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
