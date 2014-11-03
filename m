Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaKCSaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:30:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35030 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaKCS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:29:59 -0500
Date: Mon, 3 Nov 2014 12:28:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 00/47] kernel: Add support for power-off handler call
 chain
Message-ID: <20141103182829.GV27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <20141103175935.GS27425@saruman>
 <20141103182213.GA10640@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yC91f7qSViS67v3c"
Content-Disposition: inline
In-Reply-To: <20141103182213.GA10640@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yC91f7qSViS67v3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 03, 2014 at 10:22:13AM -0800, Guenter Roeck wrote:
> On Mon, Nov 03, 2014 at 11:59:35AM -0600, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Oct 27, 2014 at 08:55:07AM -0700, Guenter Roeck wrote:
> > > Various drivers implement architecture and/or device specific means to
> > > remove power from the system.  For the most part, those drivers set t=
he
> > > global variable pm_power_off to point to a function within the driver.
> > >=20
> > > This mechanism has a number of drawbacks.  Typically only one means
> > > to remove power is supported (at least if pm_power_off is used).
> > > At least in theory there can be multiple means to remove power, some =
of
> > > which may be less desirable.  For example, one mechanism might power =
off the
> > > entire system through an I/O port or gpio pin, while another might po=
wer off
> > > a board by disabling its power controller. Other mechanisms may reall=
y just
> > > execute a restart sequence or drop into the ROM monitor, or put the C=
PU into
> > > sleep mode.  Using pm_power_off can also be racy if the function poin=
ter is
> > > set from a driver built as module, as the driver may be in the proces=
s of
> > > being unloaded when pm_power_off is called.  If there are multiple po=
wer-off
> > > handlers in the system, removing a module with such a handler may
> > > inadvertently reset the pointer to pm_power_off to NULL, leaving the =
system
> > > with no means to remove power.
> > >=20
> > > Introduce a system power-off handler call chain to solve the described
> > > problems.  This call chain is expected to be executed from the archit=
ecture
> > > specific machine_power_off() function.  Drivers providing system powe=
r-off
> > > functionality are expected to register with this call chain.  By usin=
g the
> > > priority field in the notifier block, callers can control power-off h=
andler
> > > execution sequence and thus ensure that the power-off handler with the
> > > optimal capabilities to remove power for a given system is called fir=
st.
> > > A call chain instead of a single call to the highest priority handler=
 is
> > > used to provide fallback: If multiple power-off handlers are installe=
d,
> > > all handlers will be called until one actually succeeds to power off =
the
> > > system.
> > >=20
> > > Patch 01/47 implements the power-off handler API.
> > >=20
> > > Patches 02/47 to 04/47 are cleanup patches to prepare for the move of
> > > pm_power_off to a common location.
> > >=20
> > > Patches 05/47 to 07/47 remove references to pm_power_off from devicet=
ree
> > > bindings descriptions.
> > >=20
> > > Patch 08/47 moves the pm_power_off variable from architecture code to
> > > kernel/reboot.c.=20
> > >=20
> > > Patches 09/47 to 34/47 convert various drivers to register with the k=
ernel
> > > power-off handler instead of setting pm_power_off directly.
> > >=20
> > > Patches 35/47 to 46/47 do the same for architecture code.
> > >=20
> > > Patch 47/47 finally removes pm_power_off.
> > >=20
> > > For the most part, the individual patches include explanations why sp=
ecific
> > > priorities were chosen, at least if the selected priority is not the =
default
> > > priority. Subsystem and architecture maintainers are encouraged to ha=
ve a look
> > > at the selected priorities and suggest improvements.
> > >=20
> > > I ran the final code through my normal build and qemu tests. Results =
are
> > > available at http://server.roeck-us.net:8010/builders in the 'powerof=
f-handler'
> > > column. I also built all available configurations for arm, mips, powe=
rpc,
> > > m68k, and sh architectures.
> > >=20
> > > The series is available in branch poweroff-handler of my repository at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.gi=
t.
> > > It is based on 3.18-rc2.
> > >=20
> > > A note on Cc: In the initial submission I had way too many Cc:, causi=
ng the
> > > patchset to be treated as spam by many mailers and mailing list handl=
ers,
> > > which of course defeated the purpose. This time around I am cutting d=
own
> > > the distribution list down significantly. My apologies to anyone I ma=
y have
> > > failed to copy this time around.
> >=20
> > you touch every single architecture with this patchset, but you didn't
> > care about Ccing any of the arch-specific mailing lists, like lakml ?
> >=20
> What is lakml ? linux-kernel@vger.kernel.org was copied, if that is what =
you

only the greatest mailing list of all time.

heh, Linux ARM Kernel Mailing List.

> refer to. I don't find a reference to lakml anywhere, sorry. I'll be happ=
y to
> add it manually if you provide the address.
>=20
> Architecture specific mailing lists were copied on individual patches as =
long
> as those mailing lists are reported by the MAINTAINERS file.
>=20
> > Please resend with proper people in Cc, IIRC RMK had a few very
> > important comments about the idea behind this series.
> >=20
> Felipe,
>=20
> That doesn't work. I tried with rev 1. The result was that the patch seri=
es
> was flagged as spam and got dropped by most mailing lists, as explained a=
bove,
> and I got tagged as spammer by Google and several other mail servers,
> preventing me from posting _anything_ for several days.

heh, that sucks.

--=20
balbi

--yC91f7qSViS67v3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8lNAAoJEIaOsuA1yqREiCEP/1Be8q8qjmYSfg5yQKj3NsZX
IXyu4Z8ATsUK6XivI/1lU+pzga2mxSVmRCmohd871evVz+V86EuUiN7/P+nV0jp7
zFaDxtsBktXDlvtSx3GRMc/kfltPCfqLU17EF1klXw2su8zm3b33uaynh5OqVx1c
gxGQzcghq9H3NIIUsIGo0CnoXx8lv/yK/xx9qEgoAjmty6pNKauGHJ6kScEtVb61
5Bf2ah34SdoPkDRmZQAOufr0t0YCOpELwZbMUcSJGsHduu/bwCEHp9ZJKM7GUJju
zPwMlWLzT9nsJhjJOT8ioLQG8dB2HRNPEpHWYEppH3dB3goBkwIJAOOzyiugdZ23
XVb44jLD3kBv1c96+G97kEGj31IUhwadQ4ERzoW2qqFOhgZgIyJ4tFNxzje2bFB8
6WBF3dEWFj55mIyLSuQS2GLsikiWOTVeBh/W6xla/WvxjjFfrxR3KtI+1E3BZMOC
6d32UahMoSVAb3dyPjCcXOIKC3iIOtdYfjWMOKQZ+vfH0TpbFQWXzkOYEkhI0T8s
TApUWP69J9sHz4BTDy7eZEbnUtlY07lbLRa3FF/MKjmyPt/lJydH6yVyPZkezFYP
HWdrTHmdE6vMvUWpkP9z2gF6ZEjbIID+nKnYAfyagW2WJBodEzAH6xHphVBzyajB
RpiGHgmB8sYVhMBgHkPs
=C9cW
-----END PGP SIGNATURE-----

--yC91f7qSViS67v3c--
