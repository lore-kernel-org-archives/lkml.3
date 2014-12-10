Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaLJRmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:42:39 -0500
Received: from senator.holtmann.net ([87.106.208.187]:38955 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaLJRmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:42:38 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: BCM2048 bluetooth connected over OMAP serial
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAL_Jsq+dy+5Fsg_oasP_hN3RuL1Wk7fOcQjyp+UdaJZyGa=uEg@mail.gmail.com>
Date: Wed, 10 Dec 2014 18:42:33 +0100
Cc: Pavel Machek <pavel@ucw.cz>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5C56C73A-1D8E-4ACC-B1B7-3E8D49943A70@holtmann.org>
References: <20141210164333.GA3154@amd> <CAL_Jsq+dy+5Fsg_oasP_hN3RuL1Wk7fOcQjyp+UdaJZyGa=uEg@mail.gmail.com>
To: Rob Herring <robherring2@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

>> So, there's bluetooth chip that's connected to the SoC by UART and some
>> GPIOs. What would be right representation in the device tree?
>> Something like this?
>> 
>>        bluetooth {
>>                  compatible = "broadcom,bcm2048";
>>                  uart = <&uart2>;
>>                  reset-gpios = <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
>>                  host-wakeup-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */
>>                  bluetooth-wakeup-gpios = <&gpio2 5 GPIO_ACTIVE_HIGH>; /* want 37 */
>>                  chip-type = <3>;
>>                  bt-sysclk = <2>;
>>                  reset-gpio-shared = <0>;
>>        };
>> 
>> Is there some way to prevent OMAP tty driver from binding to the
>> device and exporting the device to userspace?
> 
> Isn't the normal way for BT to work is the uart is exposed to
> userspace and the BT stack is all in userspace? This is how other
> Broadcom BT/WiFi combo parts work.

not on Linux actually. The Bluetooth core layer (including the HCI transport) are all in kernel space.

However UART based Bluetooth chips are exposed as TTY and then the N_HCI line discipline is used to attach it to the kernel Bluetooth subsystem.

Regards

Marcel

