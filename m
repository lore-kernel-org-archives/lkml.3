Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaJXT06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:26:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35244 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaJXT04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:26:56 -0400
Date: Fri, 24 Oct 2014 14:25:40 -0500
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
Message-ID: <20141024192540.GD11455@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
 <20141024160845.GM26941@saruman>
 <20141024190251.GB19377@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Content-Disposition: inline
In-Reply-To: <20141024190251.GB19377@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 09:02:51PM +0200, Johan Hovold wrote:
> [ +CC: Russell ]
>=20
> On Fri, Oct 24, 2014 at 11:08:45AM -0500, Felipe Balbi wrote:
>=20
> > I tested this entire series with my BBB and it still works fine. However
> > I still get below panic. This time without any DRM errors:
> >=20
> > [   63.087832] Kernel panic - not syncing: Attempted to kill init! exit=
code=3D0x00000000
> > [   63.087832]=20
> > [   63.097399] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.18.0-r=
c1-00095-g8524e69 #556
> > [   63.106060] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_=
stack+0x20/0x24)
> > [   63.114160] [<c00132f0>] (show_stack) from [<c0657404>] (dump_stack+=
0x8c/0xa4)
> > [   63.121706] [<c0657404>] (dump_stack) from [<c0654f70>] (panic+0xa0/=
0x220)
> > [   63.128895] [<c0654f70>] (panic) from [<c0049e64>] (do_exit+0x974/0x=
9d0)
> > [   63.135900] [<c0049e64>] (do_exit) from [<c006775c>] (SyS_reboot+0x1=
4c/0x1e8)
> > [   63.143361] [<c006775c>] (SyS_reboot) from [<c000f080>] (ret_fast_sy=
scall+0x0/0x48)
> > [   63.151596] ---[ end Kernel panic - not syncing: Attempted to kill i=
nit! exitcode=3D0x00000000
> >=20
> > Then again, this also happens by simply calling poweroff without
> > enabling wakealarm.
>=20
> Bah, I forgot to look into that. I haven't seen this myself as I don't
> use systemd (which does the syscall from process 0).
>=20
> Some driver power-off implementations and some arch machine_power_off
> spin indefinitely (or use an mdelay and WARN) after trying to power off.
>=20
> I think this is really a bug in arch/arm that should be fixed
> analogously to how failed reboot is handled in machine_restart().
>=20
> Care to try the patch below?
>=20
> I should still add a two-second delay to rtc-omap to avoid the arch
> error message.
>=20
> Andrew, can you update one patch in the series or should I just resend
> them all (with proper Tested-by tags)?
>=20
> > In any case, for the whole series:
> >=20
> > Tested-by: Felipe Balbi <balbi@ti.com>
>=20
> Thanks for testing!
>=20
> Johan
>=20
>=20
> >From aaa1d1d6171c895b6966ba5b738ac7946ada97c7 Mon Sep 17 00:00:00 2001
> From: Johan Hovold <johan@kernel.org>
> Date: Fri, 24 Oct 2014 18:53:09 +0200
> Subject: [PATCH] ARM: fix failed power-off handling
>=20
> Make sure to handle failed power off by printing an error message and
> halting (analogously to how failed reboot is handled).
>=20
> Power off can fail for example if the hardware has not been wired up
> correctly.
>=20
> This avoids a kernel panic when called from process 0:
>=20
> [   63.087832] Kernel panic - not syncing: Attempted to kill init! exitco=
de=3D0x00000000
> [   63.087832]
> [   63.097399] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.18.0-rc1=
-00095-g8524e69 #556
> [   63.106060] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_st=
ack+0x20/0x24)
> [   63.114160] [<c00132f0>] (show_stack) from [<c0657404>] (dump_stack+0x=
8c/0xa4)
> [   63.121706] [<c0657404>] (dump_stack) from [<c0654f70>] (panic+0xa0/0x=
220)
> [   63.128895] [<c0654f70>] (panic) from [<c0049e64>] (do_exit+0x974/0x9d=
0)
> [   63.135900] [<c0049e64>] (do_exit) from [<c006775c>] (SyS_reboot+0x14c=
/0x1e8)
> [   63.143361] [<c006775c>] (SyS_reboot) from [<c000f080>] (ret_fast_sysc=
all+0x0/0x48)
> [   63.151596] ---[ end Kernel panic - not syncing: Attempted to kill ini=
t! exitcode=3D0x00000000
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  arch/arm/kernel/process.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index a35f6ebbd2c2..68c38af5687c 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -212,6 +212,12 @@ void machine_power_off(void)
> =20
>  	if (pm_power_off)
>  		pm_power_off();
> +
> +	/* Give a grace period for failure to power off */
> +	mdelay(1000);
> +
> +	pr_err("Power off failed -- system halted\n");
> +	while (1);
>  }

with this I always get to "Power off failed -- system halted". If I
switch to v3.18-rc1 vanilla, then it works. So it's definitely caused by
your rtc-only patches.

--=20
balbi

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSqezAAoJEIaOsuA1yqREHYwP/05a0HtlhnuRZ2dNXimOnCIT
c9kOHhggKW9PT6ujK/FOSbDtYUZG33hmEhHygwFAPlAklg77OIRkSAyPuEq+//6R
auq7znGhTRZuG44P8dyshqcrU4biGK5CaxTZPOFg6MbI6G34TQaoCuRJMEpKq24e
l7VPJc0VUeDhhU8teNLJQdH2a1oPXaZK88FZJTsSW0z2j2vhShFAYtY1nbIobgB0
zS89zRFZWDIcgk84sxzeq0/bXtWz0iWccD25aCJCd9PA1Z8swZQuDeoDOyiOHAIZ
dNu2nzu+BQeIqx8dF7ak/hlC+WzoW10jDzYVd3zNHNKnDU/ciWT+mxAfCJ+8gRdg
DEMYTn2OfHkZe6HN1rDJ3+30KHqp/L9HBkOimYJ6CjtKlgrYJwfoHYNvHKbHg1mQ
Bz8f0P9764SezvZ8EgmuLSBXiwFFNfdvZwT84uCmfmW2BXzSi8G3uF3UrkgJvlUW
d9Bl+OSqTSRHwzUmZyIYMtoc1saikfr7gKHzzTzoF1JzD3oWthxJkH5AVve9fVbw
P9MvIEuq3D55owuzrPNOxmUvP2/z2eGgwMgIB+yfiyLVAy8LWuKKMYxg4P8qrDEJ
FbyJy+SzQzPztIfZ/9+IAO/9mv8kOlrAHwiv9F9H2YFh6Y1gKlUN5UVbRojUOP0K
vuDvqWDkjA1dLzjfzZn/
=WfkB
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
