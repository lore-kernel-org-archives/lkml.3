Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaBSIyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:54:45 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57688 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaBSIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:54:43 -0500
Message-ID: <5304714E.7070900@monstr.eu>
Date: Wed, 19 Feb 2014 09:54:38 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Srikanth Thokala <sthokal@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] pcie: Add Xilinx PCIe Host Bridge IP driver
References: <1392564830-5868-1-git-send-email-sthokal@xilinx.com> <CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
In-Reply-To: <CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7O64H635cPGwegCVRuKIhjmruOOXO9D80"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7O64H635cPGwegCVRuKIhjmruOOXO9D80
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/18/2014 10:32 PM, Bjorn Helgaas wrote:
> [+cc Arnd]
>=20
> On Sun, Feb 16, 2014 at 8:33 AM, Srikanth Thokala <sthokal@xilinx.com> =
wrote:
>> This is the driver for Xilinx AXI PCIe Host Bridge Soft IP
>>
>> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>> ---
>> - Rebased on v3.14.0-rc2
>> ---
>>  .../devicetree/bindings/pci/xilinx-pcie.txt        |   43 +
>>  drivers/pci/host/Kconfig                           |    7 +
>>  drivers/pci/host/Makefile                          |    1 +
>>  drivers/pci/host/pci-xilinx.c                      |  985 +++++++++++=
+++++++++
>>  4 files changed, 1036 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/xilinx-pcie.=
txt
>>  create mode 100644 drivers/pci/host/pci-xilinx.c
>>
>> diff --git a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt b/D=
ocumentation/devicetree/bindings/pci/xilinx-pcie.txt
>> new file mode 100644
>> index 0000000..66a2487
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>> @@ -0,0 +1,43 @@
>> +* Xilinx AXI PCIe Root Port Bridge DT description
>> +
>> +Required properties:
>> +- #address-cells: Address representation for root ports, set to <3>
>> +- #size-cells: Size representation for root ports, set to <2>
>> +- compatible: Should contain "xlnx,axi-pcie-1.00.a"
>> +- reg: Should contain AXI PCIe registers location and length
>> +- interrupts: Should contain AXI PCIe interrupt
>> +- ranges: ranges for the PCI memory regions
>> +       Please refer to the standard PCI bus binding document for a mo=
re
>> +       detailed explanation
>> +- xlnx,axibar-num: Number of memory regions configured in the hardwar=
e,
>> +       maximum being three which is configurable in the hardware.
>> +- xlnx,include-rc: Root Port (=3D1) or End Point (=3D0)
>> +- xlnx,pciebar2axibar-0: Translation address from PCIe to AXI
>> +       Only one PCIe BAR is applicable in Root port mode, it can be
>> +       either 32/64-bit. If it is 64-bit BAR, lower 32 bits are prese=
nt
>> +       in 'xlnx,pciebar2axibar-0' and Upper 32 bits in 'xlnx,pciebar2=

>> +       axibar-1'. And if it is 32-bit BAR, only 'xlnx,pciebar2axibar-=
0'
>> +       is valid
>> +
>> +Optional properties
>> +- xlnx,pciebar-as: PCIe BAR aperture size is 32 (=3D0) or 64-bit (=3D=
1).
>> +- xlnx,pciebar2axibar-1: Translation address from PCIe to AXI, contai=
ns
>> +       upper 32 bits if PCIe BAR size is 64-bit. When xlnx,pciebar-as=

>> +       is set, this is a required property and should contain a valid=

>> +       value (other than FF's)
>=20
> I hardly know anything about DT, but xlnx,pciebar2axibar-0,
> xlnx,pciebar-as, and xlnx,pciebar2axibar-1 look strange to me.  Is
> that really the DT way of dealing with 32/64-bit BARs and host bridge
> address translation?  I don't see similar things in the other files in
> Documentation/devicetree/bindings/pci/, even though some of the other
> drivers/pci/host/*.c files do use pci_add_resource_offset(), which
> indicates that they support address translation.

This is how xilinx is describing hardware in design tools.
And as Arnd already know this is full IP description with all options
which can be selected.
If there is any standard way how to describe it we can change it.

> Please also include a MAINTAINERS update for drivers/pci/host/pci-xilin=
x.c.

This should be handle by our record that's why MAINTAINERS update is not =
necessary.
(N: xilinx below)

ARM/ZYNQ ARCHITECTURE
M:	Michal Simek <michal.simek@xilinx.com>
L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
W:	http://wiki.xilinx.com
T:	git git://git.xilinx.com/linux-xlnx.git
S:	Supported
F:	arch/arm/mach-zynq/
F:	drivers/cpuidle/cpuidle-zynq.c
N:	zynq
N:	xilinx
F:	drivers/clocksource/cadence_ttc_timer.c
F:	drivers/mmc/host/sdhci-of-arasan.c

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--7O64H635cPGwegCVRuKIhjmruOOXO9D80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMEcU4ACgkQykllyylKDCEccQCdEQSkF9ZrDs35bqMESeNhNz4i
MY0An0IUGq1ZWFky3wyJaAjcAp/wSFKf
=BGXE
-----END PGP SIGNATURE-----

--7O64H635cPGwegCVRuKIhjmruOOXO9D80--
