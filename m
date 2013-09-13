Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3IMJdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:33:37 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59799 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3IMJdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:33:35 -0400
Message-ID: <5232DBED.5060903@monstr.eu>
Date: Fri, 13 Sep 2013 11:33:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: Simplify irq allocation
References: <7a8e72582d8f4262a70bb9b7050fb6cb3be15578.1378305608.git.michal.simek@xilinx.com> <20130912134208.GE17188@intel.com>
In-Reply-To: <20130912134208.GE17188@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WXrNIDMLJnqMORV8kNeB88jmJhMIPCCiH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WXrNIDMLJnqMORV8kNeB88jmJhMIPCCiH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/12/2013 03:42 PM, Vinod Koul wrote:
> On Wed, Sep 04, 2013 at 04:40:17PM +0200, Michal Simek wrote:
>> Use devm_request_irq function.
>=20
> Applied, thanks

Thanks. I have one change in my tree which I would like to get to the mai=
nline
but it will need more interaction with others pl330 users.
It is about adding support for interrupt per channel feature.
For our case we have 8 channels and every channel has specific interrupt
+ we have one abort IRQ.

Based on the binding and Linux code two changes are necessary.
1. Extend AMBA_NR_IRQS because we have 9 IRQs
2. Driver change which is just register irqs when they are available.

Are these two changes OK for you?

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--WXrNIDMLJnqMORV8kNeB88jmJhMIPCCiH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIy2+0ACgkQykllyylKDCHfvACfddeShgyKuegoWChGNQm/1Dtp
rGQAoJcSfLWrSMDNM8peIAe+wOpQCfF0
=NIUD
-----END PGP SIGNATURE-----

--WXrNIDMLJnqMORV8kNeB88jmJhMIPCCiH--
