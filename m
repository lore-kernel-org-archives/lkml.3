Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3FZVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:34:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46765 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3FZVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:34:48 -0400
Date: Wed, 26 Jun 2013 23:34:44 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: Re: [PATCH v2] pwm: pwm-tiehrpwm: Use clk_enable/disable instead
 clk_prepare/unprepare.
Message-ID: <20130626213443.GB29479@manwe>
References: <1372250285-11709-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <1372250285-11709-1-git-send-email-marek.belisko@streamunlimited.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 02:38:04PM +0200, Marek Belisko wrote:
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
>=20
> Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
> ---
>=20
> changes from v1:
> - add clk_unprepare() to .remove callback +
> add it also to error handling when probe fails
>=20
>  drivers/pwm/pwm-tiehrpwm.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Applied, thanks.

Thierry

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRy15zAAoJEN0jrNd/PrOh8RMQAMFzfuEt6DujSMJLt5FE5Zz9
5hF6awbAzxV/QnnDZ/lNbyqS/sPxUTExncF09Sgcdeog9z8PMAhpuwVQ3rKRU7x1
9MKMkVutiMjyzfT7a6ntT/j7SYvSkA9FB5zoQMQkdCr2OxjCLlffaqzLPdEDwVDC
Q49PP+psK0EkjEh6DhhcDyxtXgnSJCWOSmQa0CzqWBEjJd1jHwTq3qIz8TYVmL6Q
/5oBbW0j+wLPg9zrgJ0YBmQNMvlQPUsWikYWixjQtI++heiEl0jTah1oZVMjJY0w
sMFNqR1SY+AmV1tofD83yS6hzQJSV6/wvYsq5//Ti6ejDC8zSJtXSyOO6Ief2rfY
NfaorHpv8GAiaCgN5fsambb+lmEXdYyFFuXBcp7uqhw0zlE3gPq7MNa9bG7Uqxz+
Zv4bPe3brkt+rIroOV9eKQkpSi75yD9GqdATMqKlSeynM+KJkP/MGc0GZaCJVD0O
WfEzbpVXwzf6Gz8AG/UL/fi9mZ6MnPskS8wjwSYND4Len+MFrbDEnVSkxegLJi5l
2NkcluYUsmx+GEJoEy8s/co8FDr06B6pWdBcSv1H5aQaZvs8S0gt64amu6e3HZOY
N9XxmYjeL0530ZJxkJRfWb52bxcDw15c+z4oqhwCpNzn2cvyifIIpMb0pYqMF7F2
XCt+oOvivpmXB0DFdyKx
=0cCE
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
