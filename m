Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaCJP1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:27:10 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:20178
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbaCJP1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:27:06 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h19b6n1155h)
Date: Mon, 10 Mar 2014 16:26:53 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, <monstr@monstr.eu>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <michal.simek@xilinx.com>,
        <linux-can@vger.kernel.org>, <robh+dt@kernel.org>,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        <grant.likely@linaro.org>, Kedareswara rao Appana <appanad@xilinx.com>,
        <wg@grandegger.com>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v5] can: xilinx CAN controller support.
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local> <531DD493.3030306@monstr.eu> <531DD5E7.7090406@pengutronix.de> <3245971.RIuVmbVL0Z@wuerfel>
In-Reply-To: <3245971.RIuVmbVL0Z@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <1964213d-6bd9-49fa-805e-42e1e0630fd5@VA3EHSMHS029.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 04:15 PM, Arnd Bergmann wrote:
> On Monday 10 March 2014 16:10:31 Marc Kleine-Budde wrote:
>>>>> +config CAN_XILINXCAN
>>>>> +   tristate "Xilinx CAN"
>>>>> +   depends on ARCH_ZYNQ || MICROBLAZE
>>>>
>>>> Is Zynq multiarch already?
>>>
>>> let me just answer this. Zynq is device with hardcoded dual arm cortex-a9 + some IPs
>>> and programmable logic.
>>> It means if you add Microblaze to PL or another CPU then you get multi architecture setup.
>>
>> Sorry for the confusion, I'm not talking about
>> more-than-one-architecture-in-a-FPGA, but the feature of the ARM-Linux
>> Kernel to run on different ARM architecture. For example, it's possible
>> to start the same kernel on a freescale imx6 and a the new marvel ebu
>> platform. If the Zynq Kernel supports this feature, too, we should not
>> limit to ARCH_ZYNQ, but use ARM instead.
> 
> Zynq has been multiplatform capable from the start. Ideally we'd let
> users build the driver for any architecture and specify the exact
> dependencies, it doesn't even have to be limited to ARM.
> 
> You probably want something like
> 
> 	config CAN_XILINX
> 	tristate "Xilinx CAN"
> 	depends on ARCH_ZYNQ || MICROBLAZE || COMPILE_TEST
> 	depends on COMMON_CLK && HAS_MMIO  # whatever you need for other architectures

Fengguang: Are you use COMPILE_TEST in zero day testing system?

Thanks,
Michal


