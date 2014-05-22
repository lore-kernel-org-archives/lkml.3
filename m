Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaEVSFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:05:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50078 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaEVSFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:05:34 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 02/47] mtd: nand: stm_nand_bch: provide Device Tree
 documentation
Thread-Topic: [PATCH 02/47] mtd: nand: stm_nand_bch: provide Device Tree
 documentation
Thread-Index: Ac916Fnu9MieOYLQQS60OY/GFi7QEw==
Date: Thu, 22 May 2014 18:05:03 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAD826F@DBDE04.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: linux-mtd [mailto:linux-mtd-bounces@lists.infradead.org] On Behalf Of Lee Jones
>
>This is where we describe the different new and generic options used by
>the ST BCH driver.
>
>Cc: devicetree@vger.kernel.org
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> Documentation/devicetree/bindings/mtd/stm-nand.txt | 123 +++++++++++++++++++++
> 1 file changed, 123 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt
>
>diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt
>b/Documentation/devicetree/bindings/mtd/stm-nand.txt
>new file mode 100644
>index 0000000..9f9325f
>--- /dev/null
>+++ b/Documentation/devicetree/bindings/mtd/stm-nand.txt
>@@ -0,0 +1,123 @@
>+STM BCH NAND Support
>+--------------------
>+
>+Required properties:
>+
>+- compatible		: Should be "st,nand-bch"
>+- reg			: Should contain register's location and length
>+- reg-names		: "nand_mem" - NAND Controller register map
>+			  "nand_dma" - BCH Controller DMA configuration map
>+- interrupts		: Interrupt number
>+- interrupt-names	: "nand_irq" - NAND Controller IRQ
>+- st,nand-banks		: Subnode representing one or more "banks" of NAND
>+                          Flash, connected to an STM NAND Controller (see
>+                          description below).
>+- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
>+- st,bch-bitflip-threshold
>+			: The threshold at which the number of corrected bit-
>+			  flips per sector is deemed to have reached an
>+			  excessive level (triggers '-EUCLEAN' to be returned
>+			  to the caller).  The value should be in the range 1
>+			  to <ecc-strength> where <ecc-strength> is 18 or 30,
>+			  depending on the BCH ECC mode in operation.  A value
>+			  of 0, or if left unspecified, is interpreted by the
>+			  driver as <ecc-strength>.
>+
Please drop this one as discussed in other thread that bitflip_threshold
does not qualify as DT binding (as it's not a hardware or const parameter).

>+Properties describing Bank of NAND Flash ("st,nand-banks"):
>+
>+- st,nand-csn		: Chip select associated with the Bank.
>+- st,nand-timing-spec	: [Optional] NAND Device Timing Data.  All times
>+                          expressed in ns, except where stated otherwise:

I think DT maintainers don't prefer NAND timings being passed by DT,
Instead they want it parsed from ONFI.
Refer comments by 'Rob Herring <robherring2@gmail.com>' on
[PATCH RFC 1/3] Devicetree: Add pl353 smc controller devicetree binding information


>+                            tR           : Max Page Read delay [us]

(1) Even if you end up requiring these bindings, then please add them
to NAND generic bindings so that other drivers can re-use them.
(2) It would be good to have DT-bindings suffixed with timing units
like "ns" | "ps". Example: "tR-us" or something similar.

[...]

>+Note, during initialisation, the NAND Controller timing registers are configured
>+according to one of the following methods, in order of precedence:
>+
>+           1. Configuration based on "st,nand_timing_spec" if supplied.
>+
Not sure if this mode is really required, as almost all devices are ONFI compliant.
Please check with 'Rob Herring <robherring2@gmail.com>'

>+           2. Configuration based on ONFI timing mode, as advertised by the
>+              device during ONFI-probing (ONFI-compliant NAND only).
>+
>+           3. Use reset/safe timing values
>+


with regards, pekon
