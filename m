Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaCFDnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 22:43:16 -0500
Received: from ring0.de ([5.45.105.125]:49935 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaCFDnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 22:43:15 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 6 Mar 2014 04:43:08 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] bq2415x_charger: Fix Atomic Sleep Bug
Message-ID: <20140306034308.GA31802@earth.universe>
References: <CAHYPw2HwArH2bYof6iQd8CTJqcoBU-Z4fS4F+tipYvN73-C0xQ@mail.gmail.com>
 <1393278197-27286-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1393278197-27286-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Mon, Feb 24, 2014 at 10:43:17PM +0100, Sebastian Reichel wrote:
> Move sysfs_notify and i2c_transfer calls from bq2415x_notifier_call
> to bq2415x_timer_work to avoid sleeping in atomic context.
>=20
> This fixes the following bug:
>=20
> [ 7.667449] Workqueue: events power_supply_changed_work
> [ 7.673034] [<c0015c28>] (unwind_backtrace+0x0/0xe0) from [<c0011e1c>] (s=
how_stack+0x10/0x14)
> [ 7.682098] [<c0011e1c>] (show_stack+0x10/0x14) from [<c052cdd0>] (dump_s=
tack+0x78/0xac)
> [ 7.690704] [<c052cdd0>] (dump_stack+0x78/0xac) from [<c052a044>] (__sche=
dule_bug+0x48/0x60)
> [ 7.699645] [<c052a044>] (__schedule_bug+0x48/0x60) from [<c053071c>] (__=
schedule+0x74/0x638)
> [ 7.708618] [<c053071c>] (__schedule+0x74/0x638) from [<c05301fc>] (sched=
ule_timeout+0x1dc/0x24c)
> [ 7.718017] [<c05301fc>] (schedule_timeout+0x1dc/0x24c) from [<c05316ec>]=
 (wait_for_common+0x138/0x17c)
> [ 7.727966] [<c05316ec>] (wait_for_common+0x138/0x17c) from [<c0362a70>] =
(omap_i2c_xfer+0x340/0x4a0)
> [ 7.737640] [<c0362a70>] (omap_i2c_xfer+0x340/0x4a0) from [<c035d928>] (_=
_i2c_transfer+0x40/0x74)
> [ 7.747039] [<c035d928>] (__i2c_transfer+0x40/0x74) from [<c035e22c>] (i2=
c_transfer+0x6c/0x90)
> [ 7.756195] [<c035e22c>] (i2c_transfer+0x6c/0x90) from [<c037ad24>] (bq24=
15x_i2c_write+0x48/0x78)
> [ 7.765563] [<c037ad24>] (bq2415x_i2c_write+0x48/0x78) from [<c037ae60>] =
(bq2415x_set_weak_battery_voltage+0x4c/0x50)
> [ 7.776824] [<c037ae60>] (bq2415x_set_weak_battery_voltage+0x4c/0x50) fro=
m [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c)
> [ 7.788085] [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c) from [<c037bfb8>] =
(bq2415x_notifier_call+0xa8/0xb4)
> [ 7.798309] [<c037bfb8>] (bq2415x_notifier_call+0xa8/0xb4) from [<c005f22=
8>] (notifier_call_chain+0x38/0x68)
> [ 7.808715] [<c005f228>] (notifier_call_chain+0x38/0x68) from [<c005f284>=
] (__atomic_notifier_call_chain+0x2c/0x3c)
> [ 7.819732] [<c005f284>] (__atomic_notifier_call_chain+0x2c/0x3c) from [<=
c005f2a8>] (atomic_notifier_call_chain+0x14/0x18)
> [ 7.831420] [<c005f2a8>] (atomic_notifier_call_chain+0x14/0x18) from [<c0=
378078>] (power_supply_changed_work+0x6c/0xb8)
> [ 7.842864] [<c0378078>] (power_supply_changed_work+0x6c/0xb8) from [<c00=
556c0>] (process_one_work+0x248/0x440)
> [ 7.853546] [<c00556c0>] (process_one_work+0x248/0x440) from [<c0055d6c>]=
 (worker_thread+0x208/0x350)
> [ 7.863372] [<c0055d6c>] (worker_thread+0x208/0x350) from [<c005b0ac>] (k=
thread+0xc8/0xdc)
> [ 7.872131] [<c005b0ac>] (kthread+0xc8/0xdc) from [<c000e138>] (ret_from_=
fork+0x14/0x3c)

Can you please queue this for 3.14-rc? The bug is really annoying, a
regression and should be fixed ASAP.

-- Sebastian

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTF+7MAAoJENju1/PIO/qaMREP/2GeWdFW3nn4t7vH6nanwfRG
TJjYSLy5T4neo6cYTAgLUFYOoR8Uiz92qUt6d2hmjY0Z0pYK8GztpnHAc56uxAQ6
D3ye+U+7WdjSoj760wQv+xJeALOVWMmOdqMitYoF3UXRVt519btROIvBf40oLmY5
6iXJ0KOLMtwzuN0L/XIlly1g2HOwZsZThVBrhg3b9qDD8PGWvqvUEmHMAF+INMWb
DH/JwGb5gKzF4zia0hWGpbAQ3u/Zh+DB5J1fkPVxnEFHX5MROU57NPzGJwbUhMSw
RuPsCP6c2a3BKEPC+V69zp2nXf+5ZfNcfqiVqFnfQJEZt9Voie84LU64BD8LxzM9
p7aMKLMMoKrww87pQKGZWUqOiLkz/9umnCsHn7AniFlXYb0/63ogjZbgVnGX6jyo
1g1I+kmOiGzMUigp1SGFHqQ2r50OJ84SxU8fyOP7YWsUBUH2/4v6v9WhK88ea2vj
oLo3U02uh+HlpsMwsRA7TeKtoJSspFt7p/8agoCbCI9xsMPqufmWTjo81p66+S9g
DVcAxhDXVtlUxZZnL34Eq1MD3iKBFRbn3sRbOiRuUITiCRBz1/DPO00Q8GHzhwyH
9GbzpyUnl2xhuaM1rMk+VS92nwfPE2IquxKWUcqjSRUF4BKolq+SvPaMl6+LtPS5
rg2OJODD1d9Fu88nvfwI
=wyac
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
