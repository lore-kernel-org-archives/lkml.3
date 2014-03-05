Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaCEHFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:05:17 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:30729 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaCEHFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:05:14 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 02:05:14 EST
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9DbcbmpiO4kpRBxeDg+g==
X-RZG-CLASS-ID: mo00
Message-ID: <5316CB29.7040200@hartkopp.net>
Date: Wed, 05 Mar 2014 07:58:49 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        wg@grandegger.com, mkl@pengutronix.de, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v5] can: xilinx CAN controller support.
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local> <1b9f22ac-4dde-4ecc-885a-3d8081157081@AM1EHSMHS012.ehs.local>
In-Reply-To: <1b9f22ac-4dde-4ecc-885a-3d8081157081@AM1EHSMHS012.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05.03.2014 00:51, Sören Brinkmann wrote:
> Hi Kedar,
> 
> On Tue, 2014-03-04 at 06:50PM +0530, Kedareswara rao Appana wrote:
>> This patch adds xilinx CAN controller support.
>> This driver supports both ZYNQ CANPS and Soft IP
>> AXI CAN controller.
>>
> [...]
>> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
>> new file mode 100644
>> index 0000000..0e57103
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
>> @@ -0,0 +1,45 @@
>> +Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
>> +---------------------------------------------------------
>> +
>> +Required properties:
>> +- compatible		: Should be "xlnx,zynq-can-1.00.a" for Zynq CAN
>> +			  controllers and "xlnx,axi-can-1.00.a" for Axi CAN
>> +			  controllers.
>> +- reg			: Physical base address and size of the Axi CAN/Zynq
>> +			  CANPS registers map.
>> +- interrupts		: Property with a value describing the interrupt
>> +			  number.
>> +- interrupt-parent	: Must be core interrupt controller
>> +- clock-names		: List of input clock names - "ref_clk", "aper_clk"
> 
> Let's reconsider these names. These are rather Zynq specific names. Does
> the IP documentation use these as well? The names should match the
> naming used for the IP, rather than the SOC. Is this the correct data sheet:
> http://www.xilinx.com/support/documentation/ip_documentation/axi_can/v1_03_a/ds791_axi_can.pdf
> ? According to that the names should rather be 's_axi_aclk' and
> 'can_clk', IMHO.
> 
> 	Sören
> 

And when renaming stuff anyway:

+
+#define DRIVER_NAME	"XILINX_CAN"
+

should be changed to

+
+#define DRIVER_NAME	"xilinx_can"
+

Regards,
Oliver

