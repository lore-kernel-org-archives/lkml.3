Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbaDBLkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:40:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36336 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbaDBLj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:39:57 -0400
Message-ID: <533BF707.8030203@monstr.eu>
Date: Wed, 02 Apr 2014 13:39:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Srikanth Thokala <sthokal@xilinx.com>, robh+dt@kernel.org
CC: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, levex@linux.com, lars@metafoo.de,
        andriy.shevchenko@linux.intel.com, jaswinder.singh@linaro.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v7 1/2] dma: Add Xilinx Video DMA DT Binding Documentation
References: <1396008222-7058-1-git-send-email-sthokal@xilinx.com> <1396008222-7058-2-git-send-email-sthokal@xilinx.com>
In-Reply-To: <1396008222-7058-2-git-send-email-sthokal@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jQncS9n3wcul960VH0p2ipwgtctDcrKfQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jQncS9n3wcul960VH0p2ipwgtctDcrKfQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 03/28/2014 01:03 PM, Srikanth Thokala wrote:
> Device-tree binding documentation of Xilinx Video DMA Engine
>=20
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
> ---
> Changes in v7:
> None
>=20
> Changes in v6:
> None
>=20
> Changes in v5:
> None
>=20
> Changes in v4:
> None
>=20
> Changes in v3:
> None
>=20
> Changes in v2:
> - Removed device-id DT property, as suggested by Arnd Bergmann
> - Properly documented DT bindings as suggested by Arnd Bergmann
> ---
>  .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 ++++++++++++=
++++++++
>  1 file changed, 75 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx=
_vdma.txt
>=20
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.t=
xt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> new file mode 100644
> index 0000000..ab8be1a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> @@ -0,0 +1,75 @@
> +Xilinx AXI VDMA engine, it does transfers between memory and video dev=
ices.
> +It can be configured to have one channel or two channels. If configure=
d
> +as two channels, one is to transmit to the video device and another is=

> +to receive from the video device.
> +
> +Required properties:
> +- compatible: Should be "xlnx,axi-vdma-1.00.a"
> +- #dma-cells: Should be <1>, see "dmas" property below
> +- reg: Should contain VDMA registers location and length.
> +- xlnx,num-fstores: Should be the number of framebuffers as configured=
 in h/w.
> +- dma-channel child node: Should have atleast one channel and can have=
 upto
> +	two channels per device. This node specifies the properties of each
> +	DMA channel (see child node properties below).
> +
> +Optional properties:
> +- xlnx,include-sg: Tells whether configured for Scatter-mode in
> +	the hardware.
> +- xlnx,flush-fsync: Tells whether which channel to Flush on Frame sync=
=2E
> +	It takes following values:
> +	{1}, flush both channels
> +	{2}, flush mm2s channel
> +	{3}, flush s2mm channel
> +
> +Required child node properties:
> +- compatible: It should be either "xlnx,axi-vdma-mm2s-channel" or
> +	"xlnx,axi-vdma-s2mm-channel".
> +- interrupts: Should contain per channel VDMA interrupts.
> +- xlnx,data-width: Should contain the stream data width, take values
> +	{32,64...1024}.
> +
> +Option child node properties:
> +- xlnx,include-dre: Tells whether hardware is configured for Data
> +	Realignment Engine.
> +- xlnx,genlock-mode: Tells whether Genlock synchronization is
> +	enabled/disabled in hardware.
> +
> +Example:
> +++++++++
> +
> +axi_vdma_0: axivdma@40030000 {
> +	compatible =3D "xlnx,axi-vdma-1.00.a";
> +	#dma_cells =3D <1>;
> +	reg =3D < 0x40030000 0x10000 >;
> +	xlnx,num-fstores =3D <0x8>;
> +	xlnx,flush-fsync =3D <0x1>;
> +	dma-channel@40030000 {
> +		compatible =3D "xlnx,axi-vdma-mm2s-channel";
> +		interrupts =3D < 0 54 4 >;
> +		xlnx,datawidth =3D <0x40>;
> +	} ;
> +	dma-channel@40030030 {
> +		compatible =3D "xlnx,axi-vdma-s2mm-channel";
> +		interrupts =3D < 0 53 4 >;
> +		xlnx,datawidth =3D <0x40>;
> +	} ;
> +} ;
> +
> +
> +* DMA client
> +
> +Required properties:
> +- dmas: a list of <[Video DMA device phandle] [Channel ID]> pairs,
> +	where Channel ID is '0' for write/tx and '1' for read/rx
> +	channel.
> +- dma-names: a list of DMA channel names, one per "dmas" entry
> +
> +Example:
> +++++++++
> +
> +vdmatest_0: vdmatest@0 {
> +	compatible =3D"xlnx,axi-vdma-test-1.00.a";
> +	dmas =3D <&axi_vdma_0 0
> +		&axi_vdma_0 1>;
> +	dma-names =3D "vdma0", "vdma1";
> +} ;
>=20

Rob, Mark: Any comment regarding binding?

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--jQncS9n3wcul960VH0p2ipwgtctDcrKfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM79wcACgkQykllyylKDCFUEwCggGCQiue3RPNLJCeVEiBY9Ak5
BPgAn3OVOCq4yOYzI3J3TLZqEU6FniI7
=w+ed
-----END PGP SIGNATURE-----

--jQncS9n3wcul960VH0p2ipwgtctDcrKfQ--
