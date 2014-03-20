Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaCTEmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:42:08 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:23764 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbaCTEmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:42:04 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh1de097h186068h18602ehz2fh95h109h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h2668h906i2673i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: "monstr@monstr.eu" <monstr@monstr.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Michal Simek <michals@xilinx.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: RE: [PATCH v5] can: xilinx CAN controller support.
Thread-Topic: [PATCH v5] can: xilinx CAN controller support.
Thread-Index: AQHPPHECe+/Jq2y0+ECMRZjewV7Xtprb18QMgADdYgCADL7c0A==
Date: Thu, 20 Mar 2014 04:41:56 +0000
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local>
 <531DD2C4.5060109@pengutronix.de>
 <f1e2f08f-05fc-40d3-8437-4c6817d631cb@AM1EHSMHS010.ehs.local>
 <531F0636.4050608@pengutronix.de> <53203088.2070605@monstr.eu>
In-Reply-To: <53203088.2070605@monstr.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.96.18]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <45bec219-6349-4bcf-be8a-7ee1dfd1bcb9@TX2EHSMHS014.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2K4gD8M019294

Hi Marc,

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Wednesday, March 12, 2014 3:32 PM
> To: Marc Kleine-Budde
> Cc: Appana Durga Kedareswara Rao; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; robh+dt@kernel.org;
> grant.likely@linaro.org; Michal Simek; wg@grandegger.com;
> fengguang.wu@intel.com
> Subject: Re: [PATCH v5] can: xilinx CAN controller support.
>
> On 03/11/2014 01:48 PM, Marc Kleine-Budde wrote:
> > On 03/11/2014 01:34 PM, Appana Durga Kedareswara Rao wrote:
> >
> >>>> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> >>>> index
> >>>> 9e7d95d..b180239 100644
> >>>> --- a/drivers/net/can/Kconfig
> >>>> +++ b/drivers/net/can/Kconfig
> >>>> @@ -125,6 +125,13 @@ config CAN_GRCAN
> >>>>       endian syntheses of the cores would need some modifications on
> >>>>       the hardware level to work.
> >>>>
> >>>> +config CAN_XILINXCAN
> >>>> +   tristate "Xilinx CAN"
> >>>> +   depends on ARCH_ZYNQ || MICROBLAZE
> >>>
> >>> Is Zynq multiarch already?
> >> Discussions are going on this
> >> So the final thing that Fengguang ( fengguang.wu@intel.com) Proposed
> >> is
> >>         config CAN_XILINX
> >>         tristate "Xilinx CAN"
> >>         depends on ARCH_ZYNQ || MICROBLAZE || COMPILE_TEST
> >>         depends on COMMON_CLK && HAS_MMIO  # whatever you need for
> >> other architectures
> >
> >> Are you Ok for this?
> >
> > You have to fill the 2nd depends on with some sane values, though.
>
> This should be that one
> config CAN_XILINX
>          tristate "Xilinx CAN"
>          depends on ARCH_ZYNQ || MICROBLAZE || COMPILE_TEST
>          depends on COMMON_CLK && HAS_IOMEM
>
>
> Is there any driver which is in CAN which not use MMIO accesses?
> If not, maybe we should just add dependency to



Can you please comment on this?
I had update driver with all the other comments I had a little confusion regarding
Which Kconfig options I need to use.

Regards,
Kedar.


> Thanks,
> Michal
>
>
>
> --
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture Microblaze U-
> BOOT custodian and responsible for u-boot arm zynq platform
>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
