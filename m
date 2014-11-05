Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaKEWWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:22:14 -0500
Received: from 3.mo6.mail-out.ovh.net ([178.33.253.26]:44590 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751172AbaKEWWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:22:12 -0500
X-Greylist: delayed 18712 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 17:22:11 EST
MIME-Version: 1.0
In-Reply-To: <1415203287-21517-7-git-send-email-boris.brezillon@free-electrons.com>
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415203287-21517-7-git-send-email-boris.brezillon@free-electrons.com>
Date: Wed, 5 Nov 2014 17:22:57 +0100
Message-ID: <CACh+v5N8dXaH3ZNGr=MKXbQRU7nOMPLvxT0rEsZrbSKj20b_Dg@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] memory: atmel-ebi: add DT bindings documentation
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 5684105681774925848
X-Ovh-Remote: 209.85.215.48 (mail-la0-f48.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrheduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrheduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

2014-11-05 17:01 GMT+01:00 Boris Brezillon <boris.brezillon@free-electrons.com>:
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  .../bindings/memory-controllers/atmel-ebi.txt      | 153 +++++++++++++++++++++
>  1 file changed, 153 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
>
> diff --git a/Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt b/Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
> new file mode 100644
> index 0000000..dc2c34f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
> @@ -0,0 +1,153 @@
> +* Device tree bindings for Atmel EBI
> +
> +The External Bus Interface (EBI) controller is a bus where you can connect
> +asynchronous (NAND, NOR, SRAM, ....) and synchronous memories (SDR/DDR SDRAMs).
> +The EBI provides a glue-less interface to asynchronous memories though the SMC
> +(Static Memory Controller).
> +Synchronous memories (and some asynchronous memories like NANDs) can be
> +attached to specialized controllers which are responsible for configuring the
> +bus appropriately according to the connected device.
> +In the other hand, the bus interface can be automated for simple asynchronous
> +devices.
> +
> +Required properties:
> +
> +- compatible:          "atmel,at91sam9260-ebi"
> +                       "atmel,at91sam9261-ebi"
> +                       "atmel,at91sam9263-ebi0"
> +                       "atmel,at91sam9263-ebi1"
> +                       "atmel,at91sam9g45-ebi"
> +                       "atmel,at91sam9x5-ebi"
> +                       "atmel,sama5d3-ebi"
> +
> +- reg:                 Contains offset/length value for EBI memory mapping.
> +                       This property might contain several entries if the EBI
> +                       memory range is not contiguous
> +
> +- #address-cells:      Must be 2.
> +                       The first cell encodes the CS.
> +                       The second cell encode the offset into the CS memory
> +                       range.
> +
> +- #size-cells:         Must be set to 1.
> +
> +- ranges:              Encodes CS to memory region association.
> +
> +- clocks:              Clock feeding the EBI controller.
> +                       See clock-bindings.txt
> +
> +Child chip-select (cs) nodes contain the memory devices nodes connected to
> +such as NOR (e.g. cfi-flash) and NAND.
> +There might be board specific devices like FPGAs.
> +You'll define you device requirements in these child nodes.
> +
> +Required child cs node properties:
> +
> +- #address-cells:      Must be 2.
> +
> +- #size-cells:         Must be 1.
> +
> +- ranges:              Empty property indicating that child nodes can inherit
> +                       memory layout.
> +
> +Optional child cs node properties:
> +- atmel,generic-dev            boolean property specifying if the device is
> +                               a generic device.
> +                               The following properties are only parsed if
> +                               this property is present.
> +                               Specialized devices are attached to specialized
> +                               controllers which should configure the bus
> +                               appropriately.

What do you mean by specialized devices ? Can you give an example ?

> +
> +- atmel,bus-width:             width of the asynchronous device's data bus
> +                               8, 16 or 32.
> +                               8 if not present.
> +
> +- atmel,byte-access-type       "write" or "select" (see Atmel datasheet).
> +                               "select" if not present.
> +
> +- atmel,read-mode              "nrd" or "ncs".
> +                               "ncs" is not present.
> +
> +- atmel,write-mode             "nwe" or "ncs".
> +                               "ncs" is not present.
> +
> +- atmel,exnw-mode              "disabled", "frozen" or "ready".
> +                               "disabled" if not present.
> +
> +- atmel,page-mode              enable page mode if present. The provided value
> +                               defines the page size (supported values: 4, 8,
> +                               16 and 32).
> +
> +Optional device timings expressed in nanoseconds (if the property is not
> +present 0 is assumed):
> +
> +- atmel,ncs-rd-setup-ns
> +- atmel,nrd-setup-ns
> +- atmel,ncs-wr-setup-ns
> +- atmel,nwe-setup-ns
> +- atmel,ncs-rd-pulse-ns
> +- atmel,nrd-pulse-ns
> +- atmel,ncs-wr-pulse-ns
> +- atmel,nwe-pulse-ns
> +- atmel,nwe-cycle-ns
> +- atmel,nrd-cycle-ns
> +- atmel,tdf-ns
> +
> +- atmel,tdf-optimized          data float optimized mode. If present the data
> +                               float time is optimized depending on the next
> +                               device being accessed (next device setup
> +                               time is substracted to the current devive data
> +                               float time).
> +
> +
> +
> +Example:
> +
> +       ebi: ebi@10000000 {
> +               compatible = "atmel,sama5d3-ebi", "simple-bus";
> +               #address-cells = <2>;
> +               #size-cells = <1>;
> +               atmel,smc = <&hsmc>;
> +               atmel,matrix = <&matrix>;
> +               reg = <0x10000000 0x10000000
> +                      0x40000000 0x30000000>;
> +               ranges = <0x0 0x0 0x10000000 0x10000000
> +                         0x1 0x0 0x40000000 0x10000000
> +                         0x2 0x0 0x50000000 0x10000000
> +                         0x3 0x0 0x60000000 0x10000000>;
> +               clocks = <&mck>;
> +
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&pinctrl_ebi_addr>;
> +
> +               cs@0 {
> +                       #address-cells = <2>;
> +                       #size-cells = <1>;
> +                       ranges;
> +                       atmel,generic-dev;
> +                       atmel,read-mode = "nrd";
> +                       atmel,write-mode = "nwe";
> +                       atmel,bus-width = <16>;
> +                       atmel,ncs-rd-setup-ns = <0>;
> +                       atmel,ncs-wr-setup-ns = <0>;
> +                       atmel,nwe-setup-ns = <8>;
> +                       atmel,nrd-setup-ns = <16>;
> +                       atmel,ncs-rd-pulse-ns = <84>;
> +                       atmel,ncs-wr-pulse-ns = <84>;
> +                       atmel,nrd-pulse-ns = <76>;
> +                       atmel,nwe-pulse-ns = <76>;
> +                       atmel,nrd-cycle-ns = <107>;
> +                       atmel,nwe-cycle-ns = <84>;
> +                       atmel,tdf-ns = <16>;
> +
> +                       nor: flash@0,0 {
> +                               compatible = "cfi-flash";
> +                               #address-cells = <1>;
> +                               #size-cells = <1>;
> +                               reg = <0x0 0x0 0x1000000>;
> +                               bank-width = <2>;
> +                       };
> +               };
> +       };
> +
> --
> 1.9.1
>
