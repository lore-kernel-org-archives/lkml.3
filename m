Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaETHYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:24:34 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52956 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaETHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:24:32 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140520072048.GC20874@lee--X1>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
	<1394614210-15698-7-git-send-email-maxime.coquelin@st.com>
	<CAOesGMg5Jk_XB3zdfKz8VxRObYbFO8OMuRyo7Ba-kavANbci1w@mail.gmail.com>
	<20140520072048.GC20874@lee--X1>
Date: Tue, 20 May 2014 00:24:31 -0700
Message-ID: <CAOesGMioLwX3jgGEsR=rHV0u6yR54b4x8BfyZ91vjJnMapUHew@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] ARM: dts: STiH407: Add B2120 board support
From: Olof Johansson <olof@lixom.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: Maxime COQUELIN <maxime.coquelin@st.com>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:20 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > B2120 HDK is the reference board for STiH407 SoC.
>> > It has the following characteristics:
>> >  - 1GB DDR3
>> >  - 8GB eMMC / SD-Card slot
>> >  - 32MB NOR Flash
>> >  - 1 x Gbit Ethernet
>> >  - 1 x USB 3.0 port
>> >  - 1 x Mini-PCIe
>> >  - 1 x SATA
>> >  - 1 x HDMI output
>> >  - 1 x HDMI input
>> >  - 1 x SPDIF
>> >
>> > This patch only introduces basic functionnalities, such as I2C and UART.
>> >
>> > Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> > Acked-by: Lee Jones <lee.jones@linaro.org>
>> > Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> > Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> > ---
>> >  arch/arm/boot/dts/Makefile          |  3 +-
>> >  arch/arm/boot/dts/stih407-b2120.dts | 78 +++++++++++++++++++++++++++++++++++++
>> >  2 files changed, 80 insertions(+), 1 deletion(-)
>> >  create mode 100644 arch/arm/boot/dts/stih407-b2120.dts
>
> [...]
>
>> > +/ {
>> > +       model = "STiH407 B2120";
>> > +       compatible = "st,stih407", "st,stih407-b2120";
>>
>> This should go from specific to generic, so the order needs to be the other way.
>
> I did have a patch-set that changed all of these.  Wonder where that went!

Cool.

>
> [...]
>
>> > +       soc {
>> > +               sbc_serial0: serial@9530000 {
>> > +                       status = "okay";
>> > +               };
>>
>> You might want to consider reference-based syntax here instead, so you
>> don't have to mimic the hierarchy. That'd be (at the root level of the
>> file, below this secion:
>>
>> &sbc_serial0: {
>>         status = "okay";
>> };
>
> I'm personally not keen on this scheme.  It's sometimes helpful to know
> the hierarchy and I don't think it's a large overhead to format the
> subordinate DTS files in this way.
>
> Please consider not enforcing this.

Definitely not enforcing it, and I didn't use to like it either but it
has some real upsides.

In particular, it saves a lot of grief when you're changing something
like the unit-id of a node in .dtsi and forget to do the same update
in the dts.



-Olof
