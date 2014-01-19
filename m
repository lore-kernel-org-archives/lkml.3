Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaASUyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 15:54:16 -0500
Received: from ring0.de ([91.143.88.219]:34658 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaASUyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 15:54:11 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 19 Jan 2014 21:54:03 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
Message-ID: <20140119205402.GA24185@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Anton Vorontsov <anton@enomsg.org>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-3-git-send-email-pali.rohar@gmail.com>
 <CAOf5uwkrep0PhOn67+9PHmP2A2Jxrp9DNK3BRp9D_sYu_PYvvw@mail.gmail.com>
 <201311242001.23126@pali>
 <CAOf5uw=-cy2QoDxjecxYTYsrQRD=LtN0N7DcYJHZ6HSbexzPRw@mail.gmail.com>
 <20131201223730.GD6271@lizard>
 <CAOf5uwnkQwkS7_fsLtC5nzdXyS1Rzw2SkxaziUuJrO9SKXh3yw@mail.gmail.com>
 <20131202002444.GA22418@teo>
 <CAOf5uwnz6SfeEsbGq62QFgRHJ2ys++VV1+VrULxyR4uH2Z_vJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <CAOf5uwnz6SfeEsbGq62QFgRHJ2ys++VV1+VrULxyR4uH2Z_vJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 02, 2013 at 02:45:06AM +0100, Michael Trimarchi wrote:
> On Mon, Dec 2, 2013 at 1:24 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> > On Mon, Dec 02, 2013 at 01:02:40AM +0100, Michael Trimarchi wrote:
> >> On Sun, Dec 1, 2013 at 11:37 PM, Anton Vorontsov <anton@enomsg.org> wr=
ote:
> >> > On Mon, Nov 25, 2013 at 08:16:34PM +0100, Michael Trimarchi wrote:
> >> > ...
> >> >> >> So you can read this value without any type of synchronization
> >> >> >> with the power_supply_core
> >> >> >> and sysfs implementation?
> >> > ...
> >> >> https://lists.ubuntu.com/archives/kernel-team/2013-January/025206.h=
tml
> >> >>
> >> >> I found and equivalent scenario that I was trying to said
> >> >
> >> > That's a good question, actually. Even though in Pali's case the not=
ifier
> >> > is atomic (so that we are pretty confident that the object won't be
> >> > unregistered), there is still a possiblity of a dead lock, for examp=
le. So
> >>
> >> So if the get_property is a sleeping function it will be a deadlock. R=
ight?
> >
> > All kind of bad things might happen, yes. But before that I would expec=
t a
> > bunch of warnings from might_sleep() stuff.
> >
> > I would recommend to test the patches using preempt/smp kernels + vario=
us
> > DEBUG_ kernel options set.
> >
>=20
> Is it more simple to make it not atomic and use a mutex in get_property?

I just built a kernel with CONFIG_DEBUG_ATOMIC_SLEEP to test another
driver and got the following output for bq2415x:

[    7.667449] Workqueue: events power_supply_changed_work
[    7.673034] [<c0015c28>] (unwind_backtrace+0x0/0xe0) from [<c0011e1c>] (=
show_stack+0x10/0x14)
[    7.682098] [<c0011e1c>] (show_stack+0x10/0x14) from [<c052cdd0>] (dump_=
stack+0x78/0xac)
[    7.690704] [<c052cdd0>] (dump_stack+0x78/0xac) from [<c052a044>] (__sch=
edule_bug+0x48/0x60)
[    7.699645] [<c052a044>] (__schedule_bug+0x48/0x60) from [<c053071c>] (_=
_schedule+0x74/0x638)
[    7.708618] [<c053071c>] (__schedule+0x74/0x638) from [<c05301fc>] (sche=
dule_timeout+0x1dc/0x24c)
[    7.718017] [<c05301fc>] (schedule_timeout+0x1dc/0x24c) from [<c05316ec>=
] (wait_for_common+0x138/0x17c)
[    7.727966] [<c05316ec>] (wait_for_common+0x138/0x17c) from [<c0362a70>]=
 (omap_i2c_xfer+0x340/0x4a0)
[    7.737640] [<c0362a70>] (omap_i2c_xfer+0x340/0x4a0) from [<c035d928>] (=
__i2c_transfer+0x40/0x74)
[    7.747039] [<c035d928>] (__i2c_transfer+0x40/0x74) from [<c035e22c>] (i=
2c_transfer+0x6c/0x90)
[    7.756195] [<c035e22c>] (i2c_transfer+0x6c/0x90) from [<c037ad24>] (bq2=
415x_i2c_write+0x48/0x78)
[    7.765563] [<c037ad24>] (bq2415x_i2c_write+0x48/0x78) from [<c037ae60>]=
 (bq2415x_set_weak_battery_voltage+0x4c/0x50)
[    7.776824] [<c037ae60>] (bq2415x_set_weak_battery_voltage+0x4c/0x50) fr=
om [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c)
[    7.788085] [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c) from [<c037bfb8>]=
 (bq2415x_notifier_call+0xa8/0xb4)
[    7.798309] [<c037bfb8>] (bq2415x_notifier_call+0xa8/0xb4) from [<c005f2=
28>] (notifier_call_chain+0x38/0x68)
[    7.808715] [<c005f228>] (notifier_call_chain+0x38/0x68) from [<c005f284=
>] (__atomic_notifier_call_chain+0x2c/0x3c)
[    7.819732] [<c005f284>] (__atomic_notifier_call_chain+0x2c/0x3c) from [=
<c005f2a8>] (atomic_notifier_call_chain+0x14/0x18)
[    7.831420] [<c005f2a8>] (atomic_notifier_call_chain+0x14/0x18) from [<c=
0378078>] (power_supply_changed_work+0x6c/0xb8)
[    7.842864] [<c0378078>] (power_supply_changed_work+0x6c/0xb8) from [<c0=
0556c0>] (process_one_work+0x248/0x440)
[    7.853546] [<c00556c0>] (process_one_work+0x248/0x440) from [<c0055d6c>=
] (worker_thread+0x208/0x350)
[    7.863372] [<c0055d6c>] (worker_thread+0x208/0x350) from [<c005b0ac>] (=
kthread+0xc8/0xdc)
[    7.872131] [<c005b0ac>] (kthread+0xc8/0xdc) from [<c000e138>] (ret_from=
_fork+0x14/0x3c)

-- Sebastian

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS3DtpAAoJENju1/PIO/qalFUP/jivDr2V3R/jRgVC3n+dywTi
0BbiqhF3To6PxH106RUmtdEh8RAuOMgVeug4UfVxqjnx3twB8oPbrZEYwg84Ss3L
UyvD0d9DaVOcnoq1GZAwZoo/AdyD11h+iJB6hydlBgIc6aDzYGhSjDPP5VF6bGtR
N5R7vG67a6fRqcQbfW1/2LNz/d9EuF//m2bvzIxrNPLLE9Nbke9bm7N+f9J3cO8P
L2TCTI7vjdf7HBPZgOxWZ2PZyiFxdsHPc0iWYB55hcwZUz/i+5EMoW8oxCA4bpun
fMBrduQ+cgogajnch/bY9TNPMDbvXL0ZbMBw8LaVCEJ4ynG5I4c5Bfzjt6JwSr+I
pCa8vQShy/8fFVJNKPY2ZTV2/1L+BOEEvYNoarYdSnHkIrDdAlwX/X4GQMvrK4F3
9niDHrkTHWiNcquCRcgQGMS+6VCnyOlUKgSbldc1FiYO6NiZS7UhIi9/ZTr540YB
joNwoCAL0DI9qI/i+/JvukuXtZ84RsV34c+1bGo8kAN4ho33lGzJNM0uZlSJejFR
1kG9/ohJ+ENhRNWMe/GuBoXmg5EK3bziNrtKNhsvE7vooPDvZb0EV2ezcL9ZgFnZ
ioBkymkVjFxia0+Eg/DpgbCQvNmIsQ4+9CExS139Upx3AJ/HC4jLaaGJVolsG1GX
TVlZryUCRZUWTMTN7Bdc
=5N5F
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
