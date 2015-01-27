Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbbA0Ivp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:51:45 -0500
Received: from mout.gmx.net ([212.227.15.19]:53298 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbbA0Ivj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:51:39 -0500
Message-ID: <54C75184.7030507@rempel-privat.de>
Date: Tue, 27 Jan 2015 09:51:16 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH] ARM: clocksource: fix compile of asm9260_timer driver
 on ARCH=parisc
References: <54BE5E9A.8070502@linaro.org> <1422343624-9764-1-git-send-email-linux@rempel-privat.de> <54C75126.5070905@linaro.org>
In-Reply-To: <54C75126.5070905@linaro.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uPhHkTLm0uWsKs6wENA3hXb250wpLXKnP"
X-Provags-ID: V03:K0:9VHLR4+o9v97juUV2WSKeC8dDEePVkTEqs3fHLGoTC3QIdp4fPR
 blsx5rhQ15dDcGv7KKZeSZaqhfqb2VjHjkjBpkZxvNB2A3kxz4yy3wFF9ld8Dka4lbJpLRz
 R0NU+FcWLBhYT+BblZb0Su+1iVki3egvalP6pH5PcR6a311mDOxkKYTK2FPJ/skR+GYXRi6
 lbSaUVvuaqv4PG4KEni2Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uPhHkTLm0uWsKs6wENA3hXb250wpLXKnP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 27.01.2015 um 09:49 schrieb Daniel Lezcano:
> On 01/27/2015 08:27 AM, Oleksij Rempel wrote:
>> make sure this driver depends on GENERIC_CLOCKEVENTS
>>
>> compiler error was found by kbuild test robot:
>>
>>>> drivers/clocksource/asm9260_timer.c:114:14: warning: its scope is
>>>> only this definition or declaration, which is probably not what you
>>>> want
>>>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'struct
>>>> clock_event_device' declared inside parameter list
>>              struct clock_event_device *evt)
>>
>>>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'enum
>>>> clock_event_mode' declared inside parameter list
>>>> drivers/clocksource/asm9260_timer.c:123:58: error: parameter 1
>>>> ('mode') has incomplete type
>>      static void asm9260_timer_set_mode(enum clock_event_mode mode,
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>=20
> I would like to fold this patch with the asm9260 timer patch in order t=
o
> prevent git bisecting breakage. Ok for you ?

Ok, no problem.

>> ---
>>   drivers/clocksource/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig=

>> index 13b8152..bfaaae4 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -231,6 +231,7 @@ config CLKSRC_MIPS_GIC
>>
>>   config ASM9260_TIMER
>>       bool "Alphascale ASM9260 timer driver"
>> +    depends on GENERIC_CLOCKEVENTS
>>       select CLKSRC_MMIO
>>       select CLKSRC_OF
>>       default y if MACH_ASM9260
>>
>=20
>=20


--=20
Regards,
Oleksij


--uPhHkTLm0uWsKs6wENA3hXb250wpLXKnP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlTHUYQACgkQHwImuRkmbWmF1QEAk7RA8gFB2p/FamYTROnvnq97
of21cs8/Z4uqKGroJr4A/3n+nneaJIXnavWIMvCPvidfNY5Uw04wHlrbFvjUjtfW
=SL9b
-----END PGP SIGNATURE-----

--uPhHkTLm0uWsKs6wENA3hXb250wpLXKnP--
