Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3GQMQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:16:45 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:52342 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3GQMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:16:43 -0400
Message-ID: <51E68B22.9070704@monstr.eu>
Date: Wed, 17 Jul 2013 14:16:34 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
CC: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Remoteproc v3.10 arm-microblaze
References: <2dca3652-e141-4f9e-934e-29b7c4334b41@CH1EHSMHS037.ehs.local>
In-Reply-To: <2dca3652-e141-4f9e-934e-29b7c4334b41@CH1EHSMHS037.ehs.local>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2CNSNXCQBIGGCXFGQSUKB"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2CNSNXCQBIGGCXFGQSUKB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 07/17/2013 01:37 PM, Michal Simek wrote:
> Hi Ohad,
>=20
> I am working on another remoteproc driver.
> Currently less problematic than arm-arm.
> It is arm to microblaze on zynq.
>=20
> I have two problems:
> 1. I need to allocate carveout first because my firmware must be added =
to that
> space first. (I don't have any other mapping mechanism ready for use)
> I have simple solution I am calling rproc_handle_resources in rproc_fw_=
config_virtio()
> just for carveouts before rproc_count_vrings_handler and rproc_vdev_han=
dler are called
> which ensure that carveout is allocated first.
>=20
> 2. I am getting problem with rproc_handle_vdev().
> Here is the flow which I see:
> request_firmware_nowait() calls
> rproc_fw_config_virtio() calls
> rproc_handle_vdev() calls
> rproc_add_virtio_dev() calls
> register_virtio_device() calls dev->config->reset() without setup point=
er rproc->table_ptr().
>=20
> But rproc->table_ptr is setup in rproc_fw_boot()
> which is called from rproc_boot() much later.
>=20
> Which is causing that all rproc_virtio_config_ops operations
> are using incorrect table_ptr().
> Problematic for me are rproc_virtio_get_status, rproc_virtio_set_status=

> and especially rproc_virtio_reset();
>=20
> And with BUG_ON I am getting problem virtio_dev_remove() where status s=
hould
> be zero - WARN_ON_ONCE(dev->config->get_status(dev));
>=20
> Below is log with some of my debug messages. (comments explain what's g=
oing on there)

Let me correct myself. It is caused by switching from loaded_table back t=
o cached_table
in rproc_shutdown where old cached_table is probably used and there are p=
robably be still old values.

What's the purpose of cached_table? Shouldn't be synchronized with loaded=
 one in rproc shutdown?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2CNSNXCQBIGGCXFGQSUKB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHmiyIACgkQykllyylKDCHVBACfVnx4oBYmyAXIqiuIfBEc5xfQ
qVYAnRzyOm0x3UTinVRnUE1O/1Ly7lw6
=IXw4
-----END PGP SIGNATURE-----

------enig2CNSNXCQBIGGCXFGQSUKB--
