Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3FUJnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:43:18 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61611 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3FUJnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:43:16 -0400
Date: Fri, 21 Jun 2013 11:43:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: Re: [PATCH] pwm: pwm-tiehrpwm: Use clk_enable/disable instead
 clk_prepare/unprepare.
Message-ID: <20130621094310.GA12441@manwe>
References: <1371556313-6776-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1371556313-6776-1-git-send-email-marek.belisko@streamunlimited.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 01:51:53PM +0200, Marek Belisko wrote:
> This was found when using pwm-led on am33xx and enable
> heartbeat trigger.
>=20
> [  808.624876] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  808.629443] [ INFO: inconsistent lock state ]
> [  808.634021] 3.9.0 #2 Not tainted
> [  808.637415] ---------------------------------
> [  808.641981] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> [  808.648288] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> [  808.653494]  (prepare_lock){+.?.+.}, at: [<c027c211>] clk_unprepare+0x=
15/0x24
> [  808.661040] {SOFTIRQ-ON-W} state was registered at:
> [  808.666155]   [<c004ec4d>] __lock_acquire+0x411/0x824
> [  808.671465]   [<c004f359>] lock_acquire+0x41/0x50
> [  808.676412]   [<c039ee9d>] mutex_lock_nested+0x31/0x1d8
> [  808.681912]   [<c027c275>] clk_prepare+0x15/0x28
> [  808.686764]   [<c0590c6b>] _init+0x117/0x1e0
> [  808.691256]   [<c0019ef9>] omap_hwmod_for_each+0x29/0x3c
> [  808.696842]   [<c0591107>] __omap_hwmod_setup_all+0x17/0x2c
> [  808.702696]   [<c0008653>] do_one_initcall+0xc3/0x10c
> [  808.708017]   [<c058a627>] kernel_init_freeable+0xa7/0x134
> [  808.713778]   [<c039a543>] kernel_init+0x7/0x98
> [  808.718544]   [<c000cd95>] ret_from_fork+0x11/0x3c
> [  808.723583] irq event stamp: 1379172
> [  808.727328] hardirqs last  enabled at (1379172): [<c03a0759>] _raw_spi=
n_unlock_irqrestore+0x21/0x30
> [  808.736828] hardirqs last disabled at (1379171): [<c03a03c3>] _raw_spi=
n_lock_irqsave+0x13/0x38
> [  808.745876] softirqs last  enabled at (1379164): [<c002ae5d>] irq_ente=
r+0x49/0x4c
> [  808.753747] softirqs last disabled at (1379165): [<c002aec3>] irq_exit=
+0x63/0x88
> [  808.761518]
> [  808.761518] other info that might help us debug this:
> [  808.768373]  Possible unsafe locking scenario:
> [  808.768373]
> [  808.774578]        CPU0
> [  808.777141]        ----
> [  808.779705]   lock(prepare_lock);
> [  808.783186]   <Interrupt>
> [  808.785929]     lock(prepare_lock);
> [  808.789595]
> [  808.789595]  *** DEADLOCK ***
> [  808.789595]
> [  808.795805] 1 lock held by swapper/0:
> [  808.799643]  #0:  (((&heartbeat_data->timer))){+.-...}, at: [<c002e204=
>] call_timer_fn+0x0/0x90
> [  808.808814]
> [  808.808814] stack backtrace:
> [  808.813402] [<c000ff19>] (unwind_backtrace+0x1/0x98) from [<c039bd75>]=
 (print_usage_bug.part.25+0x16d/0x1cc)
