Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3KGKM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:12:57 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48725 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3KGKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:12:51 -0500
Message-ID: <527B679D.8040602@gmail.com>
Date: Thu, 07 Nov 2013 11:12:45 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 8/9] ARM: add Armada 1500-mini and Chromecast device
 tree files
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1383661723-17956-9-git-send-email-sebastian.hesselbarth@gmail.com> <20131107134802.2234bff1@xhacker>
In-Reply-To: <20131107134802.2234bff1@xhacker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 06:48, Jisheng Zhang wrote:
> On Tue, 5 Nov 2013 06:28:42 -0800
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>> This adds very basic device tree files for the Marvell Armada
>> 1500-mini SoC (Berlin BG2CD) and the Google Chromecast. Currently,
>> SoC only has nodes for cpu, some clocks, l2 cache controller, local
>> timer, apb timers, uart, and interrupt controllers.
>> The Google Chromecast is a consumer device comprising the Armada
>> 1500-mini SoC above.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
[...]
>> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi
>> b/arch/arm/boot/dts/berlin2cd.dtsi new file mode 100644
>> index 0000000..40d1bed
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
>> @@ -0,0 +1,212 @@
>> +/*
>> + * Device Tree Include file for Marvell Armada 1500-mini (Berlin BG2CD) SoC
>> + *
>> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> + *
>> + * based on GPL'ed 2.6 kernel sources
>> + *  (c) Marvell International Ltd.
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include "skeleton.dtsi"
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>> +
>> +/ {
>> +       model = "Marvell Armada 1500-mini (BG2CD) SoC";
>> +       compatible = "marvell,berlin2cd", "marvell,berlin";
>> +
>> +       cpus {
>> +               #address-cells = <1>;
>> +               #size-cells = <0>;
>> +
>> +               cpu@0 {
>> +                       compatible = "arm,cortex-a9";
>> +                       device_type = "cpu";
>> +                       next-level-cache = <&l2>;
>> +                       reg = <0>;
>> +               };
>> +       };
>> +
[...]
>> +       soc {
>> +               compatible = "simple-bus";
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               interrupt-parent = <&gic>;
>> +
>> +               ranges = <0 0xf7000000 0x1000000>;
>> +
>> +               l2: l2-cache-controller@ac0000 {
>> +                       compatible = "arm,pl310-cache";
>> +                       reg = <0xac0000 0x1000>;
>> +                       cache-unified;
>> +                       cache-level = <2>;
>> +                       arm,prefetch-ctrl = <0x70000007>;
>> +                       arm,pwr-ctrl = <0x3>;
> These two setting depend on the following prefetch and power control support patch.
> We have it in our internal tree for a long time.
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/209700.html

Right, consider the above as a debug left-over. I was blindly guessing
and picked that patch and the both properties above from your tree.

Will remove them now, we can add them later when the binding has been
accepted. I will reply to that patch next, I guess arm,prefetch-ctrl
will not be accepted that way, as we try to avoid hex-bashing
properties.

I did some research on feature/property matrix for the l2x0/l310 as
there is public documentation, hope to find some time to polish the
matrix and get a patch ready.

>> +               };
>> +
>> +               gic: interrupt-controller@ad1000 {
>> +                       compatible = "arm,cortex-a9-gic";
>> +                       reg = <0xad1000 0x1000>, <0xad0100 0x0100>;
>> +                       interrupt-controller;
>> +                       #interrupt-cells = <3>;
>> +               };
>> +
>> +               local-timer@ad0600 {
>> +                       compatible = "arm,cortex-a9-twd-timer";
>> +                       reg = <0xad0600 0x20>;
>> +                       interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
>> +                       clocks = <&sysclk>;
>> +               };
>> +
>> +               apb@e80000 {
>> +                       compatible = "simple-bus";
>> +                       #address-cells = <1>;
>> +                       #size-cells = <1>;
>> +
>> +                       ranges = <0 0xe80000 0x10000>;
>> +                       interrupt-parent = <&aic>;
>> +
>> +                       timer0: timer@2c00 {
>> +                               compatible = "snps,dw-apb-timer";
> snps,dw-apb-timer-osc?

As stated in the cover letter, snps,dw-apb-timer-osc/-sp have been
deprecated by [1].

[1] http://www.spinics.net/lists/arm-kernel/msg277763.html

>> +                               reg = <0x2c00 0x14>;
>> +                               interrupts = <8>;
>> +                               clocks = <&cfgclk>;
>> +                               clock-names = "timer";
>> +                               status = "okay";
>> +                       };
>> +
>> +                       timer1: timer@2c14 {
>> +                               compatible = "snps,dw-apb-timer";
> ditto for the remaining

ditto.

Sebastian
