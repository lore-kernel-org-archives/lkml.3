Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab3DDJ0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:26:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53503 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758317Ab3DDJ0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:26:41 -0400
Date: Thu, 4 Apr 2013 12:26:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <rob.herring@calxeda.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>, <t.figa@samsung.com>,
        <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130404092616.GD30991@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130403141831.GJ14680@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1304031410320.2027-100000@iolanthe.rowland.org>
 <20130404071832.GD30287@arwen.pp.htv.fi>
 <CAFp+6iF9VJ5EneyVA9c6ggEa_RiUw0ZRBTRgh_gy--5ubP=8=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Content-Disposition: inline
In-Reply-To: <CAFp+6iF9VJ5EneyVA9c6ggEa_RiUw0ZRBTRgh_gy--5ubP=8=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 04, 2013 at 02:26:51PM +0530, Vivek Gautam wrote:
> >> > > Lets suppose DWC3 enables runtime_pm on USB 2 type phy,
> >> > > it will try to go into suspend state and thereby call runtime_susp=
end(), if any.
> >> > > And PHY will come to active state only when its consumer wakes it =
up,
> >> > > and this consumer is operational
> >> > > only when its related PHY is in fully functional state.
> >> > > So do we have a situation in which this PHY goes into low power st=
ate
> >> > > in its runtime_suspend(),
> >> > > resulting in non-detection of devices on further attach (since PHY=
 is
> >> > > in low power state) ?
> >> > >
> >> > > Will the controller (like EHCI/OHCI) be functional now ?
> >> >
> >> > ehci/ohci need to cope with that by calling usb_phy_autopm_get_sync(=
),
> >> > right ? (so does DWC3 :-)
> >>
> >> Maybe you guys have already got this all figured out -- if so, feel
> >> free to ignore this email.
> >>
> >> Some subsystems handle this issue by calling pm_runtime_get_sync()
> >> before probing a driver and pm_runtime_put_sync() after unbinding the
> >> driver.  If the driver is runtime-PM-enabled, it then does its own
> >> put_sync near the end of its probe routine and get_sync in its release
> >> routine.
> >
> > sounds a bit 'fishy' to me... So a separate entity would call
> > pm_runtime_get_sync(), even when we don't have registered dev_pm_ops,
> > then drivers need to check if runtime_pm is enabled and call
> > pm_runtime_put*() conditionally before returning from probe(). One
> > remove, we might have another issue: device is already runtime_suspended
> > (due to e.g. autosuspend) when module is removed, a call to
> > pm_runtime_put_sync() will be unbalanced. No ?
>=20
> May be i am misinterpreting !!
> If PHYs are runtime-PM enabled (PHY probe calls *runtime_enable*),
> then the consumers
> need to call pm_runtime_get_sync whever they want to access PHY.

Alright, so here's my understanding:

I suggested letting e.g. DWC3 enable the PHY's runtime_pm; Alan said
that it could be done before that so that DWC3 sees an enabled PHY
during probe.

--=20
balbi

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXUc4AAoJEIaOsuA1yqREyrcP/joqz7ntl5jWu2qWDFdo73Oz
Pz+JPP4UI7sRtIcdz+QajORhKYk0BTfc5J1uZAMbkjr9/DVfp2UN8YmEXSCOOMjM
LTI5tyuEQNfMsucaWkveE2MytHk84jfTZKCE03cw6U/DCKnsMcWq+/cS8YGRz+rx
7hGbSaMMmkLq+q7isY+PKz4VwixBT7kOLUCvrp6KXKKFoTrbg4ycgyCXIEL4hBg0
sn4RJLThO+yNY6Bo35tJ2pVqutcLFtV3te0Q1BICYr5RK0kE5iOLJLC0Z3oJGFA3
JzA1fy2ebJkc0MPJyAnqicdgwH4Q6QAKghSesp8hQ9QrHBMYIl+29LVyvBBODgDF
EAZjHLVRUvGCkPyH/DwcrZ2MrUdifD6pQYuRG8qKxrcAPZdHzHybth9iLqdh3DC9
IGR+QPGl6jAO6rHrF4iop7YbwEJbhDnRqBc3g0MYJk6VOtOhe+mHw1+HV11jJqV4
JH6snQTYTLpm7BWqba9HkpDL4/Jdi+4yrvRqxQuHcR2Juq9oDDLLfN8pigwBymH2
V25hLo8lFvWnL/WPFdjOUHagQQFGDXS3/uASYc+x+neshn9YY7i38fG2K2nPyVWI
IztYpdjINSBGPkqLWY8ETf+8DgXKNcWPhsznH/Wf49BNyfzjJ5vpKllKldmOM6og
HFXsU93ql1urJyXchzal
=iDob
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
