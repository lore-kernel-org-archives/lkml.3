Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaBNI4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:56:09 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58309 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaBNI4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:56:04 -0500
Message-ID: <52FDD9FE.8040908@monstr.eu>
Date: Fri, 14 Feb 2014 09:55:26 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, wg@grandegger.com,
        michal.simek@xilinx.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v2] can: xilinx CAN controller support.
References: <\> <0dc128ac-e5cd-47bd-9ab1-3a545c3e2043@CO9EHSMHS012.ehs.local> <52FD1B16.6020600@pengutronix.de>
In-Reply-To: <52FD1B16.6020600@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="cafLha3RjWhHeNvLUaACRjLplUrb21vHE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cafLha3RjWhHeNvLUaACRjLplUrb21vHE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Marc,

>> +	int waiting_ech_skb_num;
>> +	int xcan_echo_skb_max_tx;
>> +	int xcan_echo_skb_max_rx;
>> +	struct napi_struct napi;
>> +	spinlock_t ech_skb_lock;
>> +	u32 (*read_reg)(const struct xcan_priv *priv, int reg);
>> +	void (*write_reg)(const struct xcan_priv *priv, int reg, u32 val);
>=20
> Please remove read_reg, write_reg, as long as there isn't any BE suppor=
t
> in the driver, call them directly.

That's not entirely truth. If you look at Microblaze then you will see
that Microblaze can be BE and LE.
There is just missing endian detection which we will add to the next vers=
ion.

But because MB io helper functions are broken for a while you should be
able to use this driver on both endianess.

btw: I would prefer to use ioread32 and ioread32be instead of readl.
Is it OK for you?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--cafLha3RjWhHeNvLUaACRjLplUrb21vHE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlL92f4ACgkQykllyylKDCFSbwCaAmXxeKjT7a64na83jdx4Dwv4
t+gAoImSI59tzdRYMwx5PuSO2r2WBIdc
=rhln
-----END PGP SIGNATURE-----

--cafLha3RjWhHeNvLUaACRjLplUrb21vHE--
