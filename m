Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbbAIQ34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:29:56 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42713 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbAIQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <54AFFFDC.7020307@free-electrons.com>
References: <1420799989-10645-1-git-send-email-gregory.clement@free-electrons.com>
 <1420799989-10645-3-git-send-email-gregory.clement@free-electrons.com>
 <54AFF7E3.4070506@redhat.com> <54AFFFDC.7020307@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 10 Jan 2015 00:29:32 +0800
X-Google-Sender-Auth: bdu0ce4OrEW1RR3yIHl5ecrMhRE
Message-ID: <CAGb2v674q4Cjp9qy9CbUXe2j5pT_ez98CKxXHC8u4Diap2TT1A@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] Documentation: bindings: Add the regulator
 property to the sub-nodes AHCI bindings
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        devicetree <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-ide@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
        Mark Brown <broonie@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 10, 2015 at 12:20 AM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:
> Hi Hans,
>
> On 09/01/2015 16:46, Hans de Goede wrote:
>> Hi,
>>
>> On 09-01-15 11:39, Gregory CLEMENT wrote:
>>> It is now possible to use a regulator property for each port of the
>>> AHCI controller.
>>>
>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>>> ---
>>>   Documentation/devicetree/bindings/ata/ahci-platform.txt | 9 ++++++---
>>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>>> index 4ab09f2202d4..87416d71c758 100644
>>> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
>>> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>>> @@ -37,9 +37,10 @@ Required properties when using sub-nodes:
>>>
>>>
>>>   Sub-nodes required properties:
>>> -- reg               : the port number
>>> -- phys              : reference to the SATA PHY node
>>> -
>>> +- reg                                       : the port number
>>> +And at least one of the following properties:
>>> +- phys                      : reference to the SATA PHY node
>>> +- target-port<n>-supply     : regulator for SATA target power for port <n>
>>>
>>>   Examples:
>>>           sata@ffe08000 {
>>> @@ -68,10 +69,12 @@ With sub-nodes:
>>>              sata0: sata-port@0 {
>>>                      reg = <0>;
>>>                      phys = <&sata_phy 0>;
>>> +                    target-port0-supply = <&reg_sata0>;
>>>              };
>>>
>>
>> I'm sorry, but I've to NAK this, I did not follow the regulator discussion.,
>> thinking that it was just about the use of some utility function vs diy or
>> some such, I had no idea this would impact the dt-binding.
>>
>> The -port%d- bit is completely unnecessary from a dt pov. Devicetree is
>> supposed to be OS agnostic, we cannot make the dt-binding ugly just because
>> the regulator subsys in Linux does not provide the necessary functionality.
>>
>> I'm afraid you will have to get back to the regulator subsys people and tell
>> them that we really need an of_regulator_get, so that we can tell the
>> regulator subsys we want a regulator from a specific of_node.
>
> I didn't cc you especially, but I cc the linux-ide mailing list. The
> email was "[PATCH 2/2] regulator: core: Add the device tree version to
> the regulator_get family" (see
> http://thread.gmane.org/gmane.linux.kernel/1856154).
>
> Mark Brown didn't want a firmware specific interface. The regulator
> framework allows associating only a regulator to a device and
> currently, at least from the point of view of the device tree, the
> port subnodes are not devices. He suggested making the child node
> device. However, when I had a look on it, it didn't seem an easy
> task. As you know better this code, what do you think of it?
>
> (I added Mark Bronw in CC of this email so he can add more explanation
> if needed)

Since the AHCI library code already supports the generic phy subsystem,
with one phy possible for each port node, you could possibly add a
generic phy that just takes a regulator, and hook it up that way.

I don't know if the extra layer of indirection is good or not.
Just offering an alternative.


Regards,
ChenYu

>>
>> Please CC me when you re-open the discussion with the regulator people.
>>
>> Regards,
>>
>> Hans
>>
>
>
> --
> Gregory Clement, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
