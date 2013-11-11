Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3KKRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:09:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41732 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3KKRJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:09:51 -0500
From: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: [PATCH 08/12] memory: davinci-aemif: add bindings for AEMIF driver
Thread-Topic: [PATCH 08/12] memory: davinci-aemif: add bindings for AEMIF
 driver
Thread-Index: AQHO3vrnEwWyai241kWFFb7gvFtHU5ogQu4K
Date: Mon, 11 Nov 2013 17:09:01 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8D3A@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-9-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-9-git-send-email-ivan.khoronzhuk@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bindings for AEMIF controller drivers/memory/davinici-aemif.c

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../bindings/memory-controllers/davinci-aemif.txt  |  198 ++++++++++++++++++++
 1 file changed, 198 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/davinci-aemif.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/davinci-aemif.txt b/Documentation/devicetree/bindings/memory-controllers/davinci-aemif.txt
new file mode 100644
index 0000000..5e5319a
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/davinci-aemif.txt
@@ -0,0 +1,198 @@
+* Device tree bindings for Texas instruments Davinci/Keystone AEMIF controller
+
+Th Async External Memory Interface (EMIF16/AEMIF) controller is intended to
+provide a glue-less interface to a variety of asynchronous memory devices like
+ASRA M, NOR and NAND memory. A total of 256M bytes of any of these memories
+can be accessed at any given time via four chip selects with 64M byte access
+per chip select. Synchronous memories such as DDR1 SD RAM, SDR SDRAM
+and Mobile SDR are not supported.
+
+Documentation:
+Davinci DM646x - http://www.ti.com/lit/ug/sprueq7c/sprueq7c.pdf
+OMAP-L138 - http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
+Kestone - http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf
+
+Required properties:
+
+- compatible:          "ti,davinci-aemif"
+                       "ti,keystone-aemif"
+                       "ti,omap-L138-aemif"
+
+- #address-cells:      Must be 2. The first cell is the memory partition
+                       number. The 0 partition is for chip selects. And the
+                       second cell is the offset into the partition, for the 0
+                       partition it corresponds to chip select offset.
+
+- #size-cells:         Must be set to 1.
+
+- reg:                 contains offset/length value for AEMIF control registers
+                       space.
+
+- ranges:              Must be set up to reflect the memory layout for 4
+                       chipselects and for AEMIF control range.
+
+- clocks:              phandle reference to the controller clock. Required only
+                       if clock tree data present in device tree.
+                       See clock-bindings.txt
+
+- clock-names:         clock name. It has to be "aemif". Required only if clock
+                       tree data present in device tree, in another case don't
+                       use it.
+                       See clock-bindings.txt
+
+- clock-ranges:                Empty property indicating that child nodes can inherit
+                       named clocks. Required only if clock tree data present
+                       in device tree.
+                       See clock-bindings.txt
+
+
+Child chip-select (cs) nodes contain the memory devices nodes connected to
+such as NOR (e.g. cfi-flash) and NAND (ti,davinci-nand, see davinci-nand.txt).
+There might be board specific devices like FPGAs.
+
+Required child cs node properties:
+
+- compatible:          "ti,davinci-cs"
+
+- #address-cells:      Must be 2. The first cell is the memory partition
+                       number. The 0 partition is for chip selects. And the
+                       second cell is the offset into the partition, for the 0
+                       partition it corresponds to chip select offset.
+
+- #size-cells:         Must be 1.
+
+- ranges:              Empty property indicating that child nodes can inherit
+                       memory layout.
+
+- clock-ranges:                Empty property indicating that child nodes can inherit
+                       named clocks. Required only if clock tree data present
+                       in device tree.
+
+Optional child cs node properties:
+
+
+- ti,bus-width:                        width of the asynchronous device's data bus
+                               8 or 16 if not preset 8
+
+- ti,davinci-cs-ss:            enable/disable select strobe mode
+                               In select strobe mode chip select behaves as
+                               the strobe and is active only during the strobe
+                               period. If present then enable.
+
+- ti,davinci-cs-ew:            enable/disable extended wait mode
+                               if set, the controller monitors the EMIFWAIT pin
+                               mapped to that chip select to determine if the
+                               device wants to extend the strobe period. If
+                               present then enable.
+
+- ti,davinci-cs-ta:            minimum turn around time, ns
+                               Time between the end of one asynchronous memory
+                               access and the start of another asynchronous
+                               memory access. This delay is not incurred
+                               between a read followed by read or a write
+                               followed by a write to same chip select.
+
+- ti,davinci-cs-rsetup:                read setup width, ns
+                               Time between the beginning of a memory cycle
+                               and the activation of read strobe.
+                               Minimum value is 1 (0 treated as 1).
+
+- ti,davinci-cs-rstobe:                read strobe width, ns
+                               Time between the activation and deactivation of
+                               the read strobe.
+                               Minimum value is 1 (0 treated as 1).
+
+- ti,davinci-cs-rhold:         read hold width, ns
+                               Time between the deactivation of the read
+                               strobe and the end of the cycle (which may be
+                               either an address change or the deactivation of
+                               the chip select signal.
+                               Minimum value is 1 (0 treated as 1).
+
+- ti,davinci-cs-wsetup:                write setup width, ns
+                               Time between the beginning of a memory cycle
+                               and the activation of write strobe.
+                               Minimum value is 1 (0 treated as 1).
+
+- ti,davinci-cs-wstrobe:       write strobe width, ns
+                               Time between the activation and deactivation of
+                               the write strobe.
+                               Minimum value is 1 (0 treated as 1).
+
+- ti,davinci-cs-whold:         write hold width, ns
+                               Time between the deactivation of the write
+                               strobe and the end of the cycle (which may be
+                               either an address change or the deactivation of
+                               the chip select signal.
+                               Minimum value is 1 (0 treated as 1).
+
+If any of the above parameters are absent, current parameter value will be taken
+from the corresponding HW reg.
+
+The name for cs node must be in format csN, where N is the cs number.
+For compatibles "ti,davinci-aemif" and "ti,keystone-aemif" N = [0-3].
+For compatible "ti,omap-L138-aemif" N = [2-5].
+
+Example for aemif, davinci nand and nor flash chip select shown below.
+
+memory-controller@21000A00 {
+       compatible = "ti,keystone-aemif";
+       #address-cells = <2>;
+       #size-cells = <1>;
+       clocks = <&clkaemif 0>;
+       clock-names = "aemif";
+       clock-ranges;
+       reg = <0x2100A00 0x00000100>;
+       ranges = <0 0 0x70000000 0x10000000
+                 1 0 0x21000A00 0x0000100>;
+
+       nand:cs2 {
+               compatible = "ti,davinci-cs";
+               #address-cells = <2>;
+               #size-cells = <1>;
+               clock-ranges;
+               ranges;
+
+               /* all timings in nanoseconds */
+               ti,davinci-cs-ta = <0>;
+               ti,davinci-cs-rhold = <7>;
+               ti,davinci-cs-rstrobe = <42>;
+               ti,davinci-cs-rsetup = <14>;
+               ti,davinci-cs-whold = <7>;
+               ti,davinci-cs-wstrobe = <42>;
+               ti,davinci-cs-wsetup = <14>;
+
+               nand@0,0x8000000 {
+                       compatible = "ti,davinci-nand";
+                       reg = <0 0x8000000 0x4000000
+                              1 0x0000000 0x0000100>;
+
+                       .. see davinci-nand.txt
+               };
+       };
+
+       nor:cs0 {
+               compatible = "ti,davinci-cs";
+               #address-cells = <2>;
+               #size-cells = <1>;
+               clock-ranges;
+               ranges;
+
+               /* all timings in nanoseconds */
+               ti,davinci-cs-ta = <0>;
+               ti,davinci-cs-rhold = <8>;
+               ti,davinci-cs-rstrobe = <40>;
+               ti,davinci-cs-rsetup = <14>;
+               ti,davinci-cs-whold = <7>;
+               ti,davinci-cs-wstrobe = <40>;
+               ti,davinci-cs-wsetup = <14>;
+               ti,davinci-cs-asize = <1>;
+
+               flash@0,0x0000000 {
+                       compatible = "cfi-flash";
+                       reg = <0 0x0000000 0x4000000>;
+
+                       ...
+               };
+       };
+};
--
1.7.9.5

