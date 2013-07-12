Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040Ab3GLOAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:00:38 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:60432 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3GLOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:00:36 -0400
Message-ID: <51E00BF8.2020608@monstr.eu>
Date: Fri, 12 Jul 2013 16:00:24 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v1 3/4] spi/xilinx: Simplify irq allocation
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com> <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com> <20130708144930.GG27646@sirena.org.uk> <51DADF3E.1000802@monstr.eu> <20130708162642.GM27646@sirena.org.uk>
In-Reply-To: <20130708162642.GM27646@sirena.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TIBOSLFMUIRUJWWMQXXS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TIBOSLFMUIRUJWWMQXXS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/08/2013 06:26 PM, Mark Brown wrote:
> On Mon, Jul 08, 2013 at 05:48:14PM +0200, Michal Simek wrote:
>> On 07/08/2013 04:49 PM, Mark Brown wrote:
>=20
>>> Is it definitely safe to leave the IRQ hanging around after the maste=
r
>>> has been freed - there's no possibility of a late error interrupt or
>>> something?
>=20
>> I think it is more generic question if this race condition is fine
>> for all drivers which are using devres groups.
>=20
> Well, it's mainly an issue for IRQs - the other resources don't initiat=
e
> events by themselves which is what causes the issue.  It just needs a
> bit of extra care so I wanted to check that this has been thought of.
>=20
>> I have just looked at it and devres_release_all() is called where
>> driver is unload and irq are disabled there.
>=20
> The problem is the gap between the resources used to handle the IRQ
> being freed and the IRQ itself being freed - if the hardware can be
> guaranteed to be idle then that's fine but we need to be sure that is
> OK.  Otherwise the interrupt handler may get run and be looking at a
> resource which was freed which would be unfortunate.
>=20
>> btw: What's the proper way for spi driver unregistration?
>=20
>> spi_unregistered_master() (which also free private structure)
>> and
>> spi_master_put()?
>=20
> Yes.

Just a follow up on this.
Which function free private structures registered by spi_alloc_master fun=
ction?
Is it in spi_master_put()?

The reason why I am asking is where clk_xx functions should be added.
I see them between these two functions in sifr for example.

And also I see in drivers in error probe path that drivers are calling kf=
ree(master)
but they are not doing in remove part (like spi-davinci.c).

I just want to clear this in our zynq drivers before we send them out.

Thanks,
Michal




--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2TIBOSLFMUIRUJWWMQXXS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHgC/gACgkQykllyylKDCEikwCfZ2bqYj8NZBZW0QITBwpGt9af
WMsAnRu+cgpIcFB6jocDvtgFl1pYGCtK
=AbsD
-----END PGP SIGNATURE-----

------enig2TIBOSLFMUIRUJWWMQXXS--
