Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab3HGKWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:22:11 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56240 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab3HGKWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:22:06 -0400
Date: Wed, 7 Aug 2013 12:21:42 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 24/26] x86 STA2X11: add dts for Intel's Northville board
Message-ID: <f002d837f1769cf16d7658bbcf8ef89d88cd87b8.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base for this dts was automatically generated to avoid typos, most
of all in ranges and interrupt-map properties.
It was then hand-edited to add some details (for instance mmci1 gpio's).
This dts is still incomplete. Yet, it contains most of the
pci-amba devices and allows a northville board to boot with a serial
console on /dev/ttyAMA1. A shell is also working on the same UART
(interrupts are OK for UART's and apparently for most of the other

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/platform/sta2x11/northville.dts |  941 ++++++++++++++++++++++++++++++
 1 files changed, 941 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/sta2x11/northville.dts

diff --git a/arch/x86/platform/sta2x11/northville.dts b/arch/x86/platform/sta2x11/northville.dts
new file mode 100644
index 0000000..b41c499
--- /dev/null
+++ b/arch/x86/platform/sta2x11/northville.dts
@@ -0,0 +1,941 @@
+/dts-v1/;
+/ {
+	compatible =  "intel,northville" ;
+	#address-cells = < 1 >;
+	#size-cells = < 1 >;
+	cpus@0 {
+		#address-cells = < 1 >;
+		#size-cells = < 0 >;
+		cpu@0 {
+			compatible =  "intel,e6600-cpu" ;
+			reg = < 0x00000000  >;
+
+		};
+
+	};
+	soc@2 {
+		compatible =  "intel,e6600-soc" ;
+		#address-cells = < 1 >;
+		#size-cells = < 1 >;
+		ranges;
+		pci@cf8 {
+			compatible =  "pci" ;
+			device_type =  "pci" ;
+			#address-cells = < 3 >;
+			#size-cells = < 2 >;
+			reg = < 0x00000cf8    0x00000008  >;
+			ranges = < 0x02000000    0x00000000    0x000a0000    0x000a0000    0x00000000    0x00020000
+				 0x02000000    0x00000000    0x40000000    0x40000000    0x00000000    0xc0000000  >;
+			bus-range = < 0x00000000    0x00000000  >;
+			/* pci host bridge, bus = 0, dev = 0, function = 0 ; */
+			/* name = Atom Processor E6xx PCI Host Bridge #1 */
+			pci@00000000 {
+				compatible =  "pci8086,4114.5",
+					"pci8086,4114",
+					"pciclass060000",
+					"pciclass0600" ;
+				reg = < 0x00000000    0x00000000    0x00000000    0x00000000    0x00000100  >;
+				device_type =  "pci" ;
+
+			};
+			/* pci host bridge, bus = 0, dev = 1, function = 0 ; */
+			/* name = Atom Processor E6xx Configuration Unit */
+			pci@00000800 {
+				compatible =  "pci8086,8183.2",
+					"pci8086,8183",
+					"pciclass060000",
+					"pciclass0600" ;
+				reg = < 0x00000800    0x00000000    0x00000000    0x00000000    0x00000100  >;
+				device_type =  "pci" ;
+
+			};
+			/* pci device, bus = 0, dev = 2, function = 0 ; */
+			/* name = Atom Processor E6xx Integrated Graphics Controller */
+			pci@02001000 {
+				compatible =  "pci8086,4108.5",
+					"pci8086,4108",
+					"pciclass030000",
+					"pciclass0300" ;
+				reg = < 0x02001000    0x00000000    0xd2a00000    0x00000000    0x00100000
+					 0x01001000    0x00000000    0x0000f010    0x00000000    0x00000008
+					 0x02001000    0x00000000    0xb0000000    0x00000000    0x10000000
+					 0x02001000    0x00000000    0xd2bc0000    0x00000000    0x00040000  >;
+				device_type =  "pci" ;
+
+			};
+			/* pci device, bus = 0, dev = 3, function = 0 ; */
+			/* name = Atom Processor E6xx Integrated Graphics Controller */
+			pci@02001800 {
+				compatible =  "pci8086,8182.2",
+					"pci8086,8182",
+					"pciclass040000",
+					"pciclass0400" ;
+				reg = < 0x02001800    0x00000000    0xd2b00000    0x00000000    0x00080000
+					 0x01001800    0x00000000    0x0000f000    0x00000000    0x00000008
+					 0x02001800    0x00000000    0xa0000000    0x00000000    0x10000000
+					 0x02001800    0x00000000    0xd2b80000    0x00000000    0x00040000  >;
+				device_type =  "pci" ;
+
+			};
+			/* pci-pci bridge, bus = 0, dev = 23, function = 0 ; */
+			/* name = Atom Processor E6xx PCI Express Port 1 */
+			pci@0000b800 {
+				compatible =  "pci8086,8184.2",
+					"pci8086,8184",
+					"pciclass060400",
+					"pciclass0604" ;
+				reg = < 0x0000b800    0x00000000    0x00000000    0x00000000    0x00000100  >;
+				device_type =  "pci" ;
+				#address-cells = < 3 >;
+				#size-cells = < 2 >;
+				bus-range = < 0x00000001    0x00000006  >;
+				ranges = < 0x0200b800    0x00000000    0xc0000000    0x02000000    0x00000000    0xc0000000    0x00000000    0x12900000  >;
+				/* pci-pci bridge, bus = 1, dev = 0, function = 0 ; */
+				/* name = Device cc17 */
+				pci@00010000 {
+					compatible =  "pci104a,cc17.0",
+						"pci104a,cc17",
+						"pciclass060400",
+						"pciclass0604" ;
+					reg = < 0x00010000    0x00000000    0x00000000    0x00000000    0x00000100  >;
+					device_type =  "pci" ;
+					interrupt-parent = <&msi>;
+					#interrupt-cells = <1>;
+
+					#address-cells = < 3 >;
+					#size-cells = < 2 >;
+					bus-range = < 0x00000002    0x00000006  >;
+					ranges = < 0x02010000    0x00000000    0xc0000000    0x0200b800    0x00000000    0xc0000000    0x00000000    0x12900000  >;
+					/* pci-pci bridge, bus = 2, dev = 0, function = 0 ; */
+					/* name = Device cc18 */
+					pci@00020000 {
+						compatible =  "pci104a,cc18.0",
+							"pci104a,cc18",
+							"pciclass060400",
+							"pciclass0604" ;
+						reg = < 0x00020000    0x00000000    0x00000000    0x00000000    0x00000100  >;
+						device_type =  "pci" ;
+						#address-cells = < 3 >;
+						#size-cells = < 2 >;
+						bus-range = < 0x00000003    0x00000003  >;
+						ranges = < 0x02020000    0x00000000    0xca800000    0x02010000    0x00000000    0xca800000    0x00000000    0x04000000  >;
+						/* pci device, bus = 3, dev = 0, function = 0 ; */
+						/* name = Device cc0c */
+						pci@02030000 {
+							compatible =  "pci104a,cc0c.0",
+								"pci104a,cc0c",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02030000    0x00000000    0xce400000    0x00000000    0x00400000
+								 0x02030000    0x00000000    0xce000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 3, dev = 0, function = 1 ; */
+						/* name = Device cc01 */
+						pci@02030100 {
+							compatible =  "pci104a,cc01.0",
+								"pci104a,cc01",
+								"pciclass0c0380",
+								"pciclass0c03" ;
+							reg = < 0x02030100    0x00000000    0xcdc00000    0x00000000    0x00400000
+								 0x02030100    0x00000000    0xcd800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 3, dev = 0, function = 2 ; */
+						/* name = Connext usb host controller */
+						pci@02030200 {
+							compatible =  "pci104a,cc00.0",
+								"pci104a,cc00",
+								"pciclass0c0380",
+								"pciclass0c03" ;
+							reg = < 0x02030200    0x00000000    0xcd400000    0x00000000    0x00400000
+								 0x02030200    0x00000000    0xcd000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 3, dev = 0, function = 3 ; */
+						/* name = Device cc02 */
+						pci@02030300 {
+							compatible =  "pci104a,cc02.0",
+								"pci104a,cc02",
+								"pciclass0c0380",
+								"pciclass0c03" ;
+							reg = < 0x02030300    0x00000000    0xccc00000    0x00000000    0x00400000
+								 0x02030300    0x00000000    0xcc800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 3, dev = 0, function = 4 ; */
+						/* name = Device cc05 */
+						pci@02030400 {
+							compatible =  "pci104a,cc05.0",
+								"pci104a,cc05",
+								"pciclass080100",
+								"pciclass0801" ;
+							reg = < 0x02030400    0x00000000    0xcc400000    0x00000000    0x00400000
+								 0x02030400    0x00000000    0xcc000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 3, dev = 0, function = 5 ; */
+						/* name = Device cc03 */
+						pci@02030500 {
+							compatible =  "pci104a,cc03.0",
+								"pci104a,cc03",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02030500    0x00000000    0xcbc00000    0x00000000    0x00400000
+								 0x02030500    0x00000000    0xcb800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 3, dev = 0, function = 6 ; */
+						/* name = Device cc03 */
+						pci@02030600 {
+							compatible =  "pci104a,cc03.0",
+								"pci104a,cc03",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02030600    0x00000000    0xcb400000    0x00000000    0x00400000
+								 0x02030600    0x00000000    0xcb000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 3, dev = 0, function = 7 ; */
+						/* name = Device cc04 */
+						pci@02030700 {
+							compatible =  "pci104a,cc04.0",
+								"pci104a,cc04",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02030700    0x00000000    0xcac00000    0x00000000    0x00400000
+								 0x02030700    0x00000000    0xca800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						amba@00020000 {
+							compatible =  "arm,amba-bus" ;
+							#address-cells = < 1 >;
+							#size-cells = < 1 >;
+							#interrupt-cells = < 1 >;
+							interrupt-map = < 0x50000000    0xffffffff    &msi    0xfee03000    0x00000000
+								 0x54005000    0x0000001f    &msi    0xfee03000    0x00000000
+								 0x54006000    0x00000020    &msi    0xfee03000    0x00000000
+								 0x54007000    0x00000021    &msi    0xfee03000    0x00000000
+								 0x54008000    0x00000022    &msi    0xfee03000    0x00000000
+								 0x54009000    0xffffffff    &msi    0xfee03000    0x00000000
+								 0x5400a000    0xffffffff    &msi    0xfee03000    0x00000000
+								 0x13000000    0x00000001    &msi    0xfee03000    0x00000000
+								 0x5c000000    0x0000001b    &msi    0xfee03000    0x00000000
+								 0x5c001000    0x0000001c    &msi    0xfee03000    0x00000000
+								 0x5c002000    0x0000001d    &msi    0xfee03000    0x00000000  >;
+							ranges = < 0x50000000    0x02030000    0x00000000    0xce000000    0x00001000
+								 0x54005000    0x02030000    0x00000000    0xce400000    0x00001000
+								 0x54006000    0x02030000    0x00000000    0xce401000    0x00001000
+								 0x54007000    0x02030000    0x00000000    0xce402000    0x00001000
+								 0x54008000    0x02030000    0x00000000    0xce403000    0x00001000
+								 0x54009000    0x02030000    0x00000000    0xce404000    0x00001000
+								 0x5400a000    0x02030000    0x00000000    0xce405000    0x00001000
+								 0x13000000    0x02030400    0x00000000    0xcc400000    0x00001000
+								 0x5c000000    0x02030500    0x00000000    0xcbc00000    0x00001000
+								 0x5c001000    0x02030600    0x00000000    0xcb400000    0x00001000
+								 0x5c002000    0x02030700    0x00000000    0xcac00000    0x00001000  >;
+							soc_dma_0: dma-controller@13000000 {
+								compatible =  "stericsson,pl080-nomadik",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00280080  >;
+								reg = < 0x13000000    0x00001000  >;
+								interrupts = < 0x00000001  >;
+
+							};
+							apb_regs_0: apb-regs@50000000 {
+								compatible =  "st,sta2x11-apb-regs" ;
+								reg = < 0x50000000    0x00010000  >;
+
+							};
+							gpio0_0: gpio@54005000 {
+								compatible =  "st,nomadik-gpio" ;
+								reg = < 0x54005000    0x00001000  >;
+								interrupts = < 0x0000001f  >;
+								interrupt-controller;
+								#interrupt-cells = < 2 >;
+								gpio-controller;
+								#gpio-cells = < 2 >;
+								gpio-bank = < 0 >;
+
+							};
+							gpio1_0: gpio@54006000 {
+								compatible =  "st,nomadik-gpio" ;
+								reg = < 0x54006000    0x00001000  >;
+								interrupts = < 0x00000020  >;
+								interrupt-controller;
+								#interrupt-cells = < 2 >;
+								gpio-controller;
+								#gpio-cells = < 2 >;
+								gpio-bank = < 1 >;
+
+							};
+							gpio2_0: gpio@54007000 {
+								compatible =  "st,nomadik-gpio" ;
+								reg = < 0x54007000    0x00001000  >;
+								interrupts = < 0x00000021  >;
+								interrupt-controller;
+								#interrupt-cells = < 2 >;
+								gpio-controller;
+								#gpio-cells = < 2 >;
+								gpio-bank = < 2 >;
+
+							};
+							gpio3_0: gpio@54008000 {
+								compatible =  "st,nomadik-gpio" ;
+								reg = < 0x54008000    0x00001000  >;
+								interrupts = < 0x00000022  >;
+								interrupt-controller;
+								#interrupt-cells = < 2 >;
+								gpio-controller;
+								#gpio-cells = < 2 >;
+								gpio-bank = < 3 >;
+
+							};
+							pinctrl {
+								compatible = "stericsson,nmk-pinctrl-sta2x11";
+								/* Pin configurations */
+								sdio1_default_mux: sdio1_mux {
+								       ste,function = "sdio1";
+								       ste,pins = "sdio1_a_1";
+								};
+								sdio1_default_mode: sdio1_mode {
+										    mmcsd_default_cfg1 {
+												       /* CD, WP */
+												       ste,pins = "GPIO124_J5",
+												       "GPIO123_J4";
+												       /* inputs with no pull up ? */
+												       ste,input = <0>;
+										     };
+										     mmcsd_default_cfg2 {
+												       /* PWR */
+												       ste,pins = "GPIO121_J3";
+												       /* output ? */
+												       ste,output = <2>;
+										     };
+									};
+							};
+							sctl_0: sctl@54009000 {
+								compatible =  "st,sta2x11-sctl" ;
+								reg = < 0x54009000    0x00001000  >;
+
+							};
+							scr_0: scr@5400a000 {
+								compatible =  "st,sta2x11-scr" ;
+								reg = < 0x5400a000    0x00001000  >;
+
+							};
+							uart0_0: serial@5c000000 {
+								compatible =  "stericsson,pl011",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00380802  >;
+								reg = < 0x5c000000    0x00001000  >;
+								interrupts = < 0x0000001b  >;
+
+							};
+							uart1_0: serial@5c001000 {
+								compatible =  "stericsson,pl011",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00380802  >;
+								reg = < 0x5c001000    0x00001000  >;
+								interrupts = < 0x0000001c  >;
+
+							};
+							uart2_0: serial@5c002000 {
+								compatible =  "stericsson,pl011",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00380802  >;
+								reg = < 0x5c002000    0x00001000  >;
+								interrupts = < 0x0000001d  >;
+
+							};
+
+						};
+
+					};
+					/* pci-pci bridge, bus = 2, dev = 1, function = 0 ; */
+					/* name = Device cc18 */
+					pci@00020800 {
+						compatible =  "pci104a,cc18.0",
+							"pci104a,cc18",
+							"pciclass060400",
+							"pciclass0604" ;
+						reg = < 0x00020800    0x00000000    0x00000000    0x00000000    0x00000100  >;
+						device_type =  "pci" ;
+						#address-cells = < 3 >;
+						#size-cells = < 2 >;
+						bus-range = < 0x00000004    0x00000004  >;
+						ranges = < 0x02020800    0x00000000    0xcec00000    0x02010000    0x00000000    0xcec00000    0x00000000    0x03d00000  >;
+						/* pci device, bus = 4, dev = 0, function = 0 ; */
+						/* name = Device cc06 */
+						pci@02040000 {
+							compatible =  "pci104a,cc06.0",
+								"pci104a,cc06",
+								"pciclass010600",
+								"pciclass0106" ;
+							reg = < 0x02040000    0x00000000    0xd2400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 4, dev = 0, function = 1 ; */
+						/* name = Device cc07 */
+						pci@02040100 {
+							compatible =  "pci104a,cc07.0",
+								"pci104a,cc07",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02040100    0x00000000    0xd2000000    0x00000000    0x00400000
+								 0x02040100    0x00000000    0xd1c00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 4, dev = 0, function = 2 ; */
+						/* name = Device cc07 */
+						pci@02040200 {
+							compatible =  "pci104a,cc07.0",
+								"pci104a,cc07",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02040200    0x00000000    0xd1800000    0x00000000    0x00400000
+								 0x02040200    0x00000000    0xd1400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 4, dev = 0, function = 3 ; */
+						/* name = Device cc07 */
+						pci@02040300 {
+							compatible =  "pci104a,cc07.0",
+								"pci104a,cc07",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02040300    0x00000000    0xd1000000    0x00000000    0x00400000
+								 0x02040300    0x00000000    0xd0c00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 4, dev = 0, function = 4 ; */
+						/* name = Device cc07 */
+						pci@02040400 {
+							compatible =  "pci104a,cc07.0",
+								"pci104a,cc07",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02040400    0x00000000    0xd0800000    0x00000000    0x00400000
+								 0x02040400    0x00000000    0xd0400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 4, dev = 0, function = 5 ; */
+						/* name = Device cc04 */
+						pci@02040500 {
+							compatible =  "pci104a,cc04.0",
+								"pci104a,cc04",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02040500    0x00000000    0xd0000000    0x00000000    0x00400000
+								 0x02040500    0x00000000    0xcfc00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 4, dev = 0, function = 6 ; */
+						/* name = Device cc14 */
+						pci@02040600 {
+							compatible =  "pci104a,cc14.0",
+								"pci104a,cc14",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02040600    0x00000000    0xcf800000    0x00000000    0x00400000
+								 0x02040600    0x00000000    0xcf400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 4, dev = 0, function = 7 ; */
+						/* name = Device cc12 */
+						pci@02040700 {
+							compatible =  "pci104a,cc12.0",
+								"pci104a,cc12",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02040700    0x00000000    0xcf000000    0x00000000    0x00400000
+								 0x02040700    0x00000000    0xcec00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						amba@00020800 {
+							compatible =  "arm,amba-bus" ;
+							#address-cells = < 1 >;
+							#size-cells = < 1 >;
+							#interrupt-cells = < 1 >;
+							interrupt-map = < 0x5c003000    0x0000001e    &msi    0xfee03000    0x00000000  >;
+							ranges = < 0x5c003000    0x02040500    0x00000000    0xd0000000    0x00001000  >;
+							uart3_0: serial@5c003000 {
+								compatible =  "stericsson,pl011",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00380802  >;
+								reg = < 0x5c003000    0x00001000  >;
+								interrupts = < 0x0000001e  >;
+
+							};
+
+						};
+
+					};
+					/* pci-pci bridge, bus = 2, dev = 2, function = 0 ; */
+					/* name = Device cc18 */
+					pci@00021000 {
+						compatible =  "pci104a,cc18.0",
+							"pci104a,cc18",
+							"pciclass060400",
+							"pciclass0604" ;
+						reg = < 0x00021000    0x00000000    0x00000000    0x00000000    0x00000100  >;
+						device_type =  "pci" ;
+						#address-cells = < 3 >;
+						#size-cells = < 2 >;
+						bus-range = < 0x00000005    0x00000005  >;
+						ranges = < 0x02021000    0x00000000    0xc6400000    0x02010000    0x00000000    0xc6400000    0x00000000    0x04000000  >;
+						/* pci device, bus = 5, dev = 0, function = 0 ; */
+						/* name = Device cc16 */
+						pci@02050000 {
+							compatible =  "pci104a,cc16.0",
+								"pci104a,cc16",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02050000    0x00000000    0xca000000    0x00000000    0x00400000
+								 0x02050000    0x00000000    0xc9c00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 5, dev = 0, function = 1 ; */
+						/* name = Device cc0a */
+						pci@02050100 {
+							compatible =  "pci104a,cc0a.0",
+								"pci104a,cc0a",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02050100    0x00000000    0xc9800000    0x00000000    0x00400000
+								 0x02050100    0x00000000    0xc9400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 5, dev = 0, function = 2 ; */
+						/* name = Device cc0b */
+						pci@02050200 {
+							compatible =  "pci104a,cc0b.0",
+								"pci104a,cc0b",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02050200    0x00000000    0xc9000000    0x00000000    0x00400000
+								 0x02050200    0x00000000    0xc8c00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 5, dev = 0, function = 3 ; */
+						/* name = Device cc0b */
+						pci@02050300 {
+							compatible =  "pci104a,cc0b.0",
+								"pci104a,cc0b",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02050300    0x00000000    0xc8800000    0x00000000    0x00400000
+								 0x02050300    0x00000000    0xc8400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 5, dev = 0, function = 4 ; */
+						/* name = Device cc0b */
+						pci@02050400 {
+							compatible =  "pci104a,cc0b.0",
+								"pci104a,cc0b",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02050400    0x00000000    0xc8000000    0x00000000    0x00400000
+								 0x02050400    0x00000000    0xc7c00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 5, dev = 0, function = 5 ; */
+						/* name = Device cc15 */
+						pci@02050500 {
+							compatible =  "pci104a,cc15.0",
+								"pci104a,cc15",
+								"pciclass088000",
+								"pciclass0880" ;
+							reg = < 0x02050500    0x00000000    0xc7800000    0x00000000    0x00400000
+								 0x02050500    0x00000000    0xc7400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 5, dev = 0, function = 6 ; */
+						/* name = Device cc09 */
+						pci@02050600 {
+							compatible =  "pci104a,cc09.0",
+								"pci104a,cc09",
+								"pciclass020000",
+								"pciclass0200" ;
+							reg = < 0x02050600    0x00000000    0xc7000000    0x00000000    0x00400000
+								 0x02050600    0x00000000    0xc6c00000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 5, dev = 0, function = 7 ; */
+						/* name = Device cc11 */
+						pci@02050700 {
+							compatible =  "pci104a,cc11.0",
+								"pci104a,cc11",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02050700    0x00000000    0xc6800000    0x00000000    0x00400000
+								 0x02050700    0x00000000    0xc6400000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						amba@00021000 {
+							compatible =  "arm,amba-bus" ;
+							#address-cells = < 1 >;
+							#size-cells = < 1 >;
+							#interrupt-cells = < 1 >;
+							interrupt-map = < 0x5800b000    0xffffffff    &msi    0xfee03000    0x00000000
+								 0x54001000    0x00000010    &msi    0xfee03000    0x00000000
+								 0x54000000    0x00000011    &msi    0xfee03000    0x00000000
+								 0x58004000    0x00000012    &msi    0xfee03000    0x00000000
+								 0x5c004000    0x00000013    &msi    0xfee03000    0x00000000
+								 0x80000000    0xffffffff    &msi    0xfee03000    0x00000000  >;
+							ranges = < 0x5800b000    0x02050000    0x00000000    0xc9c00000    0x00001000
+								 0x54001000    0x02050100    0x00000000    0xc9800000    0x00001000
+								 0x54000000    0x02050200    0x00000000    0xc9000000    0x00001000
+								 0x58004000    0x02050300    0x00000000    0xc8800000    0x00001000
+								 0x5c004000    0x02050400    0x00000000    0xc8000000    0x00001000
+								 0x80000000    0x02050500    0x00000000	   0xc7800000    0x00010000 >;
+							sdio1_0: mmc@54000000 {
+								compatible =  "stericsson, pl180-ux500v2",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x10480180  >;
+								reg = < 0x54000000    0x00001000  >;
+								interrupts = < 0x00000011  >;
+								bus-width=<4>;
+								/* Test at 2MHz */
+								max-frequency=<2000000>;
+								/* CD -> GPIO 124 -> GPIO3 PIN 28 */
+								cd-gpios = <&gpio3_0 28 0x1>;
+								cd-inverted;
+								/* WP -> GPIO 123 -> GPIO3 PIN 27 */
+								wp-gpios = <&gpio3_0 27 0>;
+								wp-inverted;
+								pinctrl-names = "default";
+								pinctrl-0 = <&sdio1_default_mux>, <&sdio1_default_mode>;
+							};
+							sdio0_0: mmc@54001000 {
+								compatible =  "stericsson, pl180-ux500v2",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x10480180  >;
+								reg = < 0x54001000    0x00001000  >;
+								interrupts = < 0x00000010  >;
+
+							};
+							sdio2_0: mmc@58004000 {
+								compatible =  "stericsson, pl180-ux500v2",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x10480180  >;
+								reg = < 0x58004000    0x00001000  >;
+								interrupts = < 0x00000012  >;
+
+							};
+							apb_soc_regs_0: apb-soc-regs@5800b000 {
+								compatible =  "st,sta2x11-apb-soc-regs" ;
+								reg = < 0x5800b000    0x00001000  >;
+
+							};
+							sdio3_0: mmc@5c004000 {
+								compatible =  "stericsson, pl180-ux500v2",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x10480180  >;
+								reg = < 0x5c004000    0x00001000  >;
+								interrupts = < 0x00000013  >;
+
+							};
+							esram_0: esram@80000000 {
+								compatible =  "mmio-sram" ;
+								reg = < 0x80000000    0x00010000  >;
+
+							};
+
+						};
+
+					};
+					/* pci-pci bridge, bus = 2, dev = 3, function = 0 ; */
+					/* name = Device cc18 */
+					pci@00021800 {
+						compatible =  "pci104a,cc18.0",
+							"pci104a,cc18",
+							"pciclass060400",
+							"pciclass0604" ;
+						reg = < 0x00021800    0x00000000    0x00000000    0x00000000    0x00000100  >;
+						device_type =  "pci" ;
+						#address-cells = < 3 >;
+						#size-cells = < 2 >;
+						bus-range = < 0x00000006    0x00000006  >;
+						ranges = < 0x02021800    0x00000000    0xc0000000    0x02010000    0x00000000    0xc0000000    0x00000000    0x06000000  >;
+						/* pci device, bus = 6, dev = 0, function = 0 ; */
+						/* name = Device cc0d */
+						pci@02060000 {
+							compatible =  "pci104a,cc0d.0",
+								"pci104a,cc0d",
+								"pciclass040000",
+								"pciclass0400" ;
+							reg = < 0x02060000    0x00000000    0xc5c00000    0x00000000    0x00400000
+								 0x02060000    0x00000000    0xc5800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 6, dev = 0, function = 1 ; */
+						/* name = Device cc13 */
+						pci@02060100 {
+							compatible =  "pci104a,cc13.0",
+								"pci104a,cc13",
+								"pciclass038000",
+								"pciclass0380" ;
+							reg = < 0x02060100    0x00000000    0xc5400000    0x00000000    0x00400000
+								 0x02060100    0x00000000    0xc5000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 6, dev = 0, function = 2 ; */
+						/* name = Device cc08 */
+						pci@02060200 {
+							compatible =  "pci104a,cc08.0",
+								"pci104a,cc08",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02060200    0x00000000    0xc4c00000    0x00000000    0x00400000
+								 0x02060200    0x00000000    0xc4800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 6, dev = 0, function = 3 ; */
+						/* name = Device cc08 */
+						pci@02060300 {
+							compatible =  "pci104a,cc08.0",
+								"pci104a,cc08",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02060300    0x00000000    0xc4400000    0x00000000    0x00400000
+								 0x02060300    0x00000000    0xc4000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 6, dev = 0, function = 4 ; */
+						/* name = Device cc08 */
+						pci@02060400 {
+							compatible =  "pci104a,cc08.0",
+								"pci104a,cc08",
+								"pciclass070000",
+								"pciclass0700" ;
+							reg = < 0x02060400    0x00000000    0xc3c00000    0x00000000    0x00400000
+								 0x02060400    0x00000000    0xc3800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 6, dev = 0, function = 5 ; */
+						/* name = Device cc0e */
+						pci@02060500 {
+							compatible =  "pci104a,cc0e.0",
+								"pci104a,cc0e",
+								"pciclass080100",
+								"pciclass0801" ;
+							reg = < 0x02060500    0x00000000    0xc3400000    0x00000000    0x00400000
+								 0x02060500    0x00000000    0xc3000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 6, dev = 0, function = 6 ; */
+						/* name = Device cc0f */
+						pci@02060600 {
+							compatible =  "pci104a,cc0f.0",
+								"pci104a,cc0f",
+								"pciclass040100",
+								"pciclass0401" ;
+							reg = < 0x02060600    0x00000000    0xc2c00000    0x00000000    0x00400000
+								 0x02060600    0x00000000    0xc2800000    0x00000000    0x00400000
+								 0x02060600    0x00000000    0xc2400000    0x00000000    0x00400000
+								 0x02060600    0x00000000    0xc2000000    0x00000000    0x00400000
+								 0x02060600    0x00000000    0xc1c00000    0x00000000    0x00400000
+								 0x02060600    0x00000000    0xc1800000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						/* pci device, bus = 6, dev = 0, function = 7 ; */
+						/* name = Device cc10 */
+						pci@02060700 {
+							compatible =  "pci104a,cc10.0",
+								"pci104a,cc10",
+								"pciclass040100",
+								"pciclass0401" ;
+							reg = < 0x02060700    0x00000000    0xc1400000    0x00000000    0x00400000
+								 0x02060700    0x00000000    0xc1000000    0x00000000    0x00400000
+								 0x02060700    0x00000000    0xc0c00000    0x00000000    0x00400000
+								 0x02060700    0x00000000    0xc0800000    0x00000000    0x00400000
+								 0x02060700    0x00000000    0xc0400000    0x00000000    0x00400000
+								 0x02060700    0x00000000    0xc0000000    0x00000000    0x00400000  >;
+							device_type =  "pci" ;
+
+						};
+						amba@00021800 {
+							compatible =  "arm,amba-bus" ;
+							#address-cells = < 1 >;
+							#size-cells = < 1 >;
+							#interrupt-cells = < 1 >;
+							interrupt-map = < 0x54002000    0x0000000e    &msi    0xfee03000    0x00000000
+								 0x54003000    0x0000000f    &msi    0xfee03000    0x00000000
+								 0x54004000    0x00000010    &msi    0xfee03000    0x00000000
+								 0x30000000    0x00000011    &msi    0xfee03000    0x00000000  >;
+							ranges = < 0x54002000    0x02060200    0x00000000    0xc4c00000    0x00001000
+								 0x54003000    0x02060300    0x00000000    0xc4400000    0x00001000
+								 0x54004000    0x02060400    0x00000000    0xc3c00000    0x00001000
+								 0x30000000    0x02060500    0x00000000    0xc3400000    0x00001000  >;
+							audio_dma_0: dma-controller@30000000 {
+								compatible =  "stericsson,pl080-nomadik",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00280080  >;
+								reg = < 0x30000000    0x00001000  >;
+								interrupts = < 0x00000007  >;
+
+							};
+							spi0_0: ssp@54002000 {
+								compatible =  "stericsson,pl023",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00080023  >;
+								reg = < 0x54002000    0x00001000  >;
+								interrupts = < 0x0000000e  >;
+
+							};
+							spi1_0: ssp@54003000 {
+								compatible =  "stericsson,pl023",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00080023  >;
+								reg = < 0x54003000    0x00001000  >;
+								interrupts = < 0x0000000f  >;
+
+							};
+							spi2_0: ssp@54004000 {
+								compatible =  "stericsson,pl023",
+									"arm,primecell" ;
+								arm,primecell-periphid = < 0x00080023  >;
+								reg = < 0x54004000    0x00001000  >;
+								interrupts = < 0x00000010  >;
+
+							};
+
+						};
+
+					};
+
+				};
+
+			};
+			/* pci-pci bridge, bus = 0, dev = 24, function = 0 ; */
+			/* name = Atom Processor E6xx PCI Express Port 2 */
+			pci@0000c000 {
+				compatible =  "pci8086,8185.2",
+					"pci8086,8185",
+					"pciclass060400",
+					"pciclass0604" ;
+				reg = < 0x0000c000    0x00000000    0x00000000    0x00000000    0x00000100  >;
+				device_type =  "pci" ;
+				#address-cells = < 3 >;
+				#size-cells = < 2 >;
+				bus-range = < 0x00000007    0x00000007  >;
+				ranges = < 0x0200c000    0x00000000    0x40800000    0x02000000    0x00000000    0x40800000    0x00000000    0x00200000  >;
+
+			};
+			/* pci-pci bridge, bus = 0, dev = 25, function = 0 ; */
+			/* name = Atom Processor E6xx PCI Express Port 3 */
+			pci@0000c800 {
+				compatible =  "pci8086,8180.2",
+					"pci8086,8180",
+					"pciclass060400",
+					"pciclass0604" ;
+				reg = < 0x0000c800    0x00000000    0x00000000    0x00000000    0x00000100  >;
+				device_type =  "pci" ;
+				#address-cells = < 3 >;
+				#size-cells = < 2 >;
+				bus-range = < 0x00000008    0x00000008  >;
+				ranges = < 0x0200c800    0x00000000    0x40400000    0x02000000    0x00000000    0x40400000    0x00000000    0x00200000  >;
+
+			};
+			/* pci-pci bridge, bus = 0, dev = 26, function = 0 ; */
+			/* name = Atom Processor E6xx PCI Express Port 4 */
+			pci@0000d000 {
+				compatible =  "pci8086,8181.2",
+					"pci8086,8181",
+					"pciclass060400",
+					"pciclass0604" ;
+				reg = < 0x0000d000    0x00000000    0x00000000    0x00000000    0x00000100  >;
+				device_type =  "pci" ;
+				#address-cells = < 3 >;
+				#size-cells = < 2 >;
+				bus-range = < 0x00000009    0x00000009  >;
+				ranges = < 0x0200d000    0x00000000    0x40000000    0x02000000    0x00000000    0x40000000    0x00000000    0x00200000  >;
+
+			};
+			/* pci device, bus = 0, dev = 27, function = 0 ; */
+			/* name = System Controller Hub (SCH Poulsbo) HD Audio Controller */
+			pci@0200d800 {
+				compatible =  "pci8086,811b.2",
+					"pci8086,811b",
+					"pciclass040300",
+					"pciclass0403" ;
+				reg = < 0x0200d800    0x00000000    0xd2c00000    0x00000000    0x00004000  >;
+				device_type =  "pci" ;
+
+			};
+			/* pci device, bus = 0, dev = 31, function = 0 ; */
+			/* name = Atom Processor E6xx LPC Bridge */
+			pci@0000f800 {
+				compatible =  "pci8086,8186.2",
+					"pci8086,8186",
+					"pciclass060100",
+					"pciclass0601" ;
+				reg = < 0x0000f800    0x00000000    0x00000000    0x00000000    0x00000100  >;
+				device_type =  "pci" ;
+
+			};
+
+		};
+		interrupt-controller@0xfec00000 {
+			compatible =  "intel,e6600-ioapic",
+				"intel,ioapic" ;
+			reg = < 0xfec00000    0x00000040  >;
+			interrupt-controller;
+
+		};
+		timer@0xfed00000 {
+			compatible =  "intel,e6600-hpet",
+				"intel,hpet" ;
+			reg = < 0xfed00000    0x00000400  >;
+
+		};
+		interrupt-controller@0xfee00000 {
+			compatible =  "intel,e6600-lapic",
+				"intel,lapic" ;
+			reg = < 0xfee00000    0x00001000  >;
+
+		};
+		msi: interrupt-controller@0xfee03000 {
+			compatible =  "intel,msi-irqs" ;
+			interrupt-controller;
+			#interrupt-cells = < 1 >;
+			#address-cells = < 1 >;
+			reg = < 0xfee03000    0x00001000  >;
+
+		};
+
+	};
+
+};
-- 
1.7.7.2
