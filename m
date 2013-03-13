Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3CMQlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:41:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57559 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3CMQlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:41:44 -0400
Message-ID: <5140AC2C.50309@ti.com>
Date: Wed, 13 Mar 2013 17:41:16 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        "elezegarcia@gmail.com" <elezegarcia@gmail.com>,
        "ebutera@gmail.com" <ebutera@gmail.com>,
        "javier.martinez@collabora.co.uk" <javier.martinez@collabora.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: dts: Add uart1 and uart2 to igep boards.
References: <1355326422-12357-1-git-send-email-matthias.bgg@gmail.com> <50C8AC3C.9020908@ti.com> <CABuKBeJsHCq98Pe-BwPajbQ+2OLQpwrbtVTJe=j9thPDQCCBrg@mail.gmail.com> <CAAwP0s01Jxh0f-T0sd5D980dZPcEV0J1KzjPbNHkrXLaKA3YUg@mail.gmail.com> <CABuKBeJsg_P=aDr0s9iVOD+7YTNoVUFQJCJymJyJ7NqXHUBzKQ@mail.gmail.com> <511E0807.8000200@ti.com> <CAAwP0s3bs=uqCRPgQiXQUnHq-6L61ayrP0WrXdJrNxNuGfmV0A@mail.gmail.com>
In-Reply-To: <CAAwP0s3bs=uqCRPgQiXQUnHq-6L61ayrP0WrXdJrNxNuGfmV0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 03/02/2013 02:52 AM, Javier Martinez Canillas wrote:
> On Fri, Feb 15, 2013 at 11:03 AM, Cousson, Benoit <b-cousson@ti.com> wrote:
>> Hi Matthias,
>>
>>
>> On 2/15/2013 10:35 AM, Matthias Brugger wrote:
>>>
>>> 2013/1/26 Javier Martinez Canillas <martinez.javier@gmail.com>:
>>>>
>>>> On Sat, Jan 26, 2013 at 4:16 PM, Matthias Brugger
>>>> <matthias.bgg@gmail.com>
>>>> wrote:
>>>>>
>>>>> Hi Benoit,
>>>>>
>>>>> 2012/12/12 Benoit Cousson <b-cousson@ti.com>:
>>>>>>
>>>>>> Hi Matthias,
>>>>>>
>>>>>> On 12/12/2012 04:33 PM, Matthias Brugger wrote:
>>>>>>>
>>>>>>> This patch is a follow-up patch for Javier Martinez effort adding
>>>>>>> initial
>>>>>>> device tree support to IGEP technology devices. [1]
>>>>>>>
>>>>>>> It adds uart1 and uart2 bindings to the generic dtsi for the IGEP
>>>>>>> boards.
>>>>>>>
>>>>>>> [1] http://www.spinics.net/lists/linux-omap/msg83409.html
>>>>>>>
>>>>>>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>>>>>>> ---
>>>>>>>   arch/arm/boot/dts/omap3-igep.dtsi |   24 ++++++++++++++++++++++++
>>>>>>>   1 file changed, 24 insertions(+)
>>>>>>>
>>>>>>> diff --git a/arch/arm/boot/dts/omap3-igep.dtsi
>>>>>>> b/arch/arm/boot/dts/omap3-igep.dtsi
>>>>>>> index 125fe00..c02e3c0 100644
>>>>>>> --- a/arch/arm/boot/dts/omap3-igep.dtsi
>>>>>>> +++ b/arch/arm/boot/dts/omap3-igep.dtsi
>>>>>>> @@ -27,6 +27,20 @@
>>>>>>>   };
>>>>>>>
>>>>>>>   &omap3_pmx_core {
>>>>>>> +     uart1_pins: pinmux_uart1_pins {
>>>>>>> +             pinctrl-single,pins = <
>>>>>>> +                     0x152 0x100     /* uart1_rx.uart1_rx INPUT |
>>>>>>> MODE0
>>>>>>> */
>>>>>>> +                     0x14c 0         /* uart1_tx.uart1_tx OUTPUT |
>>>>>>> MODE0 */
>>>>>>> +             >;
>>>>>>> +     };
>>>>>>> +
>>>>>>> +     uart2_pins: pinmux_uart2_pins {
>>>>>>> +             pinctrl-single,pins = <
>>>>>>> +                     0x14a 0x100     /* uart2_rx.uart2_rx INPUT |
>>>>>>> MODE0
>>>>>>> */
>>>>>>> +                     0x148 0         /* uart2_tx.uart2_tx OUTPUT |
>>>>>>> MODE0 */
>>>>>>> +             >;
>>>>>>> +     };
>>>>>>> +
>>>>>>>        uart3_pins: pinmux_uart3_pins {
>>>>>>>                pinctrl-single,pins = <
>>>>>>>                        0x16e 0x100     /* uart3_rx.uart3_rx INPUT |
>>>>>>> MODE0
>>>>>>> */
>>>>>>> @@ -77,6 +91,16 @@
>>>>>>>        status = "disabled";
>>>>>>>   };
>>>>>>>
>>>>>>> +&uart1 {
>>>>>>> +       pinctrl-names = "default";
>>>>>>> +       pinctrl-0 = <&uart1_pins>;
>>>>>>> +};
>>>>>>> +
>>>>>>> +&uart2 {
>>>>>>> +       pinctrl-names = "default";
>>>>>>> +       pinctrl-0 = <&uart2_pins>;
>>>>>>> +};
>>>>>>> +
>>>>>>>   &uart3 {
>>>>>>>          pinctrl-names = "default";
>>>>>>>          pinctrl-0 = <&uart3_pins>;
>>>>>>>
>>>>>>
>>>>>> That looks good to me. I'll apply it on top of javier's series for 3.9.
>>>>>
>>>>>
>>>>> Can you pin-point me to the repository where this patches are in right
>>>>> now? I tried to figure it out these days, but didn't found where to
>>>>> clone the repository from.
>>>>>
>>>>> Thanks,
>>>>> Matthias
>>>>>
>>>>
>>>> Hi Matthias,
>>>>
>>>> OMAP DT tree is:
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
>>>
>>>
>>> Hi all,
>>>
>>> unfortunately I can't find the patch in this tree.
>>
>>
>> Sorry about that. I've never pushed the latest branch, and was busy the past
>> month. I'll refresh the branch with all the pending patches.
>>
>> Regards,
>> Benoit
>>
> 
> Hi Benoit,
> 
> I realized that your for_3.9/dts branch has not landed in mainline yet
> and we are near to the end of the merge window.
> 
> Are you still planing to include those changes for 3.9 or are you
> going to wait until the next release?

I'm really sorry about that. I was not available to push it at the proper time.

I've just rebased it on 3.9-rc2 and pushed it to a new branch.
git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.10/dts

It includes the one from Matthias and yours as well. I'm still checking my inbox to catch up on the new ones I missed.

I'm planning to push this ASAP to avoid missing the deadline again.


Regards,
Benoit
