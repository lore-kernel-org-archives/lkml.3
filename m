Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3FMFFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:05:33 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:44993 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3FMFFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:05:31 -0400
Message-ID: <51B9527B.904@monstr.eu>
Date: Thu, 13 Jun 2013 07:02:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 3/3] arm: dt: zynq: Add support for the zed platform
References: <1371055268-32337-1-git-send-email-soren.brinkmann@xilinx.com> <1371055268-32337-4-git-send-email-soren.brinkmann@xilinx.com> <20130612182345.GA1656@pengutronix.de> <2433e1d1-7d2e-4b23-a76e-2085e3aef1a6@DB9EHSMHS010.ehs.local> <20130612193358.GA21585@pengutronix.de> <d7057a7e-fc92-4e24-bf7b-137e873f871b@VA3EHSMHS011.ehs.local>
In-Reply-To: <d7057a7e-fc92-4e24-bf7b-137e873f871b@VA3EHSMHS011.ehs.local>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2SXGKJOTPGHTHFJTDPRJO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2SXGKJOTPGHTHFJTDPRJO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/12/2013 10:16 PM, S=C3=B6ren Brinkmann wrote:
> On Wed, Jun 12, 2013 at 09:33:58PM +0200, Steffen Trumtrar wrote:
>> On Wed, Jun 12, 2013 at 11:26:34AM -0700, S=C3=B6ren Brinkmann wrote:
>>> On Wed, Jun 12, 2013 at 08:23:45PM +0200, Steffen Trumtrar wrote:
>>>> On Wed, Jun 12, 2013 at 09:41:08AM -0700, Soren Brinkmann wrote:
>>>>> Add a DT fragment for the Zed Zynq platform and a corresponding
>>>>> target to the Makefile
>>>>>
>>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>>> ---
>>>>> I used the 'xlnx,...' compat strings since it seems this is what is=

>>>>> used in the Xilinx and Digilent vendor trees.
>>>>>
>>>>> +/include/ "zynq-7000.dtsi"
>>>>> +
>>>>> +/ {
>>>>> +	model =3D "Zynq Zed Development Board";
>>>>> +	compatible =3D "xlnx,zynq-zed", "xlnx,zynq-7000";
>>>>> +
>>>>> +	memory {
>>>>> +		device_type =3D "memory";
>>>>> +		reg =3D <0 0x20000000>;
>>>>> +	};
>>>>> +
>>>>> +	chosen {
>>>>> +		bootargs =3D "console=3DttyPS1,115200 earlyprintk";
>>>>> +	};
>>>>> +
>>>>> +};
>>>>
>>>> Hi!
>>>>
>>>> This looks a little bit to basic. No?! Not even an UART?
>>> The UART is imported from the common zynq-7000.dtsi.
>>
>> Hm, you are actually right, although I think that you shouldn't be.
>> It is possible to NOT use the UARTs, isn't it? So, default on for both=
 UARTs is wrong.
> Well, in that case the dtsi has to be fixed to add the 'status =3D "dis=
abled"
> property to the UARTs which then can be overridden in the board dts fil=
es
> as needed. I guess I'll prepare another patch for a v3 for adding statu=
s
> properties to the UART nodes.

I am ok with this. Just to be sure that we will probably need to start
to use port-number to reflect which port is first, second.


>>>> The compatible should include digilent or avnet. Digilent only sells=
 to academic
>>>> customers, Avnet doesn't.
>>> I don't care at all. So, who makes the decision which one is the corr=
ect
>>> one? Actually we could even drop the zed specific one completely and =
go
>>> with 'xlnx,zynq-7000' only.
>>
>> I'm okay with that.
> Okay, let's wait a little and see if there are other opinions and then =
I
> can prepare a v3.

AFAIK Digilent is producer, Avnet is reseller. I think it is enough to wr=
ite
in description ZedBoard and don't mentioned manufacturer.

By my previous comment I thought to have there just zynq-7000 compatible =
string
without any additional zc702/zc706 or zed board properties.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2SXGKJOTPGHTHFJTDPRJO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG5UnwACgkQykllyylKDCGlzACaA/ocqzwEM5m1Zr/JcwlkcI/J
GLgAnj72D5Go+QZx4BJ5hVxxJ4B+mXav
=4Unl
-----END PGP SIGNATURE-----

------enig2SXGKJOTPGHTHFJTDPRJO--
