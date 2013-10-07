Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3JGJUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:20:10 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:49778
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab3JGJUH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:20:07 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2dI98dI9371Ic89bh542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h186068h18602eh8275bhz2fh95h839h947hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i307k1155h192ch)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Michal Simek <michals@xilinx.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Michal Simek <michals@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        =?iso-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
        "Steven A. Falco" <sfalco@harris.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "monstr@monstr.eu" <monstr@monstr.eu>
Subject: RE: [PATCH v2 2/3] i2c: xilinx: Set tx direction in write operation
Thread-Topic: [PATCH v2 2/3] i2c: xilinx: Set tx direction in write operation
Thread-Index: AQHOveeHuN8/1Zg/vEWxtjnyhoQOhpnjiEKAgABFEoCAACHwgIAABKsAgAAP+QCAAAg5AP///9eAgATB1dA=
Date: Mon, 7 Oct 2013 09:19:57 +0000
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
 <57a4f5352ce6f03bde7aafe8b880f91b52994379.1380550490.git.michal.simek@xilinx.com>
 <20131004054636.GC3194@katana> <524E902D.8030809@monstr.eu>
 <20131004115517.GA2994@katana> <524EB090.2070708@metafoo.de>
 <524EBDF6.1070605@monstr.eu> <524EC4DC.1020708@metafoo.de>
 <524EC4B9.7000202@monstr.eu>
In-Reply-To: <524EC4B9.7000202@monstr.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.255]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <b5a351c5-82cc-4c55-ae53-0e2a9793eab3@CH1EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Friday, October 04, 2013 7:08 PM
> To: Lars-Peter Clausen
> Cc: Wolfram Sang; Michal Simek; linux-kernel@vger.kernel.org; Appana
> Durga Kedareswara Rao; Appana Durga Kedareswara Rao; Jean Delvare;
> Peter Korsgaard; linux-i2c@vger.kernel.org; Richard Röjfors; Steven A. Falco
> Subject: Re: [PATCH v2 2/3] i2c: xilinx: Set tx direction in write operation
>
> On 10/04/2013 03:38 PM, Lars-Peter Clausen wrote:
> > On 10/04/2013 03:09 PM, Michal Simek wrote:
> >>
> >>
> >> On 10/04/2013 02:12 PM, Lars-Peter Clausen wrote:
> >>> On 10/04/2013 01:55 PM, Wolfram Sang wrote:
> >>>> On Fri, Oct 04, 2013 at 11:53:49AM +0200, Michal Simek wrote:
> >>>>> On 10/04/2013 07:46 AM, Wolfram Sang wrote:
> >>>>>>
> >>>>>>> +     cr = xiic_getreg32(i2c, XIIC_CR_REG_OFFSET);
> >>>>>>> +     cr |= XIIC_CR_DIR_IS_TX_MASK;
> >>>>>>> +     xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, cr);
> >>>>>>> +
> >>>>>>
> >>>>>> Is there no need to clear the bit again when receiving?
> >>>>>
> >>>>> This bit is cleared in xiic_xfer() -> xiic_start_xfer()
> >>>>> ->xiic_reinit()
> >>>>>
> >>>>> xiic_setreg8(i2c, XIIC_CR_REG_OFFSET,
> XIIC_CR_TX_FIFO_RESET_MASK);
> >>>>
> >>>> A bit implicit, but OK.
> >>>>
> >>>>>> And did
> >>>>>> transferring ever work if this bit was never set before?
> >>>>>
> >>>>> I really don't know. We have switched from old driver to this new
> >>>>> mainline one and based on our eeprom testing we have found that
> this bit hasn't been setup properly.
> >>>>>
> >>>>> It is described here.
> >>>>>
> http://www.xilinx.com/support/documentation/ip_documentation/axi_i
> >>>>> ic/v1_02_a/axi_iic_ds756.pdf
> >>>>> page 28 - step 3.
> >>>>>
> >>>>> IIC Master Transmitter with a Repeated Start 1. Write the IIC
> >>>>> device address to the TX_FIFO.
> >>>>> 2. Write data to TX_FIFO.
> >>>>> 3. Write to Control Register (CR) to set MSMS = 1 and TX = 1.
> >>>>> 4. Continue writing data to TX_FIFO.
> >>>>> 5. Wait for transmit FIFO empty interrupt. This implies the IIC has
> throttled the bus.
> >>>>> 6. Write to CR to set RSTA = 1.
> >>>>
> >>>> Repeated start is not happening in the driver as well, or am I
> >>>> overlooking something?
> >>>>
> >>>>> 7. Write IIC device address to TX_FIFO.
> >>>>> 8. Write all data except last byte to TX_FIFO.
> >>>>> 9. Wait for transmit FIFO empty interrupt. This implies the IIC has
> throttled the bus.
> >>>>> 10. Write to CR to set MSMS = 0. The IIC generates a stop condition at
> the end of the last byte.
> >>>>> 11. Write last byte of data to TX_FIFO.
> >>>>
> >>>> CCing more people who worked on the driver in the past and might
> >>>> have experiences
> >>>
> >>> The current version works fine here. The driver uses whats described
> >>> in the datasheet as "dynamic controller logic flow" and not the
> >>> "standard controller logic flow". The sequence Michal mentioned
> >>> above is from the "standard controller logic flow" section.
> >>
> >> Does this change break "dynamic controller logic flow"?
> >
> > Not sure, but I would assume that the bit is ignored in this mode. But
> > I don't think the patch should be applied since this step is not in
> > the sequence of steps that should be done.
>
> Kedar: Can you please look at both these modes and provide feedback?

The driver is following the Dynamic controller logic flow as per the dynamic
Controller logic flow. These bits need not to be set.

It was my mistake. Please ignore this patch.
There was an incorrect h/w design on which I tested this that's why I thought it is a
Solution for this.

Now I tested with the proper h/w design it is working fine for me without setting this bit.
Thanks lars for the feedback.

Regards,
Kedar.
>
> Thanks,
> Michal
>
> --
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture Microblaze U-
> BOOT custodian and responsible for u-boot arm zynq platform
>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