> [  808.823721] [<c039bd75>] (print_usage_bug.part.25+0x16d/0x1cc) from [<=
c004e595>] (mark_lock+0x18d/0x434)
> [  808.833669] [<c004e595>] (mark_lock+0x18d/0x434) from [<c004ec1d>] (__=
lock_acquire+0x3e1/0x824)
> [  808.842803] [<c004ec1d>] (__lock_acquire+0x3e1/0x824) from [<c004f359>=
] (lock_acquire+0x41/0x50)
> [  808.852031] [<c004f359>] (lock_acquire+0x41/0x50) from [<c039ee9d>] (m=
utex_lock_nested+0x31/0x1d8)
> [  808.861433] [<c039ee9d>] (mutex_lock_nested+0x31/0x1d8) from [<c027c21=
1>] (clk_unprepare+0x15/0x24)
> [  808.870930] [<c027c211>] (clk_unprepare+0x15/0x24) from [<c019f7bf>] (=
ehrpwm_pwm_disable+0x5f/0x80)
> [  808.880431] [<c019f7bf>] (ehrpwm_pwm_disable+0x5f/0x80) from [<c019f29=
f>] (pwm_disable+0x27/0x28)
> [  808.889751] [<c019f29f>] (pwm_disable+0x27/0x28) from [<c026f8f3>] (le=
d_heartbeat_function+0x3f/0xb0)
> [  808.899431] [<c026f8f3>] (led_heartbeat_function+0x3f/0xb0) from [<c00=
2e249>] (call_timer_fn+0x45/0x90)
> [  808.909288] [<c002e249>] (call_timer_fn+0x45/0x90) from [<c002e399>] (=
run_timer_softirq+0x105/0x17c)
> [  808.918884] [<c002e399>] (run_timer_softirq+0x105/0x17c) from [<c002ab=
c5>] (__do_softirq+0xa5/0x150)
> [  808.928486] [<c002abc5>] (__do_softirq+0xa5/0x150) from [<c002aec3>] (=
irq_exit+0x63/0x88)
> [  808.937098] [<c002aec3>] (irq_exit+0x63/0x88) from [<c000d599>] (handl=
e_IRQ+0x21/0x54)
> [  808.945415] [<c000d599>] (handle_IRQ+0x21/0x54) from [<c0008495>] (oma=
p3_intc_handle_irq+0x5d/0x68)
> [  808.954900] [<c0008495>] (omap3_intc_handle_irq+0x5d/0x68) from [<c000=
c7ff>] (__irq_svc+0x3f/0x64)
> [  808.964287] Exception stack(0xc05b1f68 to 0xc05b1fb0)
> [  808.969587] 1f60:                   00000001 00000001 00000000 0000000=
0 c05b0000 c0619748
> [  808.978158] 1f80: c05b0000 c05b0000 c0619748 413fc082 00000000 0000000=
0 01000000 c05b1fb0
> [  808.986719] 1fa0: c004f989 c000d6f0 400f0033 ffffffff
> [  808.992024] [<c000c7ff>] (__irq_svc+0x3f/0x64) from [<c000d6f0>] (cpu_=
idle+0x60/0x98)
> [  809.000250] [<c000d6f0>] (cpu_idle+0x60/0x98) from [<c058a535>] (start=
_kernel+0x1e9/0x234)
>=20
> Remove non atomic clk api calls and use only atomic for enable/disable be=
cause
> can be called from atomic context (led_heartbeat_function is timer callba=
ck).

This raises a fundamental question. The PWM subsystem can't make any
guarantees as to whether pwm_enable() or pwm_disable() can be used in
atomic contexts. Consider for example the TWL or PCA drivers. Because
they are accessed via an I2C bus, enabling a PWM that they provide will
always sleep. Note that PWM client drivers can query whether or not the
PWM functions may sleep using pwm_can_sleep().

I think this patch is still valid, though, it just isn't solving the
problem completely. One additional comment below.

[...]
> @@ -487,6 +487,12 @@ static int ehrpwm_pwm_probe(struct platform_device *=
pdev)
>  		return PTR_ERR(pc->tbclk);
>  	}
> =20
> +	ret =3D clk_prepare(pc->tbclk);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "clk_prepare() failed: %d\n", ret);
> +		return ret;
> +	}

Shouldn't this have a corresponding clk_unprepare() in .remove()?

And please use my new email address and Cc the linux-pwm mailing list
for PWM patches. MAINTAINERS in linux-next is up-to-date.

Thierry

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxCAuAAoJEN0jrNd/PrOhvoMQALJxwbTLvG2LvARVDkYXyDu5
sfZikmN0vXctfs6oty1+VdgcTxPjb4kRJIDoGtsFmY7Gn8in4PWwXDAfkzhlOubj
xbd1w2Gai1dieFpH1TrUPpQigoBR80A1n7CWHQ2cSvY30THS0DzVhPJdZVdnhlRj
/7SXkyPV722Ramr8iiGn0C9MiXNWFIXsv6ruXvMANZuuql+IeVSF2F5H62YrsYZ7
hJFvsiiIJ7jajbiC+tY680T40k5abKMT52v/ALwpb1tUk+lsyUBMEfnCPFSPcjZ6
Uelth4p1Iyvm/RSIX7YOjaS5q+g57MvuuIWIqNb9dtKv48h1pGixQEO9ItUoh+od
wQtY3c6dA2YhtAF77kI0E4vFPd2z3o+WZA7obNgtCpZXRD3Z5PzdodkDIIVg8y7f
M3qlSjiBq2ncGB4oYLGs6ym4mvUo5JzThtnKUGyYwgJdx7iWYLnHkUNCBB3XLTOR
gJgKUBOB1DjeawRDGnkE16ndLXUCJmiyWTJIykWIF9L+UZ1gBIRHSdhUE570qpbR
gnnna5nThJJzJjYTwbvORYtWVZ+85dvQowPHwYE78VXegZeUB5Z3dLZe74lg358c
MwVLTOF7y20xbyrt42dprZ9IJ192IvWBosPNlhQVoBFmQTJXU6J6jKbbfj3e0zS1
vjnpmMLGwa/J85fAokEo
=gRyT
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
