Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaHFQT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:19:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaHFQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:19:56 -0400
Date: Wed, 6 Aug 2014 18:19:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: perf related boot hang.
Message-ID: <20140806161934.GF19379@twins.programming.kicks-ass.net>
References: <20140806143621.GA13832@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b4UDFpmFtQklTcoK"
Content-Disposition: inline
In-Reply-To: <20140806143621.GA13832@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b4UDFpmFtQklTcoK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 10:36:21AM -0400, Dave Jones wrote:
> On Linus current tree, when I cold-boot one of my boxes, it locks up
> during boot up with this trace..
>=20
> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
> CPU: 2 PID: 577 Comm: in:imjournal Not tainted 3.16.0+ #33
>  ffff880244c06c88 000000008b73013e ffff880244c06bf0 ffffffffb47ee207
>  ffffffffb4c51118 ffff880244c06c78 ffffffffb47ebcf8 0000000000000010
>  ffff880244c06c88 ffff880244c06c20 000000008b73013e 0000000000000000
> Call Trace:
>  <NMI>  [<ffffffffb47ee207>] dump_stack+0x4e/0x7a
>  [<ffffffffb47ebcf8>] panic+0xd4/0x207
>  [<ffffffffb4145448>] watchdog_overflow_callback+0x118/0x120
>  [<ffffffffb4186f0e>] __perf_event_overflow+0xae/0x350
>  [<ffffffffb4185380>] ? perf_event_task_disable+0xa0/0xa0
>  [<ffffffffb401a4ef>] ? x86_perf_event_set_period+0xbf/0x150
>  [<ffffffffb4187d34>] perf_event_overflow+0x14/0x20
>  [<ffffffffb40203a6>] intel_pmu_handle_irq+0x206/0x410
>  [<ffffffffb401939b>] perf_event_nmi_handler+0x2b/0x50
>  [<ffffffffb4007b72>] nmi_handle+0xd2/0x390
>  [<ffffffffb4007aa5>] ? nmi_handle+0x5/0x390
>  [<ffffffffb40d8301>] ? lock_acquired+0x131/0x450
>  [<ffffffffb4008062>] default_do_nmi+0x72/0x1c0
>=20
>=20
> If I reset it, it then seems to always boot up fine.

Uhm,. cute! And that's the entire stacktrace? It would seem to me there
would be at least a 'task' context below that. CPUs simply do not _only_
run NMI code, and that trace starts at default_do_nmi().



--b4UDFpmFtQklTcoK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4lWRAAoJEHZH4aRLwOS6458P/0Qt6u+HUzxxJAUagLgPT3xO
535XWe3nNlWDDzHlM9Vd9fBocXC8wl/1X19VaT2lCDEFcUKCyFgc/TJFis0Kwb/U
YV6d0Gp5BeRa+yaOH7hPvqpBynYWsLh4GbutYx8D0Udxku2vfX7bK3snGL2oO85A
uWOli/6NG4BEht5iVr0foyG1R3Uy/Ugik80udOasHhuhMbLyIaTuMCQiuREqBBM2
VDyG+XHG8tqgA9wrS8YRXqkohVzDSX7jZT7FIaZQrZDdSULvMeKuoBMPJUeSsMNo
xSgfLr7wTq3Xjp1R3tr/yFwmezwOi/geq3w8ZHG2vL+b6uYNLIlVkVgPrbYifa/L
xrs2rjcq1ROPcWM7CdgmL2TO82wKHMYmlaU5TGm/Bnx9NoWYg+eBIJD+zBxQ2Axp
P6TuVdCV/CPRzgwHGN8kl6MixmBIAehXLarCxPxRo2l5PcPpzm3Ryf3buP8QBwnU
elZxvedkcmn3FLKVHpZXlJpouV9waicykNB+rKRAbWYj4sJ7mZqhWlr+vF3+XOAG
vbZSsDi1QmnZf33OZDxLP2uZpvqnuTTjlMyfdhp0+3wzXv8r5YwGxTucP6Ses6WW
+T/cgjtYqOLPAAtagfxfq9JiK+mmsheG6EhtolJZEJpWzSHtUH6U7VEBUFG34cSz
Hd5bEXMkzRiGGUO6P6Ho
=LQ0O
-----END PGP SIGNATURE-----

--b4UDFpmFtQklTcoK--
