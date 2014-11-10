Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaKJIZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:25:23 -0500
Received: from mout.web.de ([212.227.17.11]:59842 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaKJIZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:25:22 -0500
Message-ID: <5460766B.8070000@web.de>
Date: Mon, 10 Nov 2014 09:25:15 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: AMR: sun7i: CPU hotplug support?
References: <545FC215.7010802@web.de> <20141109231744.GC2989@lukather> <5460554A.1060701@web.de>
In-Reply-To: <5460554A.1060701@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LNN8kg2J0CTvIxHUweE5Mo1oj34QutIhE"
X-Provags-ID: V03:K0:qJ/RnKAk2mbUMDS+vh2oY+iHd/pVmLQW0M6TSjiu/mHOpPBtwrf
 lyhrjj2P8unYxwB3E+rtctrOhqqXrvGUMHnmYfoGbphJwBnAZ4SkS5RHT66KO8DIT6o69mo
 fpgK1OCumamU21sBy96VHvPFXwYl4O7YfyMnSGeHO/b+MDiQH8FMbS/OIPetT/sE4sx9I5w
 gccXTUlh5aorQ9fWaY9Wg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LNN8kg2J0CTvIxHUweE5Mo1oj34QutIhE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2014-11-10 07:03, Jan Kiszka wrote:
> On 2014-11-10 00:17, Maxime Ripard wrote:
>> Hi Jan,
>>
>> On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka wrote:
>>> did anyone already happen to look into enabling CPU hotplug for the
>>> Allwinner A20 in upstream? I'm currently running the sunxi-next branc=
h
>>> on Banana Pi, and echo 0 > .../cpu1/online just hangs the system. The=

>>> old 3.4 LeMaker kernel works fine in this regard. I can try to look i=
nto
>>> details and port things over, just want to avoid duplicate efforts.
>>
>> Having hotplug support would indeed be very welcome.
>>
>> However, it should be done in u-boot, through PSCI, and not in the
>> kernel itself.
>>
>> As far as I'm aware, no one worked actively on it, beside some WIP
>> commit from Marc a while ago:
>> https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit/?h=3D=
wip/psci&id=3D45379c0f9cf812f0f62722f4015ec907fa5dc144
>=20
> OK - I guess I will need a little guidance in then: Is there a good
> reference board to study and to derive from? And maybe also: What is
> missing or not working in that u-boot branch? If I get this interface
> right, I just takes some device tree bits to enable this for the kernel=

> afterward, correct?

Started to play with that patch in naive ways: CPU0 locks up when
offlining CPU1 - unless I disable the FIQ signal from CPU1. Then it
"works", both offlining and onlining again. However, I suspect that this
only parks CPU1 in wfi and does not do anything interesting to it.

Jan



--LNN8kg2J0CTvIxHUweE5Mo1oj34QutIhE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlRgdmwACgkQitSsb3rl5xT/2gCg6J3vDw6Ztas4/j6cU5DolGs9
8sQAoMTJDwuuXUhdBdAz4vHph7gbp18k
=3t92
-----END PGP SIGNATURE-----

--LNN8kg2J0CTvIxHUweE5Mo1oj34QutIhE--
