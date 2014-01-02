Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaABXOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:14:54 -0500
Received: from 12.mo3.mail-out.ovh.net ([188.165.41.191]:52318 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814AbaABXOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:14:53 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jan 2014 18:14:52 EST
MIME-Version: 1.0
In-Reply-To: <4526077.qASk8HSHKP@wuerfel>
References: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
	<1388507534-10570-7-git-send-email-jjhiblot@traphandler.com>
	<4526077.qASk8HSHKP@wuerfel>
Date: Thu, 2 Jan 2014 20:31:00 +0100
Message-ID: <CACh+v5PptkrXERAqBUOv-DSaRDQ5NzJAc919Ne3iN9iVszRP+A@mail.gmail.com>
Subject: Re: [PATCH 6/6] at91: dt: sam9261: Added DM9000 in the device tree
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 13723875441099954200
X-Ovh-Remote: 209.85.192.171 (mail-pd0-f171.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/31 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 31 December 2013 17:32:14 jjhiblot@traphandler.com wrote:
>>
>> +                       ethernet@30000000 {
>> +                               compatible = "davicom,dm9000";
>> +                               reg = <0x30000000 0x2 0x30000004 0x2>;
>> +                               interrupt-parent = <&pioC>;
>> +                               interrupts = <11 IRQ_TYPE_EDGE_BOTH>;
>> +                               local-mac-address = [00 00 de ad be ef];
>> +                               davicom,no-eeprom;
>> +
>> +                               smc,cs = <2>;
>> +                               smc,ncs_read_setup = <0>;
>> +                               smc,nrd_setup = <2>;
>> +                               smc,ncs_write_setup = <0>;
>> +                               smc,nwe_setup = <2>;
>> +                               smc,ncs_read_pulse = <8>;
>> +                               smc,nrd_pulse = <4>;
>> +                               smc,ncs_write_pulse = <8>;
>> +                               smc,nwe_pulse = <4>;
>> +                               smc,read_cycle = <16>;
>> +                               smc,write_cycle = <16>;
>> +                               smc,tdf_cycles = <1>;
>> +                               smc,tdf_optimized = <0>;
>> +                               smc,page_size = <0>;
>> +                               smc,byte_access_type = <1>;
>> +                               smc,bus_width = <1>;
>> +                               smc,nwait_mode = <0>;
>> +                               smc,read_mode = <1>;
>> +                               smc,write_mode = <1>;
>> +                       };
>
> I don't like how this forces you to mix the properties
> of the ethernet device with the properties of the smc
> port. I would also like to see the address translation
> reflected in the DT nodes. This should probably just work
> out if you restructure the DT representation, and won't need
> changes in the driver.
>
> How about this:
>
>         smc: smc@ffffec00 {
>                 #address-cells = <2>; /* cs, address */
>                 #size-cells = <1>;
>                 ranges = <2 0 0x30000000 0x10000000>
>                          <3 0 0x40000000 0x10000000>;
>
>                 extbus@2.0 {
>                         compatible = "simple-bus";
>                         #address-cells = <1>;
>                         #size-cells = <1>;
>                         ranges = <0 2 0 0x10000000>;
>                         smc,ncs_read_setup = <0>;
>                         smc,nrd_setup = <2>;
>                         smc,...
>
>                         ethernet@0 {
>                                 compatible = "davicom,dm9000";
>                                 reg = <0x0 0x2> <0x4 0x2>;
>                         };
>                 };
>         };
I'm okay with this. I'll do something along those lines in the next
round of the patch set.
>
> If each bus interface has a fixed range of registers, you can actually
> collapse the upper two nodes again and just have one device per
> chipselect.
This is indeed the case, but I'd rather keep the top node to highlight
the fact that all the devices are physically tied to the same bus.

Jean-Jacques

>
>         Arnd
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
