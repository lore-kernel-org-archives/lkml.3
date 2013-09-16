Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3IPKdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:33:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61810 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab3IPKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:33:13 -0400
Message-ID: <5236DE60.3020901@monstr.eu>
Date: Mon, 16 Sep 2013 12:33:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 3/3] video: xilinxfb: Simplify error path
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com> <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com> <5236D4BD.9050707@ti.com>
In-Reply-To: <5236D4BD.9050707@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oVCHwaQN7pXte2OmtAbm6QPDuFlOhpfem"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oVCHwaQN7pXte2OmtAbm6QPDuFlOhpfem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/16/2013 11:51 AM, Tomi Valkeinen wrote:
> On 12/09/13 08:54, Michal Simek wrote:
>=20
>> @@ -394,16 +382,12 @@ static int xilinxfb_release(struct device *dev)
>>  	/* Turn off the display */
>>  	xilinx_fb_out32(drvdata, REG_CTRL, 0);
>>
>> -	/* Release the resources, as allocated based on interface */
>> -	if (drvdata->flags & BUS_ACCESS_FLAG)
>> -		devm_iounmap(dev, drvdata->regs);
>>  #ifdef CONFIG_PPC_DCR
>> -	else
>> +	/* Release the resources, as allocated based on interface */
>> +	if (!(drvdata->flags & BUS_ACCESS_FLAG))
>>  		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
>>  #endif
>=20
> I might be mistaken, and it's not strictly part of this series, but
> shouldn't dcr_unmap be called somewhere else also, if the probe fails?

yes. It should.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--oVCHwaQN7pXte2OmtAbm6QPDuFlOhpfem
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI23mAACgkQykllyylKDCE7kgCcDISIKNxmcIP2TU7IVEOlCXIa
h5gAnA/0ZAQDWy2vTHPK0etCb4crQwWt
=Y59r
-----END PGP SIGNATURE-----

--oVCHwaQN7pXte2OmtAbm6QPDuFlOhpfem--
