Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaJXTqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:46:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35898 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaJXTqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:46:00 -0400
Date: Fri, 24 Oct 2014 14:44:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        <nsekhar@ti.com>, <t-kristo@ti.com>, <j-keerthy@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141024194442.GG11455@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
 <20141024160845.GM26941@saruman>
 <20141024190251.GB19377@localhost>
 <20141024192540.GD11455@saruman>
 <20141024192948.GE11455@saruman>
 <20141024193655.GD19377@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G44BJl3Aq1QbV/QL"
Content-Disposition: inline
In-Reply-To: <20141024193655.GD19377@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--G44BJl3Aq1QbV/QL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 09:36:55PM +0200, Johan Hovold wrote:
> On Fri, Oct 24, 2014 at 02:29:48PM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 24, 2014 at 02:25:40PM -0500, Felipe Balbi wrote:
> > > On Fri, Oct 24, 2014 at 09:02:51PM +0200, Johan Hovold wrote:
> > > > [ +CC: Russell ]
> > > >=20
> > > > On Fri, Oct 24, 2014 at 11:08:45AM -0500, Felipe Balbi wrote:
> > > >=20
> > > > > I tested this entire series with my BBB and it still works fine. =
However
> > > > > I still get below panic. This time without any DRM errors:
> > > > >=20
> > > > > [   63.087832] Kernel panic - not syncing: Attempted to kill init=
! exitcode=3D0x00000000
> > > > > [   63.087832]=20
> > > > > [   63.097399] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.=
18.0-rc1-00095-g8524e69 #556
> > > > > [   63.106060] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] =
(show_stack+0x20/0x24)
> > > > > [   63.114160] [<c00132f0>] (show_stack) from [<c0657404>] (dump_=
stack+0x8c/0xa4)
> > > > > [   63.121706] [<c0657404>] (dump_stack) from [<c0654f70>] (panic=
+0xa0/0x220)
> > > > > [   63.128895] [<c0654f70>] (panic) from [<c0049e64>] (do_exit+0x=
974/0x9d0)
> > > > > [   63.135900] [<c0049e64>] (do_exit) from [<c006775c>] (SyS_rebo=
ot+0x14c/0x1e8)
> > > > > [   63.143361] [<c006775c>] (SyS_reboot) from [<c000f080>] (ret_f=
ast_syscall+0x0/0x48)
> > > > > [   63.151596] ---[ end Kernel panic - not syncing: Attempted to =
kill init! exitcode=3D0x00000000
> > > > >=20
> > > > > Then again, this also happens by simply calling poweroff without
> > > > > enabling wakealarm.
> > > >=20
> > > > Bah, I forgot to look into that. I haven't seen this myself as I do=
n't
> > > > use systemd (which does the syscall from process 0).
> > > >=20
> > > > Some driver power-off implementations and some arch machine_power_o=
ff
> > > > spin indefinitely (or use an mdelay and WARN) after trying to power=
 off.
> > > >=20
> > > > I think this is really a bug in arch/arm that should be fixed
> > > > analogously to how failed reboot is handled in machine_restart().
> > > >=20
> > > > Care to try the patch below?
> > > >=20
> > > > I should still add a two-second delay to rtc-omap to avoid the arch
> > > > error message.
> > > >=20
> > > > Andrew, can you update one patch in the series or should I just res=
end
> > > > them all (with proper Tested-by tags)?
> > > >=20
> > > > > In any case, for the whole series:
> > > > >=20
> > > > > Tested-by: Felipe Balbi <balbi@ti.com>
> > > >=20
> > > > Thanks for testing!
> > > >=20
> > > > Johan
> > > >=20
> > > >=20
> > > > >From aaa1d1d6171c895b6966ba5b738ac7946ada97c7 Mon Sep 17 00:00:00 =
2001
> > > > From: Johan Hovold <johan@kernel.org>
> > > > Date: Fri, 24 Oct 2014 18:53:09 +0200
> > > > Subject: [PATCH] ARM: fix failed power-off handling
> > > >=20
> > > > Make sure to handle failed power off by printing an error message a=
nd
> > > > halting (analogously to how failed reboot is handled).
> > > >=20
> > > > Power off can fail for example if the hardware has not been wired up
> > > > correctly.
> > > >=20
> > > > This avoids a kernel panic when called from process 0:
> > > >=20
> > > > [   63.087832] Kernel panic - not syncing: Attempted to kill init! =
exitcode=3D0x00000000
> > > > [   63.087832]
> > > > [   63.097399] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.18=
=2E0-rc1-00095-g8524e69 #556
> > > > [   63.106060] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (s=
how_stack+0x20/0x24)
> > > > [   63.114160] [<c00132f0>] (show_stack) from [<c0657404>] (dump_st=
ack+0x8c/0xa4)
> > > > [   63.121706] [<c0657404>] (dump_stack) from [<c0654f70>] (panic+0=
xa0/0x220)
> > > > [   63.128895] [<c0654f70>] (panic) from [<c0049e64>] (do_exit+0x97=
4/0x9d0)
> > > > [   63.135900] [<c0049e64>] (do_exit) from [<c006775c>] (SyS_reboot=
+0x14c/0x1e8)
> > > > [   63.143361] [<c006775c>] (SyS_reboot) from [<c000f080>] (ret_fas=
t_syscall+0x0/0x48)
> > > > [   63.151596] ---[ end Kernel panic - not syncing: Attempted to ki=
ll init! exitcode=3D0x00000000
> > > >=20
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > ---
> > > >  arch/arm/kernel/process.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >=20
> > > > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > > > index a35f6ebbd2c2..68c38af5687c 100644
> > > > --- a/arch/arm/kernel/process.c
> > > > +++ b/arch/arm/kernel/process.c
> > > > @@ -212,6 +212,12 @@ void machine_power_off(void)
> > > > =20
> > > >  	if (pm_power_off)
> > > >  		pm_power_off();
> > > > +
> > > > +	/* Give a grace period for failure to power off */
> > > > +	mdelay(1000);
> > > > +
> > > > +	pr_err("Power off failed -- system halted\n");
> > > > +	while (1);
> > > >  }
> > >=20
> > > with this I always get to "Power off failed -- system halted". If I
> > > switch to v3.18-rc1 vanilla, then it works. So it's definitely caused=
 by
> > > your rtc-only patches.
>=20
> That's expected (see below). It works with v3.18-rc1 vanilla because
> machine_halt is called instead of machine_power_off as there is no
> registered power-off handler.

yeah, that much I figured :-)

