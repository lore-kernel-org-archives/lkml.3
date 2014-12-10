Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbaLJRgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:36:25 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55807 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620AbaLJRgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:36:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141210164333.GA3154@amd>
References: <20141210164333.GA3154@amd>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 10 Dec 2014 11:35:59 -0600
Message-ID: <CAL_Jsq+dy+5Fsg_oasP_hN3RuL1Wk7fOcQjyp+UdaJZyGa=uEg@mail.gmail.com>
Subject: Re: BCM2048 bluetooth connected over OMAP serial
To: Pavel Machek <pavel@ucw.cz>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:43 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> So, there's bluetooth chip that's connected to the SoC by UART and some
> GPIOs. What would be right representation in the device tree?
> Something like this?
>
>         bluetooth {
>                   compatible = "broadcom,bcm2048";
>                   uart = <&uart2>;
>                   reset-gpios = <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
>                   host-wakeup-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */
>                   bluetooth-wakeup-gpios = <&gpio2 5 GPIO_ACTIVE_HIGH>; /* want 37 */
>                   chip-type = <3>;
>                   bt-sysclk = <2>;
>                   reset-gpio-shared = <0>;
>         };
>
> Is there some way to prevent OMAP tty driver from binding to the
> device and exporting the device to userspace?

Isn't the normal way for BT to work is the uart is exposed to
userspace and the BT stack is all in userspace? This is how other
Broadcom BT/WiFi combo parts work.

Rob
