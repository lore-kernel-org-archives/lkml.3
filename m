Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3HZN6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:58:09 -0400
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:48445 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751722Ab3HZN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:58:07 -0400
Message-ID: <521B5947.6050009@overkiz.com>
Date: Mon, 26 Aug 2013 15:33:59 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH v2 2/2] ARM: at91/dt: define phy available on sama5d3
 mother board
References: <1377520431-21807-1-git-send-email-b.brezillon@overkiz.com> <1377520540-21884-1-git-send-email-b.brezillon@overkiz.com> <521B5648.3020608@cogentembedded.com>
In-Reply-To: <521B5648.3020608@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6446902866629785783
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei,

On 26/08/2013 15:21, Sergei Shtylyov wrote:
> Hello.
>
> On 26-08-2013 16:35, Boris BREZILLON wrote:
>
>> This patch describe the phy used on atmel sama5d3 mother board:
>>   - phy address
>>   - phy interrupt pin
>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   arch/arm/boot/dts/sama5d3xmb.dtsi |    8 ++++++++
>>   1 file changed, 8 insertions(+)
>
>> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi 
>> b/arch/arm/boot/dts/sama5d3xmb.dtsi
>> index 8a9e05d..e9521d5 100644
>> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
>> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
>> @@ -81,6 +81,14 @@
>>
>>               macb1: ethernet@f802c000 {
>>                   phy-mode = "rmii";
>> +
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +                phy0: ethernet-phy@0 {
>
>    Address part of the node name doesn't match the "reg" property.

Indeed, I based my definition on arch/arc/boot/dts/angel4.dts where phy 
is registered like this :

             phy0: ethernet-phy@0 {
                 reg = <1>;
             };

I think it's buggy there too, because I checked other dts files and they 
all put the same address
after @ and in reg register.

I'll fix this fot the next version.

Thanks

Best Regards,
Boris



>
>> +                    interrupt-parent = <&pioE>;
>> +                    interrupts = <30 IRQ_TYPE_EDGE_FALLING>;
>> +                    reg = <1>;
>> +                };
>
> WBR, Sergei
>

