Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3G2OX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:23:27 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:32890 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab3G2OX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:23:26 -0400
Message-ID: <51F67AD8.1070904@gmail.com>
Date: Mon, 29 Jul 2013 16:23:20 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ARM: dove: add MBus DT node
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375101114-28858-4-git-send-email-sebastian.hesselbarth@gmail.com> <51F661DE.1070106@gmail.com> <20130729135227.GA2417@localhost>
In-Reply-To: <20130729135227.GA2417@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 03:52 PM, Ezequiel Garcia wrote:
> Hi Sebastian,
>
> (Ccing devicetree ML)
>
> On Mon, Jul 29, 2013 at 02:36:46PM +0200, Sebastian Hesselbarth wrote:
>> On 07/29/2013 02:31 PM, Sebastian Hesselbarth wrote:
>>> This adds a MBus node including ranges and pcie apertures required later.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> ---
>>>    arch/arm/boot/dts/dove.dtsi |   19 +++++++++++++++++++
>>>    1 file changed, 19 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
>>> index 397674c..bdda016 100644
>>> --- a/arch/arm/boot/dts/dove.dtsi
>>> +++ b/arch/arm/boot/dts/dove.dtsi
>>> @@ -29,6 +29,20 @@
>>>    		marvell,tauros2-cache-features = <0>;
>>>    	};
>>>
>>> +	mbus {
>>> +		compatible = "marvell,dove-mbus", "marvell,mbus", "simple-bus";
>>> +		#address-cells = <2>;
>>> +		#size-cells = <1>;
>>> +		pcie-mem-aperture = <0xe0000000 0x10000000>; /* 256M MEM space */
>>> +		pcie-io-aperture  = <0xf2000000 0x00200000>; /*   2M I/O space */
>>
>> Actually, current v9 of the mbus patch set still requires "controller"
>> property to match the corresponding controller node. I had a short
>> discussion with Ezequiel to possibly just use of_find_compatible_node
>> and blindly assumed post-v8 will already use it.
>
> Ah, regarding this: despite your good arguin against the 'controller' property approach,
> I still feel a bit inclined for it, as I like the way it tightly-binds the two nodes.

I understand that the phandle property *shows* you that both are
related. But with DT you should always ask for every property, if
(a) it is really required to do the job and (b) does it really
describe the HW or just your SW needs/wishes.

So for the phandle property, I'd prefer to not put it into DT but
let the driver handle it.

Sebastian