> > ok, so it seems like it takes more than 1 second for things to
> > propagate. If I increase that mdelay() to 3000, then everything works
> > fine on my end. I think we should get RMK's input on this 3000ms delay
> > to machine_power_off(). Should it be generic, or should we add it to our
> > rtc pm_power_off implementation ?
>=20
> As I wrote above, we still need a 2-second mdelay in rtc-omap, which I
> intend to add to the pmic_power_en patch.

oh, alright then. If you can Cc me, I'll make sure to test that too ;-)

> The one-second delay is there in machine_power_off to catch most cases
> which wouldn't take nearly as long as rtc-omap and hence wouldn't be
> adding an explicit delay in the driver power-off handler.

alright.

--=20
balbi

--G44BJl3Aq1QbV/QL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSqwqAAoJEIaOsuA1yqREZtIP/0TVYuONPWkD5azg31LlkjdK
hYgiT5yuFRFW9lBFdUPmhAZCRE/71BqjM+tG+5L9sowJiTHoNMOtzIfnGxGw7U83
ikxBP6CM8VLfcRiEcSkneqLjDfcSFWEpXMPqpHTgG6nsPc2xtNjgqWmGkP41Jnq0
rGRlirLmC3x9ze/QZkozAEtScJoJZGJliTxZLK4UL8NV1/Wrsd1ggUVIf+KIDlIH
U/sa7SXN1GOHJV+p7fEWFetZY7Eg+zP6Z/JeScKMJx6GoZ8+Hq3fqh97we5GNwR6
+3c6WpTWvf3asBXAs6Ar23ueF4MaRCCDvgEcyXgdjT0fI43zocG3K4hMv41jQzu4
+tHtTmWpyCQiGgLFMd3OzJ0yBwEwOGm3j9m9vveO0pxDarfVi8CGqsNM9e30EpG3
Nw0+7Bggi4tOWtzJPdAsQwrWcYw0BCLjc8qrJCWGi7DtjpDytRLlOUFc8MAItwX5
IunQR+yOeysq1MBAUS70avOU46T7686RPj3qkG1lbZ+IGDP/9Lh9Pjyz0u5GHFPe
GENgHBgnlyn3CoGtU451yww3Ar494tE/xeihyDMW5moyvEzUBM5mbcKrzbVQD7x+
gmTqK9XfwTWhkRGd4dpTNQ6dADfw+cTwn2q7cGip3RcIi9Tondu4yjKY8R5JbisB
uo9sVVmftFxDKoRUgM5P
=POaL
-----END PGP SIGNATURE-----

--G44BJl3Aq1QbV/QL--
