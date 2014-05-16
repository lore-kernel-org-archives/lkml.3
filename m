Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbaEPPil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:38:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50148 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756295AbaEPPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:38:26 -0400
Message-ID: <1400254689.2647.43.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 31/34] rtl8192ce: Fix null dereference in watchdog
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Chaoming Li <chaoming_li@realsil.com.cn>,
        Dmitry Semyonov <linulin@gmail.com>
Date: Fri, 16 May 2014 16:38:09 +0100
In-Reply-To: <53761EA9.6060508@lwfinger.net>
References: <lsq.1400244441.849613969@decadent.org.uk>
	 <53761EA9.6060508@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qtigPaJDf5qmv/y2bNB9"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qtigPaJDf5qmv/y2bNB9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-05-16 at 09:20 -0500, Larry Finger wrote:
> On 05/16/2014 07:47 AM, Ben Hutchings wrote:
> > 3.2.59-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Ben Hutchings <ben@decadent.org.uk>
> >
> > Dmitry Semyonov reported that after upgrading from 3.2.54 to
> > 3.2.57 the rtl8192ce driver will crash when its interface is brought
> > up.  The oops message shows:
> >
> > [ 1833.611397] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000010
> > [ 1833.611455] IP: [<ffffffffa0410c6a>] rtl92ce_update_hal_rate_tbl+0x2=
9/0x4db [rtl8192ce]
> > ...
> > [ 1833.613326] Call Trace:
> > [ 1833.613346]  [<ffffffffa02ad9c6>] ? rtl92c_dm_watchdog+0xd0b/0xec9 [=
rtl8192c_common]
> > [ 1833.613391]  [<ffffffff8105b5cf>] ? process_one_work+0x161/0x269
> > [ 1833.613425]  [<ffffffff8105c598>] ? worker_thread+0xc2/0x145
> > [ 1833.613458]  [<ffffffff8105c4d6>] ? manage_workers.isra.25+0x15b/0x1=
5b
> > [ 1833.613496]  [<ffffffff8105f6d9>] ? kthread+0x76/0x7e
> > [ 1833.613527]  [<ffffffff81356b74>] ? kernel_thread_helper+0x4/0x10
> > [ 1833.613563]  [<ffffffff8105f663>] ? kthread_worker_fn+0x139/0x139
> > [ 1833.613598]  [<ffffffff81356b70>] ? gs_change+0x13/0x13
> >
> > Disassembly of rtl92ce_update_hal_rate_tbl() shows that the 'sta'
> > parameter was null.  None of the changes to the rtlwifi family between
> > 3.2.54 and 3.2.57 seem to directly cause this, and reverting commit
> > f78bccd79ba3 ('rtlwifi: rtl8192ce: Fix too long disable of IRQs')
> > doesn't fix it.
> >
> > rtl92c_dm_watchdog() calls rtl92ce_update_hal_rate_tbl() via
> > rtl92c_dm_refresh_rate_adaptive_mask(), which does not appear in the
> > call trace as it was inlined.  That function has been completely
> > removed upstream which may explain why this crash wasn't seen there.
> >
> > I'm not sure that it is sensible to completely remove
> > rtl92c_dm_refresh_rate_adaptive_mask() without making other
> > compensating changes elsewhere, so try to work around this for 3.2 by
> > checking for a null pointer in rtl92c_dm_refresh_rate_adaptive_mask()
> > and then skipping the call to rtl92ce_update_hal_rate_tbl().
> >
> > References: https://bugs.debian.org/745137
> > References: https://bugs.debian.org/745462
> > Reported-by: Dmitry Semyonov <linulin@gmail.com>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> > ---
>=20
> Ben,
>=20
> Your fix is a reasonable workaround. I have no explanation for this NULL =
pointer=20
> dereference to suddenly appear; however, the pointer should have been che=
cked=20
> from the start.

Are you saying this is also an upstream bug?

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-qtigPaJDf5qmv/y2bNB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU3Yw6+e/yOyVhhEJAQrvTQ/+IZkShbHsw+5/BRWS9LBYjxIFNoScVId7
XgVf025SC7YVUrG1ZV9bZr4QW2Np+cjPOL6juvmL0smRuy91X/Z2zMArcqoE5CgO
NKm1JoevKn0eWXVAW5QI0Kt/Gaz199ouPfhr0cNWt37B1Pm/awPbo+Xn0AmlUVzE
5zw77LTBUl6LREeZvkI67TH/3tOY3pBSKLtjaf+YVEU2fgiX9UPk4EfHcWZATY7L
h4RCfJ9t/zSdEd2ueZTcRmXw3SzScvIwHwkEjqBQCmgYpleV/ve+sNUs2crP+GAj
Dx+RF2H+N0F6x47XuH47HeH0j11QUZ6fO0nHxavip7ca8rno1wn3FZOFfr/IzNqJ
gcfNzLbM+14bvVd6dL+nYLMlwQcBtaRUsFbmo8Tf+9iwDqaTw4JMuWjc0hUgVi0F
fvnWehUHgLg8BVkxd7xAYuUhC/nfUnRMuDMQNXuEXs6LwiLRBBPsdGbzUjooUZyy
zJv837WDSkWsmxA9TC73BUkdgf05dAELcL2e57iD3vupeHWm+S0g/jLscjkDJKEN
9zI4T1V+8S8G7ljkkxQ4HBaRvjjtt4kE8ha5DgwI0o7WQ1l/VY7IQBTH+kEUmi0P
BW8sEkeqDHPOCea00LaDy9ND3wzDT5iERvnKyCg2mCwQ7IC8ron1WeFgq5yONWAa
oOqtN7yTSsk=
=nkR+
-----END PGP SIGNATURE-----

--=-qtigPaJDf5qmv/y2bNB9--
