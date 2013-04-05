Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161710Ab3DEHyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:54:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3DEHyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:54:01 -0400
Date: Fri, 5 Apr 2013 09:53:49 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 07/12] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130405075348.GC15848@avionic-0098.mockup.avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
 <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de>
 <515DF096.2000703@wwwdotorg.org>
 <20130405073703.GB15848@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <20130405073703.GB15848@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:AWbQ1k4clpOmlI9JW/4FCd+s8QhnxJ7dZXyjnc3GMWV
 0y5k5kIeAIz0cbyZESe4rZ6Yio6lsCMR5bEHuOj6mEy9aUMhPQ
 ymApRTouBWyrkAlmP0lpD2LINDf+AF/VXQRDAzRLNPtULKp5SY
 Inq0/8qPAB9Tlp1xn+mqcGgKPtaAMeP6D18+aTWqBOavCooyuZ
 QRipwlHiuMFxLDknU0/+8GdjpBluFlVu7QMkPbd8PhZxAExUAl
 etKYGTFhu8AFokHu7gHET/EnJxEWXZ5byQVVlc8JNLDWPbCfrX
 /DKEfppianBUF1xVm4POfqcrkqb6Rr8JJJaNCT75RTLDZhWAZN
 cAT5glGkfUekn9PURwN0jaDKSWxCMLbr1hf5KIbU73qqb3HA8K
 mjKE2nw45Uny/jMHnEU9Ic1ldB8+RDd+m73pye29ZZfs3sZ4KN
 wYkeY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: multipart/mixed; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

For reference, here's the new binding document with all your comments
addressed (I think).

Thierry

--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nvidia,tegra20-pcie.txt"

NVIDIA Tegra PCIe controller

Required properties:
- compatible: "nvidia,tegra20-pcie"
- device_type: Must be "pci"
- reg: A list of physical base address and length for each set of controller
  registers. Must contain an entry for each entry in the reg-names property.
- reg-names: Must include the following entries:
  "pads": PADS registers
  "afi": AFI registers
  "cs": configuration space region
- interrupts: A list of interrupt outputs of the controller. Must contain an
  entry for each entry in the interrupt-names property.
- interrupt-names: Must include the following entries:
  "intr": The Tegra interrupt that is asserted for controller interrupts
  "msi": The Tegra interrupt that is asserted when an MSI is received
- pex-clk-supply: Supply voltage for internal reference clock
- vdd-supply: Power supply for controller (1.05V)
- bus-range: Range of bus numbers associated with this controller
- #address-cells: Address representation for root ports (must be 3)
  - cell 0 specifies the bus and device numbers of the root port:
    [23:16]: bus number
    [15:11]: device number
  - cell 1 denotes the upper 32 address bits and should be 0
  - cell 2 contains the lower 32 address bits and is used to translate to the
    CPU address space
- #size-cells: Size representation for root ports (must be 2)
- ranges: Describes the translation of addresses for root ports and standard
  PCI regions. The entries must be 6 cells each, where the first three cells
  correspond to the address as described for the #address-cells property
  above, the fourth cell is the physical CPU address to translate to and the
  fifth and six cells are as described for the #size-cells property above.
  - The first two entries are expected to translate the addresses for the root
    port registers, which are referenced by the assigned-addresses property of
    the root port nodes (see below).
  - The remaining entries setup the mapping for the standard I/O, memory and
    prefetchable PCI regions. The first cell determines the type of region
    that is setup:
    - 0x81000000: I/O memory region
    - 0x82000000: non-prefetchable memory region
    - 0xc2000000: prefetchable memory region
  Please refer to the standard PCI bus binding document for a more detailed
  explanation.
- clocks: List of clock inputs of the controller. Must contain an entry for
  each entry in the clock-names property.
- clock-names: Must include the following entries:
  "pex": The Tegra clock of that name
  "afi": The Tegra clock of that name
  "pcie_xclk": The Tegra clock of that name
  "pll_e": The Tegra clock of that name

Root ports are defined as subnodes of the PCIe controller node.

Required properties:
- device_type: Must be "pci"
- assigned-addresses: Address and size of the port configuration registers
- reg: PCI bus address of the root port
- #address-cells: Must be 3
- #size-cells: Must be 2
- ranges: Sub-ranges distributed from the PCIe controller node. An empty
  property is sufficient.
- nvidia,num-lanes: Number of lanes to use for this port. Valid combinations
  are:
  - Root port 0 uses 4 lanes, root port 1 is unused.
  - Both root ports use 2 lanes.

Example:

