Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaCSEGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 00:06:43 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:63994 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaCSEGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 00:06:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140317140625.GJ8070@e106331-lin.cambridge.arm.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
	<1395057839-23871-3-git-send-email-ks.giri@samsung.com>
	<20140317140625.GJ8070@e106331-lin.cambridge.arm.com>
Date: Wed, 19 Mar 2014 09:36:40 +0530
Message-ID: <CAKrE-KeJPqFC__mNhFV6qexL0+E_B6Fm+u8S4iKnCR8vibCseA@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: exynos: added mailbox node
From: Girish KS <girishks2000@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Girish K S <ks.giri@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jassisinghbrar@gmail.com" <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>,
        "s-anna@ti.com" <s-anna@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 7:36 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Mar 17, 2014 at 12:03:59PM +0000, Girish K S wrote:
>> This patch adds the dt node for the mailbox IP
>>
>> Signed-off-by: Girish K S <ks.giri@samsung.com>
>>
>> Change-Id: I35e45e9a62592887a84a909aee54f259a2f731fa
>> ---
>>  .../bindings/mailbox/samsung-mailbox.txt           |   24 +++++++
>>  arch/arm64/boot/dts/samsung-gh7.dtsi               |   66 ++++++++++++++++++++
>>  arch/arm64/boot/dts/samsung-ssdk-gh7.dts           |    3 +
>>  3 files changed, 93 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
>> new file mode 100644
>> index 0000000..1908d71
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
>> @@ -0,0 +1,24 @@
>> +
>> +Samsung Mailbox Driver
>> +
>> +Required properties:
>> +- compatible:                Should be one of the following,
>> +                         "samsung,gh7-mailbox" for
>> +                             Samsung GH7 SoC series
>> +                         "samsung,exynos-mailbox" for
>> +                             exynosx SoC series
>> +- reg:                       Contains the mailbox register address range (base address
>> +                     and length)
>> +- interrupts:                Contains the interrupt information for the mailbox
>> +                     device.
>
> How many interrupts?
just one receive interrupt
I will update this detail in binding doc
>
> What are they for?
It is only for receive from remote processor
>
>> +- samsung,mbox-names:        Array of the names of the mailboxes
>
> Juding by the code there is one name per reg entry, but the description
> above implies a single entry (as all the dt fragments have).
>
> What values are expected? What is the consumer of these values? What are
> they used for?
These names are used to mention the links in the platform. tx and rx
link via mailbox.
i can mention of 2 consumers now. the ipmi driver and the cpu freq
driver. They are used
to exchange information with the remote processor
>
>> +
>> +Example:
>> +
>> +/* Samsung GH7 SoC */
>> +mailbox@100a0000 {
>> +     compatible = "samsung,gh7-mailbox";
>> +     reg = <0x0 0x100a0000 0x0 0x1000>;
>> +     interrupts = <0 310 0>;
>> +     samsung,mbox-names = "a7q-scp";
>> +};
>> diff --git a/arch/arm64/boot/dts/samsung-gh7.dtsi b/arch/arm64/boot/dts/samsung-gh7.dtsi
>> index c3610bd..be4cce9 100644
>> --- a/arch/arm64/boot/dts/samsung-gh7.dtsi
>> +++ b/arch/arm64/boot/dts/samsung-gh7.dtsi
>> @@ -107,5 +107,71 @@
>>                       interrupts = <0 420 0>;
>>                       arm,primecell-periphid = <0x341011>; /* HACK */
>
> This looks odd.
>
> What tree is this against?

Sorry this was based on a internal tree. Will base it on Kukjin's gh7 base patch

>
> Cheers,
> Mark.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
