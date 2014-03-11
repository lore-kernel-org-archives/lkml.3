Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaCKHZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:25:40 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:5547 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbaCKHZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:25:37 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z579ehzbb2dI98dI9371I542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh1de097h186068h18602ehz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: "monstr@monstr.eu" <monstr@monstr.eu>, Mark Rutland <mark.rutland@arm.com>
CC: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "kpc528@gmail.com" <kpc528@gmail.com>,
        "kalluripunnaiahchoudary@gmail.com" 
	<kalluripunnaiahchoudary@gmail.com>
Subject: RE: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc
 controller
Thread-Topic: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc
 controller
Thread-Index: AQHPPE+QF3+ctQo4UkSQ6/2fJrkIyZrZsX4AgAHLpbA=
Date: Tue, 11 Mar 2014 07:25:24 +0000
References: <4adb2b4b-2ad6-42b9-929e-cc062f817245@TX2EHSMHS021.ehs.local>
 <20140310105655.GH14999@e106331-lin.cambridge.arm.com>
 <531DA900.5060202@monstr.eu>
In-Reply-To: <531DA900.5060202@monstr.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.92.172]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <2da88be0-6cbf-4cf5-9aa9-453084863da7@TX2EHSMHS038.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Michal Simek [mailto:monstr@monstr.eu]
>Sent: Monday, March 10, 2014 5:29 PM
>To: Mark Rutland
>Cc: Punnaiah Choudary Kalluri; dougthompson@xmission.com;
>devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; linux-kernel@vger.kernel.org; linux-
>edac@vger.kernel.org; Michal Simek; robh+dt@kernel.org; Pawel Moll;
>ijc+devicetree@hellion.org.uk; galak@codeaurora.org; rob@landley.net;
>kpc528@gmail.com; kalluripunnaiahchoudary@gmail.com; Punnaiah Choudary
>Kalluri
>Subject: Re: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc
>controller
>
>On 03/10/2014 11:56 AM, Mark Rutland wrote:
>> On Sun, Mar 09, 2014 at 02:57:16AM +0000, Punnaiah Choudary Kalluri
>wrote:
>>> Added EDAC support for reporting the ecc errors of zynq ddr controller.
>>> The ddr ecc controller corrects single bit errors and detects double
>>> bit errors
>>>
>>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>>> ---
>>>  .../devicetree/bindings/edac/zynq_edac.txt         |   18 +
>>>  drivers/edac/Kconfig                               |    7 +
>>>  drivers/edac/Makefile                              |    1 +
>>>  drivers/edac/zynq_edac.c                           |  613 ++++++++++++++++++++
>>>  4 files changed, 639 insertions(+), 0 deletions(-)  create mode
>>> 100644 Documentation/devicetree/bindings/edac/zynq_edac.txt
>>>  create mode 100644 drivers/edac/zynq_edac.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/edac/zynq_edac.txt
>>> b/Documentation/devicetree/bindings/edac/zynq_edac.txt
>>> new file mode 100644
>>> index 0000000..c21ff83
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/edac/zynq_edac.txt
>>> @@ -0,0 +1,18 @@
>>> +Zynq EDAC driver, it does reports the DDR ECC single bit errors that
>>> +are corrected and double bit ecc errors that are detected by the DDR ECC
>controller.
>>> +ECC support for DDR is available in half-bus width(16 bit) configuration
>only.
>>> +
>>> +Required properties:
>>> +- compatible: Should be "xlnx,ps7-ddrc" or "xlnx,ps7-ddrc-1.00.a"
>>
>> Is this an or or a xor?
>
>Compatible string should be just xlnx,zynq-ddrc-1.00.a.
>Nothing with ps7.
Hi Mark and Michal,

I will correct the binding info and send the next version

Regards,
Punnaiah
>
>Thanks,
>Michal
>
>
>--
>Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
>w: www.monstr.eu p: +42-0-721842854
>Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
>Maintainer of Linux kernel - Xilinx Zynq ARM architecture Microblaze U-BOOT
>custodian and responsible for u-boot arm zynq platform
>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


