Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab3HORLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:11:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57663 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab3HORL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:11:29 -0400
Date: Thu, 15 Aug 2013 18:10:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130815171048.GC30073@sirena.org.uk>
References: <20130814235519.GS2401@sirena.org.uk>
 <Pine.LNX.4.44L0.1308151013350.1210-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308151013350.1210-100000@iolanthe.rowland.org>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 10:42:00AM -0400, Alan Stern wrote:
> On Thu, 15 Aug 2013, Mark Brown wrote:

> So why not bring the device to full power as soon as possible during
> boot, and have it registered on the bus in the usual way?  Once that's
> done, the ordinary runtime PM mechanism will allow the device to go
> back off-line.

That could be done, and is likely to happen anyway as a result of device
initialisation.  I'm not sure it buys much to force it to happen
immediately, though.

> > I've also mentioned the devices that need platform data which is a part
> > of this too; one reason for knowing that the device is there before it
> > appears is so that we can pass platform data/DT/whatever to it.

> Can you pass this "whatever" data to the device as part of the initial=20
> bring-it-to-full-power procedure?

It is often going to be required as part of the bring it to full power
procedure.

> By the way, you mentioned something earlier that some of this platform
> data might duplicate information that could be discovered through the
> usual bus probing mechanisms (for example, USB descriptors).  IMO
> that's a bad idea.  Not only is it wasteful, it also has the potential

If you check the discussion it pretty much consisted of everyone saying
that duplicating enumerable information was a terrible idea.

> > >      A: Devising a mechanism for platform code to do things involving
> > > 	devices that are dynamically registered on discoverable buses.

> > If we need random platform code then we're failing, half the point of
> > things like DT and ACPI is to avoid writing random board code.  we do
> > want to pass data to devices for their drivers to use but having to have
> > random bits of per board code would be really sad.

> At the level of abstraction in this discussion, there's no need to=20
> discriminate between code and data.  Just imagine that I simply wrote=20
> "platform", meaning platform code and/or data.

There's a big difference between random glue outside the drivers and
something the drivers know about themselves, it's important to be clear
on this.  Bodges for this often involve writing a bit of board code that
the drivers don't know anything about.

> > >      B: Telling the subsystem and driver code for a discoverable bus
> > > 	that a particular device is present before it has been=20
> > > 	detected.

> > I think the solutions for these overlap so much they're the same thing.
> > The situation we're in in in your case B is just the idle case for
> > condition C - if we know about the device before it's been detected then
> > if it's been removed we just go back into the situation where we know
> > about it but it isn't powered.

> I imagine that teaching a subsystem to know about a device before it=20
> has been detected would require significant changes.  My suggestion --=20
> powering up the device, detecting it, and then powering it back down --=
=20
> fits in very cleanly with existing designs and would require=20
> comparatively little work.  Case B then becomes unnecessary; all the=20
> important stuff will be handled under Case C.

To be honest I don't see how that helps much if you're going to handle
the case where platform data is required to enumerate the device.  You
need to know about the device prior to enumeration in order to get the
platform data to the driver when it does enumerate and you can't
enumerate it until you do that anyway.  A bus could insist on this if it
needed the information from enumeration for some reason but really it
seems like an implementation detail.

> There's one important factor to keep in mind: Are devices on the bus
> physically removable?  If not, the situation is pretty straightforward. =
=20
> You just remember that the device used to be present, and reuse the old
> data structures when it reappears.

Not the ones I'm talking about, though other removable devices may
possibly be present on the same bus.  My interest is in the case where
we know the chip is there because we can see it soldered to the board.

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDQuVAAoJELSic+t+oim9GA0QAJO3b97ssUI5FEJeIQ0G+5q/
RInxbO8Iabigq7VXVV1OJ7TyvMSgN6nuJLl8kSRUUIw6KBh6Pmm+40wwJikT3Bas
abp+y+LRzhJH3lrvw9WP1ba41sRKKUu2jIT+df8AigWRCXPDpQubZJcZnVl1w213
pTX2pqH8GxOVlLdY10AzAK5qAhPdwS2WsJSc8g3Pjd+4fnFXMj3TiJcOyzCY26Q+
NjHtAzqBcgxeTddgQVVYKEEdm/+z1D2YzHnvo7WF0EspFaPse98T3YIlZWduwLXB
94MqTvZ6LYZrJI/sThzQY9neGkQOQpZtOYNYGaO/m4iKvZn9wPNQ4SvV+WI2ofvH
NNpXQt/Uuikq2CSHPUcBiv66+ChlHjkWrS0JUOw5BBlj1mAtWdO/L0MWedpcdN0H
AW6FZkSKEouXEIdr1nxDKzj2M+MMvtBXFXNkIVUfBWmFegcN4ZY6Jwg7vlqOY4rK
ZD7HVEYSCsHnCQQNJi4bFwgYRBlb3EFOZoWanrxLOKf/0XcB4v6scAFnJ+t1LU9e
zsZF2ApG+4UoPSAIJULw3TVrjhxRkERRAWcAKm2sAv/njlFNWQKCAxJKoFWN+WQs
HRRicMZov2Y2nzt2KHbIo4N4wlP6LNeMSNjep1wDVzixCD+SNCM4mSmPc4LxEBYn
qrz3atwWcOUua0mFeMlg
=f6FC
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
