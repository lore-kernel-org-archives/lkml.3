Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3JJFVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:21:45 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58862 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3JJFVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:21:43 -0400
Message-ID: <52563964.4030905@monstr.eu>
Date: Thu, 10 Oct 2013 07:21:40 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] clk/zynq/clkc: Add 'fclk-enable' feature
References: <1381242972-14752-1-git-send-email-soren.brinkmann@xilinx.com> <20131008153816.GB4981@e106331-lin.cambridge.arm.com> <fe3858e7-e3e2-4806-aeca-a2a4676e09aa@CO1EHSMHS007.ehs.local>
In-Reply-To: <fe3858e7-e3e2-4806-aeca-a2a4676e09aa@CO1EHSMHS007.ehs.local>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="O6jXRAOtL9nWNQH8g2kIHw9jhe88xgnNG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O6jXRAOtL9nWNQH8g2kIHw9jhe88xgnNG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/09/2013 05:25 PM, S=C3=B6ren Brinkmann wrote:
> On Tue, Oct 08, 2013 at 04:38:17PM +0100, Mark Rutland wrote:
>> On Tue, Oct 08, 2013 at 03:36:11PM +0100, Soren Brinkmann wrote:
>>> In some use cases Zynq's FPGA clocks are used as static clock
>>> generators for IP in the FPGA part of the SOC for which no Linux driv=
er
>>> exists and would control those clocks. To avoid automatic
>>> gating of these clocks in such cases a new property - fclk-enable - i=
s
>>> added to the clock controller's DT description to accomodate such use=

>>> cases. It's value is a bitmask, where a set bit results in enabling
>>> the corresponding FCLK through the clkc.
>>>
>>> FPGA clocks are handled following the rules below:
>>>
>>> If an FCLK is not enabled by bootloaders, that FCLK will be disabled =
in
>>> Linux. Drivers can enable and control it through the CCF as usual.
>>>
>>> If an FCLK is enabled by bootloaders AND the corresponding bit in the=

>>> 'fclk-enable' DT property is set, that FCLK will be enabled by the cl=
kc,
>>> resulting in an off by one reference count for that clock. Ensuring i=
t
>>> will always be running.
>>>
>>> The default value for 'fclk-enable' is '0xf' (all FCLK's enabled by t=
he
>>> bootloader are enabled through the clkc.
>>
>> Why? Juding by the diff that's not what the code currently does, so wh=
y
>> not leave it as 0, and only set it where required as a work-around?
> The default is set as described here:
> [...]
>>> +	ret =3D of_property_read_u32(np, "fclk-enable", &fclk_enable);
>>> +	if (ret)
>>> +		fclk_enable =3D 0xf;
>>> +
>=20
> The default has been chosen this way, because it avoids trouble with
> customers. Customers expect the FPGA clocks to be running, once they
> configured them in the FPGA tools. If Linux gates them off for some
> reason, it creates confusion and often ends up in customer support.
> But in general I agree. It is kind of a work around and having zero as
> default would be desirable. I'd leave this to Michal.

No problem to have default value setup to 0. And use this workaround
when it is set in DTS.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--O6jXRAOtL9nWNQH8g2kIHw9jhe88xgnNG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJWOWQACgkQykllyylKDCHjvQCdG4/3Y4jQgwsLzdck2UYLUusL
UKwAmwVN2ScmVRWBTTcunoQPgwWWA8tC
=Rih1
-----END PGP SIGNATURE-----

--O6jXRAOtL9nWNQH8g2kIHw9jhe88xgnNG--
