Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaKXMOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:14:46 -0500
Received: from sauhun.de ([89.238.76.85]:50938 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaKXMOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:14:44 -0500
Date: Mon, 24 Nov 2014 13:15:55 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Xudong Chen <xudong.chen@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Subject: Re: [PATCH v3 0/2] ARM: mediatek: Add driver for Mediatek I2C
 controller
Message-ID: <20141124121555.GG3733@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/eUdp+dLtKXvemk"
Content-Disposition: inline
In-Reply-To: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

some very high level remarks:

On Mon, Nov 24, 2014 at 05:38:46PM +0800, Xudong Chen wrote:
> This series is the third version of Mediatek SoCs I2C controller common
> bus driver.
> Compared to the second version,
> 1. Add comments for clock in dt-bindings file i2c-mt6577.txt.
> 2. Remove mt8135.dtsi because of the dependency on pinctrl and clock.
> 3. Encode the feature have-dcm in i2c-mt65xx.c by checking the compatible.
>=20
> This driver is based on 3.18-rc1.
>=20
> MTK I2C HW has some limitation.
> 1. If the i2c_msg number is more than one, STOP will be issued instead of
> RS(Repeat Start) between each message.
> Such as: "START + ADDR + DATA_n + STOP + START + ADDR + DATA_n + STOP ..."
>=20
> 2. Mediatek I2C controller support WRRD(write then read) mode, in WRRD
> mode the Repeat Start will be issued between 2 messages.
> In this driver if 2 messages is first write then read, the driver will
> combine 2 messages using Write-Read mode so the RS will be issued between
> the 2 messages.
> Ex: W/R/R, driver will combine first W/R and then R.
> The data series will be:
> "START + WriteADDR + DATA + RS + ReadADDR + DATA + STOP + START + ReadADD=
R +
> DATA + STOP".

I think there are now 3 drivers in my queue which are not fully I2C
compatible but more supporting the very minimum to, say, read an eeprom.
I am not feeling well to allow them to use I2C_FUNC_I2C. So, I want to
think about ways how to communicate deficiencies like "only 255 byte" or
"only WRRD messages" to users of that I2C controller. This is most
likely not happening before 3.19. But assistance is very welcome.

> 3. Due to HW limitation, in this version the max transfer data length is =
255
> in one message. If want to transfer more than 255 bytes, HW needs the SW
> driver to split the data. Take 600 bytes for example, the data need to be
> divided into 3 parts 255 + 255 + 90. The data series will be:
> "START + ADDR + DATA_255 + RS + ADDR + DATA_255 + RS + ADDR +  DATA_90 + =
STOP"
> instead of "START + ADDR + DATA_900 + STOP".
> We haven't implement this yet, we will do this in the separate patch.

I don't like this idea. If somebody wants to send 1 message with 600
bytes and we can't do this, we should simply say so. Sending 3 messages
is not the same.

> MT8135 and MT6589 can control I2C pins on PMIC(MT6397) by setting the i2c
> registers in MT8135 side. In this case, driver should set OFFSET_PATH_DIR
> bit first, the operation on other registers are still the same.
> For now MT6589/MT8135 support this, MT6577/MT6595/MT8127 do not support.
> For example, If want to use I2C4/5/6 pins on MT8135 just need to enable
> the pinmux, else if want to use I2C pins on PMIC(MT6397) need to add
> "mediatek,have-pmic" property in the .dts file of each platform.

What about Sascha's idea of using a pinctrl driver?

Thanks,

   Wolfram

--9/eUdp+dLtKXvemk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcyF7AAoJEBQN5MwUoCm2RP8P/i31DK9LQQBoMXSxgNZp+NjC
6Ko2BPCjQVOT9lhb7yjizST4HJeBYwFjwUWkdf4VbvyO254+Ei6Mf0jEU2/WphOv
GLKxB4Ruo45VH8beoII+s16NldOphyCa9PC4FiGs7nq9Kp/dGEcmBmURbPvNEAcX
c4Y9cNb1WAhO4fnDZSD3mPOusDsm8Ht4IJJr3u21P9AuIuMRTz2YLu55lMGGfPm8
mflV4DNi1Uur0AC98xE19DZwVE0MqWqXjkI1bG+e+A0e3fHrlPPBcAlsufZ5YWCo
piPEh5kEcUJ5Ld96/p9ePHWdtr/Owm9iwPurM+xlaRoZXSmy8zBiNDB/sLRaVmL5
86c4l+6+FOFxUZ+ut/S8KePHhUMTG6Ao/q+V4UBbLIRIVRzQlDWA3ni4kU+t7EdD
1g8ndpPfydTE3qf8PXNS6saXXU0cmwco8ZNMfk7KvDeDDnSrRQZbVy2NFm85CGRL
ywc74A4vONoyBf9gM58zUHJp8BZuh73RZ/jyOb7NGCaxNLOgtvTRXCD1woq+sLCK
IYJWOBLwTHtfWMD0qam5um/b7CqGACplfC3MiUbc0UfaUZnttoze+Sp900uH607P
UF+t3Q40txfKnosXUCt2d2p8NxrO69Sf4u7eRlbycwa++NxwlqYVOOgpihCDHlIs
/vY0NHRhDEUPpxaTygNJ
=M4Eq
-----END PGP SIGNATURE-----

--9/eUdp+dLtKXvemk--
