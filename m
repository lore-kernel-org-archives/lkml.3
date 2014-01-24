Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaAXSok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:44:40 -0500
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:59859 "HELO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752167AbaAXSoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:44:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140124182355.GF4758@e106331-lin.cambridge.arm.com>
References: <1390504801-24483-1-git-send-email-fkan@apm.com>
	<1390504801-24483-6-git-send-email-fkan@apm.com>
	<20140124113920.GF814@e106331-lin.cambridge.arm.com>
	<CAL85gmDJeUY0zUjkmpMo7g_hLj34RsgU1VEF80wouLzOFGAdqQ@mail.gmail.com>
	<20140124182355.GF4758@e106331-lin.cambridge.arm.com>
Date: Fri, 24 Jan 2014 10:44:37 -0800
Message-ID: <CAL85gmAy+gt-Utj40eDhgpRKcW7L1DhNfdqrHA3LRSLT91VQzw@mail.gmail.com>
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

On Fri, Jan 24, 2014 at 10:23 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jan 24, 2014 at 06:03:10PM +0000, Feng Kan wrote:
>> On Fri, Jan 24, 2014 at 3:39 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > On Thu, Jan 23, 2014 at 07:20:01PM +0000, Feng Kan wrote:
>> >> Add documentation for generic SYSCON reboot driver.
>> >>
>> >> Signed-off-by: Feng Kan <fkan@apm.com>
>> >> ---
>> >>  .../bindings/power/reset/syscon-reboot.txt         |   16 ++++++++++++++++
>> >>  1 files changed, 16 insertions(+), 0 deletions(-)
>> >>  create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> >> new file mode 100644
>> >> index 0000000..e9eb1fe
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> >> @@ -0,0 +1,16 @@
>> >> +Generic SYSCON mapped register reset driver
>> >
>> > Bindings should describe hardware, not drivers.
>> >
>> > What precisely does this binding describe?
>> >
>> >> +
>> >> +Required properties:
>> >> +- compatible: should contain "syscon-reboot"
>> >> +- regmap: this is phandle to the register map node
>> >> +- offset: offset in the register map for the reboot register
>> >> +- mask: the reset value written to the reboot register
>> >> +
>> >> +Examples:
>> >> +
>> >> +reboot {
>> >> +   compatible = "syscon-reboot";
>> >> +   regmap = <&regmapnode>;
>> >> +   offset = <0x0>;
>> >> +   mask = <0x1>;
>> >> +};
>> >
>> > Access size? Endianness?
>> FKAN: are you asking for documentation? I don't see alot of example of
>> support for these.
>
> If I used the enippet in the example, what endianness and access size
> should I expect an OS to perform? That should be documented.
>
> If this doesn't match the general case, we can add properties later to
> adjust the access size and/or endianness. We just need to document what
> the binding actually describes currently, or it's not possible to
> implement anything based off of the binding documentation.
>
> I should be able to read a binding document and write a dts. I shouldn't
> have to read the code to figure out what the binding describes.
>
>>
>> >
>> > Why can we not have a binding for the register bank this exists in, and
>> > have that pass on the appropriate details to a syscon-reboot driver?
>>
>> FKAN: Thats a good idea. But the hardware in this case (SCU) system
>> clock unit has a bunch of registers used for different functions. If syscon is
>> used alot in this case and we pile more attribute into it. It would get kinda
>> messy after a while.
>
> Huh?
>
> What's wrong with having a system clock unit binding, that the kernel
> can decompose as appropriate?
>
> I don't get your syscon argument.

FKAN: I do have a SCU binding, I thought you wanted to move the offset and
mask to the SCU binding. The only issue I see in that case is when we use
more such methods, the SCU binding would look rather crowded. If this is not
the case, I am a bit confused at what I should do next.

>
> Thanks,
> Mark.
