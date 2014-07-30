Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaG3PNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:13:55 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38189 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaG3PNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <1836225.xQCoI7eRWl@diego>
References: <1406676273-20701-1-git-send-email-dianders@chromium.org>
	<1406676273-20701-2-git-send-email-dianders@chromium.org>
	<1836225.xQCoI7eRWl@diego>
Date: Wed, 30 Jul 2014 08:13:52 -0700
X-Google-Sender-Auth: _7d00vnV5cWQSJZ1EG0-txGKmPo
Message-ID: <CAD=FV=Wm-cB3-xHQdOUAXyX2xeYrXxPN6wYZrAoC6WAQ9sQ_Bg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: dts: Turn on USB host vbus on rk3288-evb
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Kever Yang <kever.yang@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Wed, Jul 30, 2014 at 4:24 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 29. Juli 2014, 16:24:31 schrieb Doug Anderson:
>> There is no phy driver that works on the Rockchip board for either USB
>> host port yet.  For now just hardcode the vbus signal to be on all the
>> time which makes both the dwc2 host and the EHCI port work.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  arch/arm/boot/dts/rk3288-evb.dtsi | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi
>> b/arch/arm/boot/dts/rk3288-evb.dtsi index 749e20d..efd625e 100644
>> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
>> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
>> @@ -35,6 +35,18 @@
>>                       debounce-interval = <100>;
>>               };
>>       };
>> +
>> +     /* This turns on vbus for both host0 (ehci) and host1 (dwc2) */
>> +     usb_host_vbus_regulator: usb-host-vbus-regulator {
>> +             compatible = "regulator-fixed";
>> +             enable-active-high;
>> +             gpio = <&gpio0 14 GPIO_ACTIVE_HIGH>;
>> +             pinctrl-names = "default";
>> +             pinctrl-0 = <&usb_host_vbus>;
>> +             regulator-name = "usb-host-vbus";
>> +             regulator-always-on;
>> +             regulator-boot-on;
>> +     };
>>  };
>
> It seems I have a slightly outdated schematics pdf for the evb ... and only
> see the OTG vbus pin, on <&gpio0 12>, but am missing the whole host vbus.

I have schematics that claim to be from January 25, 2014 and claim to
be rev 1.0.  On my schematics:

* GPIO0_B4 (12) = OTG_VBUS_DRV = pin 233 of the mainboard connector
* GPIO0_B6 (14) = HOST_VBUS_DRV = pin 239 of the mainboard connector

On the mainboard schematics I have the OTG signal (233) doesn't
actually go to the OTG port.  It goes to a debug header and nowhere
else.  The HOST VBUS controls VBUS on both of the two "host" ports.


> Could you think about finding another name for the handle? For example, in my
> incomplete evb-schematics the supply coming from the otg regulator is called
> vcc50_usb and there should be something similar for the host supply, so I'd
> like something like
>
>         vcc50_usbhost: usb-host-vbus-regulator { /* or whatever it gets called */
>         ...
>         };
>
> simply to keep with the supply names defined in the schematics - makes reading
> easier.

I did!  ;)  ...but I matched my schematics, not yours.  Can you
provide the date / version number from your schematics and we can see
which is newer?  Just for reference I was emailed schematics last week
but that doesn't necessarily guarantee that they're the newest ones.


Given the above, I'm not planning to spin this patch unless you
confirm you want me to.  Thanks!  :)

-Doug
