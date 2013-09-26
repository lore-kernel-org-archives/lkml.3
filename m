Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3IZIR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:17:57 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36385
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab3IZIRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:17:53 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzbb2dI98dI9371I1432I4015I14ffIdb82hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh19b6n1155h192ch)
Date: Thu, 26 Sep 2013 10:16:45 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] arm: zynq: Enable global timer
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com> <5242FF4B.6050901@linaro.org>
In-Reply-To: <5242FF4B.6050901@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <62570dec-da98-42a2-93b9-6ab1f8adb30d@CH1EHSMHS037.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 09/25/2013 05:20 PM, Daniel Lezcano wrote:
> On 09/18/2013 08:48 PM, Soren Brinkmann wrote:
>> Hi all,
>>
>> here's a v2. I reused the subject from my v1 submission although the focus of
>> this series moved a bit towards the timer subsystem.
>> I replaced Stephen's fix to prevent per cpu devices from becoming
>> the broadcast device with Thomas' proposal, but I kept the original commit
>> message. I split the whole approach in small chunks that I found reasonable.
>>
>> In 4/4, I picked up Grant's comment regarding the DT node name.
>>
>> v2:
>>  - drop 1/2 of the original series
>>  - implement preventing per cpu devices from becoming broadcast device according
>>    to Thomas' proposal
>>    - introduce new CLOCK_EVT_FEAT_PERCPU flag
>>    - set the flag for the arm_global_timer
>>    - filter per cpu devices based on this flag when choosing the broadcast
>>      device
>>  - rename DT node to avoid '_'s
>>  
>>
>> Soren Brinkmann (4):
>>   clockchips: Add FEAT_PERCPU clockevent flag
>>   clocksource/arm_global_timer: Set FEAT_PERCPU flag
>>   tick: broadcast: Deny per-cpu clockevents from being broadcast sources
>>   arm: zynq: Enable arm_global_timer
>>
>>  arch/arm/boot/dts/zynq-7000.dtsi       | 8 ++++++++
>>  arch/arm/mach-zynq/Kconfig             | 1 +
>>  drivers/clocksource/arm_global_timer.c | 3 ++-
>>  include/linux/clockchips.h             | 1 +
>>  kernel/time/tick-broadcast.c           | 1 +
>>  5 files changed, 13 insertions(+), 1 deletion(-)
> 
> This patches falls under different maintainer's umbrella.
> 
> I acked-by the patches, so if someone is willing to take the patches I
> am ok with that. I am ok also to pick them into my tree with the
> acked-by maintainer. Just let me know ...
> 

Yes, please add also this zynq specific patch through your tree.

Here is my ACK for that.
Acked-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal


