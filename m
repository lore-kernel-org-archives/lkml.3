Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaHVUrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:47:52 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:32905 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaHVUru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:47:50 -0400
MIME-Version: 1.0
In-Reply-To: <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de> <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 22 Aug 2014 13:47:09 -0700
Message-ID: <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 8:49 GMT-07:00 Sören Brinkmann <soren.brinkmann@xilinx.com>:
> On Thu, 2014-08-21 at 01:32PM +0200, Andreas Färber wrote:
>> Am 21.08.2014 10:41, schrieb Michal Simek:
>> > On 08/20/2014 05:56 PM, Soren Brinkmann wrote:
>> >> Add missing Ethernet phys to Zynq DTs.
>> >>
>> >> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> >> ---
>> >>  arch/arm/boot/dts/zynq-zc702.dts | 6 ++++++
>> >>  arch/arm/boot/dts/zynq-zc706.dts | 6 ++++++
>> >>  arch/arm/boot/dts/zynq-zed.dts   | 6 ++++++
>> >>  3 files changed, 18 insertions(+)
>> >>
>> >> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
>> >> index 30bcfe20f0bc..fa810505ab8f 100644
>> >> --- a/arch/arm/boot/dts/zynq-zc702.dts
>> >> +++ b/arch/arm/boot/dts/zynq-zc702.dts
>> >> @@ -36,6 +36,12 @@
>> >>  &gem0 {
>> >>    status = "okay";
>> >>    phy-mode = "rgmii-id";
>> >> +  phy-handle = <&ethernet_phy>;
>> >> +
>> >> +  ethernet_phy: ethernet-phy@7 {
>> >> +          compatible = "marvell,88e1116r", "ethernet-phy-ieee802.3-c22";
>> >
>> > c22 is completely unused by the kernel and also c22 is default option anyway.
>> > Any advantage to have c22 specified here?
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/phy.txt
>>
>> Sören's marvell,* entries do not seem documented, therefore I used the
>> documented "ethernet-phy-idAAAA.BBBB" based syntax. The documented
>> example specifically uses -c22, too.
>>
>> Either it's okay to prepend unrecognized model strings, then you should
>> update zynq-parallella.dts as well (I put the model in a comment there)
>> or use the official strings like I used and keep the readable models as
>> comments. Documenting all those "marvell,88e1116r", "marvell,88e1518",
>> "marvell,88e1318" PHY bindings and possibly prepending them to the ID
>> based strings would be another option, of course.
>
> These phy-bindings are everything than obvious to me. It seems the docs
> are spread across a couple of different files and not fully up to date
> either. I basically tried to get something working out of the docs, the
> parallela and our vendor DT files.

There is one file that describes everything that is needed in
Documentation/devicetree/bindings/net/phy.txt, if it is not clear,
patches are welcome.

>
> So my thinkings:
>  - the compatible string with the -c22 is used and documented in the phy
>    bindings, it should be there.

The clause 22 compatible string is not used, but we do need it to know
it is not a clause 45 PHY, which implicitly makes the clause 22
compatible string used.

>  - the ID based strings seem to be not needed since, IIUC, the core
>    reads the ID from the PHY and uses it, so I just left it out not
>    trying to figure out how to obtain the correct ID

It is not needed, but it is one way to specify a PHY device if you do
not know what compatible string to use instead.

>  - the marvell compatible strings are used in our vendor tree. They
>    aren't used anywhere but in our vendor tree. I though keeping them is
>    nice since it identifies the PHY fully. And in case that level of
>    detail is needed at some point it is already there.

And this is the recommended way to do it in case we ever need to key a
software decision based on the hardware.

>
> Assuming that we wanna keep things this way, I'm happy to re-spin this
> patch and also add a similar compatible string to the parallela DT.

Your initial patchset is correct with repesct to how the Device Tree
binding for Ethernet PHY nodes is defined.

>
>         Thanks,
>         Sören
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Florian
