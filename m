Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaISNqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:46:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57790 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbaISNp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:45:58 -0400
Message-ID: <541C3371.8080100@ti.com>
Date: Fri, 19 Sep 2014 16:45:21 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "peter.griffin@linaro.org" <peter.griffin@linaro.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: fsl-sii902x: HDMI support for Freescale SoCs
References: <1409892517-29816-1-git-send-email-Li.Xiubo@freescale.com> <5412BE19.2010302@ti.com> <d94bf53d85884b4da0fb4da3041e5742@BY2PR0301MB0613.namprd03.prod.outlook.com>
In-Reply-To: <d94bf53d85884b4da0fb4da3041e5742@BY2PR0301MB0613.namprd03.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="kD6sMA5N5Mi0pHR01MnRK5aRQa8d1eKFC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kD6sMA5N5Mi0pHR01MnRK5aRQa8d1eKFC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 15/09/14 05:17, Li.Xiubo@freescale.com wrote:
> Hi Tomi,
>=20
> Thanks very much for your comments.
>=20
>=20
>> Subject: Re: [PATCH] fbdev: fsl-sii902x: HDMI support for Freescale So=
Cs
>>
>> Hi,
>>
>> On 05/09/14 07:48, Xiubo Li wrote:
>>> Some Freescale SoCs, there has an DVI/HDMI controller and a PHY,
>>> attached to one of their display controller unit's LCDC interfaces.
>>> This patch adds a preliminary static support for such controllers.
>>>
>>> This will support for many modes and a dynamic switching between
>>> them.
>>>
>>> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
>>> ---
>>>  .../devicetree/bindings/video/fsl-sii902x.txt      |  17 +
>>>  drivers/video/fbdev/Kconfig                        |   7 +
>>>  drivers/video/fbdev/Makefile                       |   1 +
>>>  drivers/video/fbdev/fsl-sii902x.c                  | 526
>> +++++++++++++++++++++
>>>  4 files changed, 551 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/video/fsl-sii90=
2x.txt
>>>  create mode 100644 drivers/video/fbdev/fsl-sii902x.c
>>
>> I don't know how you picked the names of the people you sent this patc=
h
>> to, but looks to me that most of them are probably not interested in
>> this patch.
>>
>=20
> I just using the get_maintainer.pl script.

Yes, and that's good, but you have to use your judgment also.
get_maintainer.pl gives you names of people who have at some point
touched the files or directories you are changing. Usually only the
first names returned by get_maintainer.pl are relevant.

>> Anyway, a few quick comments on the patch:
>>
>> - You should probably use regmap instead of direct i2c calls.
>> Interestingly, you define regmap variable, but you never use it.
>=20
> Yes, this it's my another version in my local machine using regmap whic=
h
> need much more test.
>=20
>> - Use defines for register offsets, instead of magic numbers.
>=20
> This will be fixed together with regmap using.

Well, it's better to send the patch only when you have tested and
cleaned up your driver.

>> - You should not use static variables. They prevent having multiple
>> instances of the device.
>>
>=20
> Okay.
>=20
>> So the SiI902x chip is on the SoC, not on the board? And it's a plain
>> standard SiI902x in other aspects?
>>
>=20
> No, it's on board.
>=20
> And it will be used for i.MX and LS1+ platforms.

Ok. In that case, I would suggest you to move to the DRM framework. The
fbdev framework is not suited to adding external encoders. The end
result with fbdev will be a SoC/board specific hack driver.

That said, we already have such drivers for fbdev, so I'm not 100%
against adding a new one. But I'm very very seriously recommending
moving to DRM.

And if this driver is added to fbdev, I think the device tree bindings
should use the video ports/endpoints to describe the connections.

 Tomi



--kD6sMA5N5Mi0pHR01MnRK5aRQa8d1eKFC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHDNxAAoJEPo9qoy8lh717+AP/j5nC1pCwcV3FVBtDn8EzTB9
u+I8CFqAUQvdE+dlt2ayeK8rdUZMNDPK+AOGGGQ/hyymI3+VuTWO70SzPzW1JlFT
y+P/KQ0i0Zk8E9vb3NpclxUAfannmfuUMOC80cyGJYXXHS55wAl8cG6SjIv9m2SW
B0ZoUyBMY07Zc+IRstxtp/+s2CzwTKjS8m0myoqSWfQjb89f3/fVmejJIvkZd84/
06EEBnTpj/tLoMSgpxsgjrhDVFGAwyYDjIcf2qvSurOQa90WaHphQAxHxpPbOpWG
Tdk2q3ZL4MlPkWAw8DkWnRf2rtMvFsy6TDkbwscETfFgIGTKrYSTNrJVtp4RlHZC
UfOaN2j2MTzQQ+SxgJbuGxIw1Xd/tMz0aj2+RI+crt70lp7LeBLWvowX3Gh1PBJX
qutseE5AueMXzSTM6bg6f/3+w2hYB2flfnvdgh6G9pqnHKQQQujT2Q1esO33Gz8Z
kEoAGz4BaZAxsE8ucIhu2h/LTeOBOi9N5MxDN1vtpn5DWWjyXOWDndnqWgV1Nmxk
qQq06hZS94FgZZC7/0rOHfDX3cuLyB7YsOid814gsodFBrcTjcA/6w857Ij2pbSI
XQKM+svRNB8ajaSI7Q/qoWF1YT7Bu5biJnAVIj8z7vEER8M/rDGeuQUw0FgOwBvT
x+saK8ydZMTtNzRjQqlB
=WqBq
-----END PGP SIGNATURE-----

--kD6sMA5N5Mi0pHR01MnRK5aRQa8d1eKFC--
