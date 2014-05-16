Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbaEPIo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:44:57 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35899 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbaEPIoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:44:54 -0400
Message-ID: <5375CFEC.6070008@monstr.eu>
Date: Fri, 16 May 2014 10:44:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Bart Tanghe <bart.tanghe@thomasmore.be>, michal.simek@xilinx.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <matt.porter@linaro.org>
Subject: Re: [rfc]pwm: add xilinx pwm driver
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be> <5049141.XmehsUeakV@wuerfel> <5374C773.6070402@monstr.eu> <16896948.U7hTsgDub4@wuerfel> <20140515204941.GB7136@mithrandir>
In-Reply-To: <20140515204941.GB7136@mithrandir>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oNpEpmClw9SQNoEwwAAJT4gnvquRAJgco"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oNpEpmClw9SQNoEwwAAJT4gnvquRAJgco
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/15/2014 10:49 PM, Thierry Reding wrote:
> On Thu, May 15, 2014 at 06:30:13PM +0200, Arnd Bergmann wrote:
>> On Thursday 15 May 2014 15:56:03 Michal Simek wrote:
>>> IP is configurable as is normal for us.
>>> You can select IP with just one timer.
>>> It means register locations for specific timer are fixed.
>>> http://www.xilinx.com/support/documentation/ip_documentation/xps_time=
r.pdf
>>>
>>> timer0 - offset 0x0
>>> timer1 - offset 0x10 (doesn't need to be synthesized)
>>>
>>> There is one interrupt for both timers.
>>>
>>> Timers can be as timers (up/down count/ reload with or without IRQs)
>>> But then one options is to use both timers and generate PWM signal.
>>> From full ip description in DT you can see xlnx,gen0-assert =3D <1>;
>>> which can suggest that this IP can output PMW signal.
>>> (We can also detect if PWM0 signal is connected just to be sure
>>> that PWM can be enabled).
>>>
>>> There is also capture trigger mode where external signal start/stop
>>> timer counting.
>>>
>>> It means there are 3 modes - timer, capture and PWM.
>>> Timer (clocksource, clockevent) requires specific handling,
>>> PWM has own subsystem and not sure if there is any subsystem for
>>> capture mode. Is there any?
>>
>> I don't think so. Possibly somewhere in IIO.
>=20
> I think so too. There was a patch set not so long ago that added PWM
> capture support for one of the TI PWM controllers to IIO.

It is probably this.
https://lwn.net/Articles/583998/
https://lkml.org/lkml/2014/2/5/378

There were some comments in v3 which haven't been fixed.
Matt: What's the status on this?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--oNpEpmClw9SQNoEwwAAJT4gnvquRAJgco
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlN1z/IACgkQykllyylKDCEGhwCaAktbn+VB6o1QuvXYMI8apUDy
k5EAoIfPdREPcAS0HnZjKjsU8If1NjWf
=wkuF
-----END PGP SIGNATURE-----

--oNpEpmClw9SQNoEwwAAJT4gnvquRAJgco--
