Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaKPXAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 18:00:07 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:61391 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaKPXAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 18:00:04 -0500
MIME-Version: 1.0
In-Reply-To: <c52187589f5c4cc6b908d899c2b9f7a6@BN1BFFO11FD036.protection.gbl>
References: <cover.1415962281.git.michal.simek@xilinx.com>
	<0a88d52b5e71fb220ca619180ec9ca746edad2b1.1415962281.git.michal.simek@xilinx.com>
	<546881CA.2020801@suse.de>
	<c52187589f5c4cc6b908d899c2b9f7a6@BN1BFFO11FD036.protection.gbl>
Date: Mon, 17 Nov 2014 09:00:02 +1000
X-Google-Sender-Auth: 65Js_K20mqqka_MmhZZFSzS4Ug8
Message-ID: <CAEgOgz7j3jFbf1HxtimzPDMQ3oRu8AAHhHAUtg1boYjOUV5ygA@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] ARM: zynq: DT: Add OCM controller node
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <monstr@monstr.eu>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 5:32 AM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Sun, 2014-11-16 at 11:51AM +0100, Andreas Färber wrote:
>> Hi Michal,
>>
>> Am 14.11.2014 um 11:52 schrieb Michal Simek:
>> > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
>> > index ce2ef5bec4f2..e217fb1c1169 100644
>> > --- a/arch/arm/boot/dts/zynq-7000.dtsi
>> > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>> > @@ -150,6 +150,13 @@
>> >                     reg = <0xf8006000 0x1000>;
>> >             };
>> >
>> > +           ocmc: memory-controller@f800c000 {
>> > +                   compatible = "xlnx,zynq-ocmc-1.0";
>> > +                   interrupt-parent = <&intc>;
>> > +                   interrupts = <0 3 4>;
>> > +                   reg = <0xf800c000 0x1000>;
>> > +           };
>> > +
>> >             uart0: serial@e0000000 {
>> >                     compatible = "xlnx,xuartps", "cdns,uart-r1p8";
>> >                     status = "disabled";
>>
>> Not directly related to this patch: As one can see here, the node order
>> is quite a mess... According to Olof, nodes should be ordered by unit
>> address, whereas here some but not all seem ordered by node name. Would
>> you welcome a cleanup patch, or can you fix that yourself?
>
> I wouldn't say it's a mess, just a different property to sort the nodes
> by. For humans reading the DT, searching for nodes, alphabetical order
> helps finding the right node, IMHO.

I do generally find myself asking "whats that thing at that address"
more than I find myself asking the "wheres that piece of hardware" so
Andreas' sorting scheme makes more sense to me. Vertically scanning a
DT to give yourself an overview of the system level address map is
good too. Wheras alphabetic sorting doesn't mean to much.

Regards,
Peter

What advantage would sorting by
> address have?
>
>         Thanks,
>         Sören
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
