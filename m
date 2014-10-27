Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaJ0U7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:59:40 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46177 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaJ0U7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:59:39 -0400
Date: Mon, 27 Oct 2014 16:59:37 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141027205936.GE17380@hungrycats.org>
References: <1413881397.30379.7.camel@hadess.net>
 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
 <1413911644.30379.12.camel@hadess.net>
 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
 <20141022170433.GA10186@hungrycats.org>
 <1414420084.30379.53.camel@hadess.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <1414420084.30379.53.camel@hadess.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 03:28:04PM +0100, Bastien Nocera wrote:
> On Wed, 2014-10-22 at 13:04 -0400, Zygo Blaxell wrote:
> > On Tue, Oct 21, 2014 at 08:09:38PM +0200, Bastien Nocera wrote:
> > > On Tue, 2014-10-21 at 11:00 -0700, John Stultz wrote:
> > > > On Tue, Oct 21, 2014 at 10:14 AM, Bastien Nocera <hadess@hadess.net=
> wrote:
> > > > >> As for: 'Export of "wake reason" when the system wakes up (rtc a=
larm,
> > > > >> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
> > > > >> documentation'
> > > > >>
> > > > >> Can you expand more on the rational for the need here? Is this f=
or UI
> > > > >> for power debugging, or something else?
> > > > >
> > > > > No, it would be used for automating backups, or implementing
> > > > > suspend->hibernation transitions. For example, right before the m=
achine
> > > > > suspends, I would schedule it to wake up in a hour. If I get woke=
n up by
> > > > > the rtc alarm (and not by the user through a lid open), I might:
> > > > > - check that I'm plugged into the AC, it's night, and in the vici=
nity of
> > > > > the server that handles my backups and so backup the system.
> > > > > - check whether the battery is low, and hibernate the machine (if=
 it
> > > > > supports it, obviously).
> > > > >
> > > > > We cannot do that if we can't make out whether the wake-up came f=
rom a
> > > > > user action, or the alarm we set.
> > > >=20
> > > > I suspect wakeup type reporting is maybe not the best way to go abo=
ut
> > > > this, since there may be a number of causes for wakeups and they can
> > > > arrive closely together in different orders, which can result in
> > > > races.
> > > >=20
> > > > For instance, if the machine suspends, and sets an alarm to be woken
> > > > up at midnight to do a backup, if the user resumes their laptop at
> > > > 11:59:59, should the backup still proceed at midnight?
> > >=20
> > > No. And I would expect that we would get a wake up type of "power
> > > button" or "lid open" in this case.
> >=20
> > I have been using something like this for the last 7 years or so.
> > The relevant inputs are:
> >=20
> > 	1. is the user present (is there recent input on HID devices,
> > 	keyboard/mouse, but ignore devices like light sensors, 3D
> > 	accelerometers, and ACPI virtual keys)?
>=20
> If the user woke the machine up through the power button, you wouldn't
> see that from user-space. You could detect that the lid was opened,
> because you have state.
>=20
> > 	2. which network connection(s) are available to reach the
> > 	backup server?
> >=20
> > 	3. how much power is available (if on battery, how much run
> > 	time left?)
> >=20
> > 	4. what is the policy (do backups happen at a specific time
> > 	of day, or whenever they can?)
> >=20
> > 	5. was a backup completed successfully in the last N hours?
> >=20
> > Note the absence of any information about the cause of recent
> > suspend/resume activity, or any input from suspend/resume at all.
>=20
> How do I tell my environment not to wake the screen up when the machine
> was woken up by an alarm I scheduled to launch a backup?=20

Lid closed?  Screen off (nobody can see it, it wastes power on battery,
and lengthens charge time on AC).

Lid open and user input?  Screen on.

Lid open and user disabled time-based screen power saving?  Screen on.

These are not symmetrical.  To wake up the screen, the screen needs to
be visible, and the policy conditions to wake up the screen need to be
met.  Spontaneously firing up a backlight at full power in a dark room
in the middle of the night may not be appreciated by the system owner.

I could see the utility of capturing ACPI state here, but only as a way
to sense the "user present" condition.

> Or not to
> resume audio playback when I get woken up to handle network events
> (through connected suspend, or Wake-On-(Wireless-)LAN)?

Audio playback can wait for evidence of user presence too (unless we're
implementing an alarm clock, and need to wake up the audio ourselves--but
we'd know that because of the time).


--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlROsjgACgkQgfmLGlazG5z6HwCfRT+SxE7v6JsLA6gL2pjrdEn2
e34AoLwTFpKtSyGGEOnzK/Rz0cR33fUW
=h0Zo
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
