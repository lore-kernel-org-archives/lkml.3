Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaLHMmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:42:38 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:56462 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaLHMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:42:36 -0500
MIME-Version: 1.0
In-Reply-To: <1503477.DVdkExccIe@wuerfel>
References: <1416220572-13381-1-git-send-email-ankit.jindal@linaro.org>
 <2279061.naADrHDgyn@wuerfel> <CAPTm99WYNyxtY-NCVN8pB0HwNPn+EFx-7w7yEevaEK1z7-Zqxg@mail.gmail.com>
 <1503477.DVdkExccIe@wuerfel>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Mon, 8 Dec 2014 18:12:15 +0530
Message-ID: <CAPTm99V1qP5dAgDV04i3m_yR1ri9h=b8fDXBDxmPfpZG_P268g@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] Documentation: dt-bindings: Add binding info for
 X-Gene QMTM UIO driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anup Patel <anup@brainfault.org>, Guenter Roeck <linux@roeck-us.net>,
        "patches@apm.com" <patches@apm.com>, Rob Herring <robh+dt@kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 at 18:40, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 18 November 2014 14:59:54 Ankit Jindal wrote:
>> On 17 November 2014 16:47, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Monday 17 November 2014 16:06:11 Ankit Jindal wrote:
>> >> +
>> >> +       qmtm1_uio: qmtm_uio@1f200000 {
>> >> +               compatible = "apm,xgene-qmtm";
>> >> +               status = "disabled";
>> >> +               reg = <0x0 0x1f200000 0x0 0x10000>,
>> >> +                     <0x0 0x1b000000 0x0 0x400000>;
>> >> +               reg-names = "csr", "fabric";
>> >> +               qpool-memory = <&qmtm1_uio_qpool>;
>> >> +               clocks = <&qmtm1clk 0>;
>> >> +               num-queues = <0x400>;
>> >> +               devid = <1>;
>> >> +       };
>> >> +
>> >
>> > To make my previous review comments clearer:
>> >
>> > NAK
>> >
>> > Do not create device nodes that are meant for a specific use case in
>> > software and that are not usable for the common case. I don't think
>> > it makes any sense to keep on submitting a UIO driver for this until
>> > we have a proper network driver that uses this so we can make sure we
>> > have a working binding.
>>
>> The dataplane frameworks like OpenDataPlane etc, need to have access
>> to complete subsystem from the user space. Hence, we would like to
>> have this driver and some other UIO drivers to be the part of kernel
>> to have data plane frameworks working on our platform.
>
> Please work with the people that do the in-kernel QMTM driver to come
> up with a common binding then.
Thanks Arnd, I have synced with them, and in future our dt bindings
for this device is going to be inline with the one mentioned in the
patchset.
>
>         Arnd
Thanks,
Ankit
