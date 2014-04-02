Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbaDBF4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:56:19 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53703 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbaDBF4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:56:16 -0400
Message-ID: <533BA67B.6070905@monstr.eu>
Date: Wed, 02 Apr 2014 07:56:11 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Harini Katakam <harinikatakamlinux@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        michals@xilinx.com, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/2] GPIO: Add driver for Zynq GPIO controller
References: <1395933906-2268-1-git-send-email-harinik@xilinx.com> <CACRpkdbU35xG1QtagB+9e9vxvehf1UQFaF4PikJhsPNAMw=D1Q@mail.gmail.com> <CAFcVECJsEp_s2V5=oK_UJahGRUpWYWMCxTMxqdpX+O0qebP41A@mail.gmail.com> <CACRpkdZEFsJubRVwCp6nTie7s7+DZOym6SWsA2ZynN_devi-2Q@mail.gmail.com>
In-Reply-To: <CACRpkdZEFsJubRVwCp6nTie7s7+DZOym6SWsA2ZynN_devi-2Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="r2KnN0hcoO0hcQAeq1QDjdmSoPJFmgSJH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r2KnN0hcoO0hcQAeq1QDjdmSoPJFmgSJH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On 03/31/2014 10:22 AM, Linus Walleij wrote:
> On Sat, Mar 29, 2014 at 5:44 AM, Harini Katakam
> <harinikatakamlinux@gmail.com> wrote:
>> On Sat, Mar 29, 2014 at 3:20 AM, Linus Walleij <linus.walleij@linaro.o=
rg> wrote:
>>> On Thu, Mar 27, 2014 at 4:25 PM, Harini Katakam <harinik@xilinx.com> =
wrote:
>=20
>>>> +/* Read/Write access to the GPIO PS registers */
>>>> +static inline u32 zynq_gpio_readreg(void __iomem *offset)
>>>> +{
>>>> +       return readl_relaxed(offset);
>>>> +}
>>>> +
>>>> +static inline void zynq_gpio_writereg(void __iomem *offset, u32 val=
)
>>>> +{
>>>> +       writel_relaxed(val, offset);
>>>> +}
>>>
>>> I think this is unnecessary and confusing indirection.
>>> Just use the readl_relaxed/writel_relaxed functions directly in
>>> the code.
>>>
>>
>> This is just to be flexible.
>=20
> Define exactly what you mean with "flexible" in this context. I
> only see unnecessary overhead and hard-to-read code.

We have just passed this discussion for watchdog driver
here: https://lkml.org/lkml/2014/4/1/843

Are you ok with doing it in this way?

static inline u32 zynq_gpio_readreg(struct zynq_gpio *gpio, u32 offset)
{
       return readl_relaxed(gpio->base_addr + offset);
}

static inline void zynq_gpio_writereg(struct zynq_gpio *gpio, u32 offset,=
 u32 val)
{
      writel_relaxed(val, gpio->base_addr + offset);
}

Or even like this to be able to handle error cases.

static inline int zynq_gpio_readreg(struct zynq_gpio *gpio, u32 offset, u=
32 *val)
{
	*val =3D readl_relaxed(gpio->base_addr + offset);
	return 0;
}

static inline int zynq_gpio_writereg(struct zynq_gpio *gpio, u32 offset, =
u32 val)
{
	writel_relaxed(val, gpio->base_addr + offset);
	return 0;
}

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--r2KnN0hcoO0hcQAeq1QDjdmSoPJFmgSJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM7pnsACgkQykllyylKDCEp3gCfQ7mVJJXVhKELQsvo1vn7O1Hc
u0MAoIXoytmGzpDKyLSLfMrxWooULvxR
=ixQs
-----END PGP SIGNATURE-----

--r2KnN0hcoO0hcQAeq1QDjdmSoPJFmgSJH--
