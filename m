Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaKYLjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:39:35 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:28087 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754341AbaKYLjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:39:32 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Tue, 25 Nov 2014 11:39:30 +0000
Message-ID: <54746A6B.1050702@imgtec.com>
Date: Tue, 25 Nov 2014 11:39:23 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Mike Turquette <mturquette@linaro.org>, <linux-metag@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>
Subject: Re: [PATCH 15/15] metag: tz1090: add TZ1090 clocks to device tree
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com> <2363265.Y6kZ4TuTy5@diego> <20141121100647.GF12456@jhogan-linux.le.imgtec.org> <5932816.ccTTaBqqIv@diego>
In-Reply-To: <5932816.ccTTaBqqIv@diego>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="lQhkCjV6btr5sI6pNnfL3iMC7EFUQDwXl"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: 5935c8df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lQhkCjV6btr5sI6pNnfL3iMC7EFUQDwXl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24/11/14 23:03, Heiko St=FCbner wrote:
> Am Freitag, 21. November 2014, 10:06:47 schrieb James Hogan:
>> On Thu, Nov 20, 2014 at 01:56:24PM +0100, Heiko St=FCbner wrote:
>>> I don't know enough about your clock structure, but it looks quite a =
bit
>>> like Mike's mail from May [0] may apply here too.
>>>
>>> The register layout also suggests that it is indeed one clock ip-bloc=
k:
>>>
>>> 0x02005908 0x4	CR_TOP_CLKSWITCH
>>> 0x0200590c 0x4	CR_TOP_CLKENAB
>>> 0x02005950 0x4	CR_TOP_SYSPLL_CTL0
>>> 0x02005954 0x4	CR_TOP_SYSPLL_CTL1
>>> 0x02005988 0x4	CR_TOP_CLKSWITCH2
>>> 0x0200598c 0x4	CR_TOP_CLKENAB2
>>> ...
>>>
>>>
>>> [0] https://lkml.org/lkml/2014/5/14/715
>>
>> Thanks, that does make sense. It's probably more like 4 memory regions=

>> ("top" level, "perip" peripheral registers, "hep" high end peripheral
>> registers, and "pdc" powerdown controller registers), but it could
>> certainly still have a single binding with multiple memory regions to
>> simplify the clock specifiers.
>=20
> It could also make sense to have 4 clock controller nodes for those. I =
guess=20
> it all depends on how the hardware is layed out.
>=20
> For example on Rockchip SoCs, all of this is contained in the "APB CRU"=
 (Clock=20
> and Reset Unit) with a memory region of <0x20000000 0x4000> - so here o=
ne=20

/me twigs what CRU stands for!

> hardware-block that contains all the clocks and also the reset controll=
er.
>=20
> On the other hand it might very well be more than one ip-block on your =

> platform.=20
>=20
> So I guess it comes down to looking at the memory map [or documentation=
 :-) ]=20
> to determine how many ip blocks there really are.

I'll probably combine the TOP and HEP ones at least. HEP clock stuff is
much simpler than TOP, and a couple of clocks feed both ways between
them which otherwise wouldn't need to be visible, suggesting they're
pretty closely coupled.

PERIP is pretty much a single bank of 14 system clock gates for
individual peripherals, so that one's arguable. I'll probably separate
it as there's only 1 input clock so it wouldn't be at all messy.

PDC is pretty independent and can remain mostly unchanged (that is
consistent with irq, pinctrl and gpio drivers too, where PDC low power
stuff is independent and fits nicely into separate drivers).

Thanks for the suggestions!

James


--lQhkCjV6btr5sI6pNnfL3iMC7EFUQDwXl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUdGpxAAoJEGwLaZPeOHZ6YUAP/3fjFLwSV9ttveY/1tOWe6lp
T5O8Ktns9V6U4rBrmiJYRSYUsCpUU98Q9EFJBBEufBP7WfOPp61q1Hu4vucDVAWI
2EreVVzX+Frtd9nCldyBghfbsLz0CMC2BQgJsyRqzP5mwCAc6GLcGX5fA8BsBpy/
seBj8w+aPE8bPacES8Y+9qc6rMQLcVZbJstUQduTy67TWcy2KkNidcHP2ANqohal
JvkdCkUN+3qYXo72Bq8URMXwapBBFyh10xbyLXw+Rbv34BTxUR4Y5uTa+m05w4wM
XB8MmKDYOVPbCUcXbTRfykPX0/hfKP9BwNcdtaHYWX9M8Tleih2SyXKJsMyMWbor
2yGt2gOTcHnAuZ/l0zRq0L/SYEFOMNCWwP1WJfne6jFcDf6fYFv+v5ErYLi+lYSi
KTVNgEpbyzMBT4yBNT7EAGMiL0Nb/nr1XMKViXEnabpL72WGi0jbCY7YYGnmgAEK
L7UMPmZKa1CPTkJ/yy2COI0x5qBF3vkuBqF1dt4kRfVmWPZoTKQ54Hv04Dewu7GQ
KrRizRyCKXeMbueBpwG5tmulscW92tSij5GYIaF2LMP1+aC+GJcMOhcEAmtjzv1D
+Hmf+cvBpTrhyfgMdY7V9Ccz9Ih3AeJmEwFEtmxbQUlGcr6c5uo/92l5L56kf8+O
ijvaPlC4kvWe4eH7grpC
=wtYx
-----END PGP SIGNATURE-----

--lQhkCjV6btr5sI6pNnfL3iMC7EFUQDwXl--
