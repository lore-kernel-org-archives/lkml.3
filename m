Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab3KRI6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:58:24 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50151 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3KRI6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:58:15 -0500
MIME-Version: 1.0
In-Reply-To: <20131115153015.GD24831@e106331-lin.cambridge.arm.com>
References: <1384465609-26485-1-git-send-email-marek@goldelico.com>
	<1384465609-26485-3-git-send-email-marek@goldelico.com>
	<20131115153015.GD24831@e106331-lin.cambridge.arm.com>
Date: Mon, 18 Nov 2013 09:58:14 +0100
Message-ID: <CAAfyv346pUa9k3+9jdBX+EK8cV9GenaBxrAnVnKsbUPBoNBqrQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] misc: bmp085: Add DT bindings for EOC gpio line and
 direct irq.
From: Belisko Marek <marek.belisko@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "neilb@suse.de" <neilb@suse.de>,
        "hns@goldelico.com" <hns@goldelico.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Nov 15, 2013 at 4:30 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Nov 14, 2013 at 09:46:48PM +0000, Marek Belisko wrote:
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  Documentation/devicetree/bindings/misc/bmp085.txt |  8 ++++
>>  drivers/misc/bmp085.c                             | 53 ++++++++++++++++++++---
>>  2 files changed, 55 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/misc/bmp085.txt b/Documentation/devicetree/bindings/misc/bmp085.txt
>> index 91dfda2..c6033d5 100644
>> --- a/Documentation/devicetree/bindings/misc/bmp085.txt
>> +++ b/Documentation/devicetree/bindings/misc/bmp085.txt
>> @@ -8,6 +8,9 @@ Optional properties:
>>  - temp-measurement-period: temperature measurement period (milliseconds)
>>  - default-oversampling: default oversampling value to be used at startup,
>>    value range is 0-3 with rising sensitivity.
>> +- gpio: if device is using EOC irq line gpio can be specified to setup interrupt
>> +  handling
>> +- irq: interrupt with no gpio
>>
>>  Example:
>>
>> @@ -17,4 +20,9 @@ pressure@77 {
>>       chip-id = <10>;
>>       temp-measurement-period = <100>;
>>       default-oversampling = <2>;
>> +     gpio = <&gpio0 17 0>;
>> +
>> +     OR
>> +
>> +     irq = <75>;
>
> There's some contention over the description of gpio-based IRQs in DT.
> From the point of view of the device there is a logical IRQ output; the
> fact that this happens to be wired up to a GPIO pin that can happen to
> generate interrupts isn't anything to do with the device itself. There
> are plenty of device we have now whose interrupt lines could be wired to
> GPIOs. I see no reason to extend their bindings to support explicit
> GPIOs for IRQs, and I see no reason the driver should have to handle
> this.
>
> It would be far nicer for the device binding to just have the interrupts
> property, and for the gpio controller to act as an interrupt-controller,
> with the appropriate pin management.
OK. Can you please give me some example in current bindings tree?
Something like in:
Documentation/devicetree/bindings/fb/mxsfb.txt ? So if I understand
correctly we define only property
interrupts = <xxx> which will be exact interrupt number for cpu gpio
connected to bmp085 irq line.
>
> Thanks,
> Mark.

Thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
