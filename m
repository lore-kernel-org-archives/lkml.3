Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483AbaLKWKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:10:23 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53448 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbaLKWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:10:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141210225036.GA5585@earth.universe>
References: <20141210164333.GA3154@amd>
	<11367725.nphhSzdtpK@wuerfel>
	<20141210184203.GA28150@leverpostej>
	<20141210205622.GA25286@amd>
	<20141210225036.GA5585@earth.universe>
Date: Thu, 11 Dec 2014 23:10:17 +0100
Message-ID: <CAAfyv35D1bn5uzWU298Wz6xRXb58-5i6Mgz6WogLh3_PK4p1pg@mail.gmail.com>
Subject: Re: BCM2048 bluetooth connected over OMAP serial
From: Belisko Marek <marek.belisko@gmail.com>
To: "sre@debian.org" <sre@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "ivo.g.dimitrov.75@gmail.com" <ivo.g.dimitrov.75@gmail.com>,
        Pawel Moll <Pawel.Moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "khilman@kernel.org" <khilman@kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        kernel list <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown send series which implement what was suggested in previous posts:
https://lkml.org/lkml/2014/12/11/454

On Wed, Dec 10, 2014 at 11:50 PM, sre@debian.org <sre@kernel.org> wrote:
> Hi,
>
> On Wed, Dec 10, 2014 at 09:56:22PM +0100, Pavel Machek wrote:
>> On Wed 2014-12-10 18:42:03, Mark Rutland wrote:
>> > On Wed, Dec 10, 2014 at 05:02:42PM +0000, Arnd Bergmann wrote:
>> > > On Wednesday 10 December 2014 17:43:33 Pavel Machek wrote:
>> > > >
>> > > > So, there's bluetooth chip that's connected to the SoC by UART and some
>> > > > GPIOs. What would be right representation in the device tree?
>> > > > Something like this?
>> > > >
>> > > >         bluetooth {
>> > > >                   compatible = "broadcom,bcm2048";
>> > > >                   uart = <&uart2>;
>> > > >                   reset-gpios = <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
>> > > >                   host-wakeup-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */
>> > > >                   bluetooth-wakeup-gpios = <&gpio2 5 GPIO_ACTIVE_HIGH>; /* want 37 */
>> > > >                   chip-type = >;
>> > > >                   bt-sysclk = <2>;
>> > > >                   reset-gpio-shared = <0>;
>> > > >         };
>> > > >
>> > > > Is there some way to prevent OMAP tty driver from binding to the
>> > > > device and exporting the device to userspace?
>> > >
>> > > I think from the driver perspective, you want this to be a tty line
>> > > discipline rather than a driver that attaches to the physical
>> > > uart.
>> > >
>> > > For the DT representation, I fear we haven't got a precedent. A uart
>> > > phandle sounds reasonable, but there might be other ways to do it
>> > > and we should consider if there are better alternatives. It could
>> > > possibly be a child node of the uart, but that would require other
>> > > infrastructure in the kernel because we don't currently create
>> > > devices for those.
>> >
>> > I think the child node is the way to go; that would match what we do for
>> > I2C and SPI. We might need new infrastructure, but I don't think we
>> > should treat this differently simlpy because we don't have that yet.
>>
>> Well, uart in this case looks more like a GPIO than an I2C (no
>> addressing, just few wires). And we do phandle for GPIOs.
>
> Right and the devices use I2C for full communication and GPIOs as
> helpers. I guess UART counts as full communication and not as helper.
>
> phandle vs child node is not a matter of adressing and btw where is
> the difference between "5th gpio on 1st gpio controller" and "5th
> address on 1st i2c controller"?
>
>> Actually, the chip also has PCM, analog audio, and "pc compatible?"
>> connections, plus some connection to WIFI. So we may need more
>> phandles there....
>
> This is much harder to solve. I think we don't have a DT binding for
> a device, which uses two communication interfaces as the bcm2048
> (uart & i2c). OTOH we may just add a slave device for the fm-radio
> part like this:
>
> uart {
>     bcm2048 {
>         stuff;
>     };
> };
>
> i2c {
>     bcm2048-radio {
>         master = <&bcm2048>;
>     };
> };
>
> -- Sebastian
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

BR,

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