SoC DTSI:

	pcie-controller {
		compatible = "nvidia,tegra20-pcie";
		device_type = "pci";
		reg = <0x80003000 0x00000800   /* PADS registers */
		       0x80003800 0x00000200   /* AFI registers */
		       0x90000000 0x10000000>; /* configuration space */
		reg-names = "pads", "afi", "cs";
		interrupts = <0 98 0x04   /* controller interrupt */
		              0 99 0x04>; /* MSI interrupt */
		interrupt-names = "intr", "msi";

		bus-range = <0x00 0xff>;
		#address-cells = <3>;
		#size-cells = <2>;

		ranges = <0x82000000 0 0x80000000 0x80000000 0 0x00001000   /* port 0 registers */
			  0x82000000 0 0x80001000 0x80001000 0 0x00001000   /* port 1 registers */
			  0x81000000 0 0          0x82000000 0 0x00010000   /* downstream I/O */
			  0x82000000 0 0xa0000000 0xa0000000 0 0x10000000   /* non-prefetchable memory */
			  0xc2000000 0 0xb0000000 0xb0000000 0 0x10000000>; /* prefetchable memory */

		clocks = <&tegra_car 70>, <&tegra_car 72>, <&tegra_car 74>,
			 <&tegra_car 118>;
		clock-names = "pex", "afi", "pcie_xclk", "pll_e";
		status = "disabled";

		pci@1,0 {
			device_type = "pci";
			assigned-addresses = <0x82000800 0 0x80000000 0 0x1000>;
			reg = <0x000800 0 0 0 0>;
			status = "disabled";

			#address-cells = <3>;
			#size-cells = <2>;

			ranges;

			nvidia,num-lanes = <2>;
		};

		pci@2,0 {
			device_type = "pci";
			assigned-addresses = <0x82001000 0 0x80001000 0 0x1000>;
			reg = <0x001000 0 0 0 0>;
			status = "disabled";

			#address-cells = <3>;
			#size-cells = <2>;

			ranges;

			nvidia,num-lanes = <2>;
		};
	};


Board DTS:

	pcie-controller {
		status = "okay";

		vdd-supply = <&pci_vdd_reg>;
		pex-clk-supply = <&pci_clk_reg>;

		/* root port 00:01.0 */
		pci@1,0 {
			status = "okay";

			/* bridge 01:00.0 (optional) */
			pci@0,0 {
				reg = <0x010000 0 0 0 0>;

				#address-cells = <3>;
				#size-cells = <2>;

				device_type = "pci";

				/* endpoint 02:00.0 */
				pci@0,0 {
					reg = <0x020000 0 0 0 0>;
				};
			};
		};
	};

Note that devices on the PCI bus are dynamically discovered using PCI's bus
enumeration and therefore don't need corresponding device nodes in DT. However
if a device on the PCI bus provides a non-probeable bus such as I2C or SPI,
device nodes need to be added in order to allow the bus' children to be
instantiated at the proper location in the operating system's device tree (as
illustrated by the optional nodes in the example above).

--V88s5gaDVPzZ0KCq--

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRXoMMAAoJEN0jrNd/PrOhEscP/2t4BExCgPEZeJs6Wxkx0P9v
tbON506DFGBmoD1pN8olOM4jSR2GnWEC+aMtszV9ATH4/3aTTP4kTG34w3Pruti0
wn8QPSr/dbmXwcWqMqjan9P+p43o/EhaQXVmoNL/i2xh1nrSpLMfylQmzXumfeat
Ax40zgEhN9CyNPKS4uoYmVPRLQnNPKN++G8hqm2XypJ6g6300ntm5GbyCWGldIiR
0xHcfv6hxiaC0/QU8B+TzpJP/xQ1TGzDaNf4VvJQVl7NdINFXUVL2pdTVYLeLt41
uRu+hFyyWcihlNlUr6CpV6E7Fca4Ymtq6azGOfYdnQ30dCS9rHD2nHx2VAUsvdY6
2+Ygx4TzjQruz6H+90RGubpdpYv/vMESD+sbOLGm/98UUykPAmKuKdjiwDcKcIfs
oFHw06LugZLdw/cXcqT7YNcfL/mV+2mXTgaYkfUlka/khnzAFN80Tyv3WV8zetZ+
AGf8lwvJJd3AUybVx0lyjclkORi4icHeoW/LYlvXIa88/Hk+ZFMEGVYFL4jl+vhq
2S/lHfiQEtqcCaltgthKBvE9svCFJTwV2YCRLHGL/xGOuCL1r+JIZmI+l7pIzuaj
cccbGTp/yXtyxzcd6xvhiV0iKTaQ2XRBG4hGMSqZzgI6zYCBKnwbf2zPNwng/CDz
wN0Yg6/YVU7JxsG2HUrZ
=WF+a
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
