Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaLINMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:12:22 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:40232 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbaLINMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:12:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141208225519.64501d2d@lxorguk.ukuu.org.uk>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
 <1414007405-32186-3-git-send-email-atull@opensource.altera.com>
 <20141024105200.GA20775@amd> <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
 <20141208225519.64501d2d@lxorguk.ukuu.org.uk>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 9 Dec 2014 13:11:59 +0000
X-Google-Sender-Auth: a31sx4HER9Ci3Dnj8rPqvpg0PgM
Message-ID: <CACxGe6tM1UXMCO=eVDad7rj2gxN-nbvyApti5kV5ScxQ+r2Kzg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@denx.de>, atull <atull@opensource.altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>, Ira Snyder <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Philip Balister <philip@balister.org>,
        rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason <jason@lakedaemon.net>, kyle.teske@ni.com,
        Nicolas Pitre <nico@linaro.org>, "Balbi, Felipe" <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>, cesarb@cesarb.net,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        Yves Vandervennet <yvanderv@opensource.altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 10:55 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Sat, 6 Dec 2014 13:00:17 +0000
> Grant Likely <grant.likely@linaro.org> wrote:
>
>> On Fri, Oct 24, 2014 at 11:52 AM, Pavel Machek <pavel@denx.de> wrote:
>> > Hi!
>> >
>> >> * /sys/class/fpga_manager/<fpga>/firmware
>> >>   Name of FPGA image file to load using firmware class.
>> >>   $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware
>> >
>> > I .. still don't think this is good idea. What about namespaces?
>> > The path corresponds to path in which namespace?
>>
>> I don't understand your concern here. This allows userspace to name
>> the FPGA bitstream that the kernel will use during request_firmware(),
>> and it will show up as the $FIRMWARE value in the uevent file, but it
>> is still the responsibility of userspace to choose what to load, and
>> it can freely ignore the setting of $FIRMWARE if it needs to.
>
> I think the entire model here is basically pedicated on a bogus
> assumption that an FPGA is a one shot device. It's not. It's a fast
> reloadable reusable device. A lot of work being done with FPGAs in
> operating systems already involves basically task switching and
> scheduling FPGAs as a shared resource pool. Trying to nail something
> together with request_firmware is several years behind the curve.
>
> From userspace it needs to be a open, load, use, close type model, not a
> static or semi-static pile of mappings.

If FPGA is a general purpose resource hanging off the side that
applications can use, then sure, but the majority of FPGA usage does
not fall into that scenario*. The majority of FPGA usage that I've
seen has core parts of the system implemented in the FPGA fabric.
Video pipelines, network switching, dma to/from main memory, control
of dedicated hardware. It's more than merely an application being able
to use the FPGA as an accelerator.

I'm certainly not dismissing the concept of FPGA scheduling and being
able to 'task switch' between bitstreams. Yes that is important, but
for most users it really does look like, as you say, "a static or
semi-static pile of mappings".

* Altera and Xilinx people - correct me if you disagree.
