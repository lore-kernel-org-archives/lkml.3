Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaDYOD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:03:58 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49975 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaDYODx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:03:53 -0400
Message-ID: <535A6B45.40303@monstr.eu>
Date: Fri, 25 Apr 2014 16:03:49 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net> <53575074.6010602@monstr.eu> <5357C246.7050604@roeck-us.net> <5357CA6B.1070101@monstr.eu> <20140423154533.GA15644@roeck-us.net> <5358AC50.7020308@monstr.eu> <535913E1.70509@roeck-us.net> <535A0DD7.4080204@monstr.eu> <535A631F.5020208@roeck-us.net> <535A6873.9020404@roeck-us.net>
In-Reply-To: <535A6873.9020404@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eHjIlsWqeRwx4nDjh6Q0nDfnXJpnkEfwS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eHjIlsWqeRwx4nDjh6Q0nDfnXJpnkEfwS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/25/2014 03:51 PM, Guenter Roeck wrote:
> On 04/25/2014 06:29 AM, Guenter Roeck wrote:
>> On 04/25/2014 12:25 AM, Michal Simek wrote:
>> [ ... ]
>>
>>>
>>> It should be pretty easy to fix it in timer_write function like this.=

>>>
>>> diff --git a/hw/timer/xilinx_timer.c b/hw/timer/xilinx_timer.c
>>> index 6113b97..3ff1da9 100644
>>> --- a/hw/timer/xilinx_timer.c
>>> +++ b/hw/timer/xilinx_timer.c
>>> @@ -169,7 +169,7 @@ timer_write(void *opaque, hwaddr addr,
>>>               if (value & TCSR_TINT)
>>>                   value &=3D ~TCSR_TINT;
>>>
>>> -            xt->regs[addr] =3D value;
>>> +            xt->regs[addr] =3D value & 0x7ff;
>>>               if (value & TCSR_ENT)
>>>                   timer_enable(xt);
>>>               break;
>>>
>>
>> Hi Michal,
>>
>> that fixes endianness detection, but the image is still hanging.
>>
>> Here is the log:
>>
>> NR_IRQS:33
>> /plb@0/interrupt-controller@81800000: num_irq=3D4, edge=3D0xa
>> ERROR: CPU CCF input clock not found
>> Reading TCSR0 returned 0x0, expected 0x1
>> Switch to big endian mode
>> /plb@0/timer@83c00000: irq=3D1
>> ERROR: timer CCF input clock not found
>> ERROR: Using CPU clock frequency
>> xilinx_timer_set_mode: shutdown
>> xilinx_timer_set_mode: periodic
>> sched_clock: 32 bits at 62MHz, resolution 16ns, wraps every 6871947672=
0ns
>> Calibrating delay loop... QEMU: Terminated
>>
>> I added a couple of log messages to make sure that the mode is detecte=
d correctly.
>> Any idea what else might be wrong ?
>>
>=20
> Never mind, I found it. Same problem with interrupt handler.
> Can you give me the valid bit mask for intc_baseaddr + MER ?

yep :-) MER mask is just 0x3.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--eHjIlsWqeRwx4nDjh6Q0nDfnXJpnkEfwS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNaa0UACgkQykllyylKDCHqVgCgkZhtT4o2MjvFYYSsPbjo/pHb
E/YAn3Xu/48P+KATGO+IivjdjMqHdX3J
=YjEd
-----END PGP SIGNATURE-----

--eHjIlsWqeRwx4nDjh6Q0nDfnXJpnkEfwS--
