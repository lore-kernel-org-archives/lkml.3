Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3HZPOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:14:37 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49028 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3HZPOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:14:35 -0400
Message-ID: <521B70D1.5090506@monstr.eu>
Date: Mon, 26 Aug 2013 17:14:25 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Michal Simek <monstr@monstr.eu>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com> <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local> <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local> <20130823073250.GB30135@pengutronix.de> <521B38BF.6040400@monstr.eu> <20130826120716.GB24795@pengutronix.de> <521B4FCF.5000904@gmail.com>
In-Reply-To: <521B4FCF.5000904@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0KKB1mHb4X7rb0S8Wa4GX6Ae3VqLxC0SK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0KKB1mHb4X7rb0S8Wa4GX6Ae3VqLxC0SK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/26/2013 02:53 PM, Sebastian Hesselbarth wrote:
> On 08/26/13 14:07, Steffen Trumtrar wrote:
>> On Mon, Aug 26, 2013 at 01:15:11PM +0200, Michal Simek wrote:
>>> I agree with Soren - let's fix the current problem and then when Stef=
fen has patches with syscon
>>> we can look at them.
>>>
>>> If there is any discussion about early syscon registration please let=
 me know.
>>>
>>
>> Where I'm stuck at the moment is: if I map the whole register space to=
 the
>> parent node, how do I get its mapped address in the clkc?
>=20
> Steffen,
>=20
> if slcr is such an essential part of the SoC, you can choose to provide=

> zynq_slcr_readl/writel callbacks. You can then use those callback in th=
e
> clock driver without knowing the base address. Also, it allows you to
> hide slcr specific locking details from subsequent drivers using the
> callbacks.

I don't think this will help. What you need to call in the clk driver is
regmap_read/regmap_write but you can call it when syscon/regmap driver
is initialized.

Steffen: Can you point me to that floading patches? If they are useful
we can try them and help with pushing them to the mainline.
I don't think that there is any reasonable solution without using these
patches.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--0KKB1mHb4X7rb0S8Wa4GX6Ae3VqLxC0SK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIbcNIACgkQykllyylKDCGjsQCcDy72TVEVbiz2sFU74qAPWm4k
C6YAnjdOvfYlSDY6YnLFtpDUKjPdkNfR
=7Rm/
-----END PGP SIGNATURE-----

--0KKB1mHb4X7rb0S8Wa4GX6Ae3VqLxC0SK--
