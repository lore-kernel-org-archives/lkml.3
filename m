Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaAXSDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:03:13 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:58358 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751574AbaAXSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140124113920.GF814@e106331-lin.cambridge.arm.com>
References: <1390504801-24483-1-git-send-email-fkan@apm.com>
	<1390504801-24483-6-git-send-email-fkan@apm.com>
	<20140124113920.GF814@e106331-lin.cambridge.arm.com>
Date: Fri, 24 Jan 2014 10:03:10 -0800
Message-ID: <CAL85gmDJeUY0zUjkmpMo7g_hLj34RsgU1VEF80wouLzOFGAdqQ@mail.gmail.com>
Subject: Re: [PATCH V4 5/5] Documentation: power: reset: Add documentation for
 generic SYSCON reboot driver
From: Feng Kan <fkan@apm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 3:39 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Jan 23, 2014 at 07:20:01PM +0000, Feng Kan wrote:
>> Add documentation for generic SYSCON reboot driver.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>  .../bindings/power/reset/syscon-reboot.txt         |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>>
>> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> new file mode 100644
>> index 0000000..e9eb1fe
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> @@ -0,0 +1,16 @@
>> +Generic SYSCON mapped register reset driver
>
> Bindings should describe hardware, not drivers.
>
> What precisely does this binding describe?
>
>> +
>> +Required properties:
>> +- compatible: should contain "syscon-reboot"
>> +- regmap: this is phandle to the register map node
>> +- offset: offset in the register map for the reboot register
>> +- mask: the reset value written to the reboot register
>> +
>> +Examples:
>> +
>> +reboot {
>> +   compatible = "syscon-reboot";
>> +   regmap = <&regmapnode>;
>> +   offset = <0x0>;
>> +   mask = <0x1>;
>> +};
>
> Access size? Endianness?
FKAN: are you asking for documentation? I don't see alot of example of
support for these.

>
> Why can we not have a binding for the register bank this exists in, and
> have that pass on the appropriate details to a syscon-reboot driver?

FKAN: Thats a good idea. But the hardware in this case (SCU) system
clock unit has a bunch of registers used for different functions. If syscon is
used alot in this case and we pile more attribute into it. It would get kinda
messy after a while.

FKAN: I still haven't figured out how to generically tie to
the reset handler? Maybe the next person can use #define to bridge in the
reset handler they want to use.

>
> That way we can change the way we poke things without requiring changes
> to bindings or dts.
>
> Thanks,
> Mark.
