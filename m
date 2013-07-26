Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3GZQH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:07:26 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:63996 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320Ab3GZQHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:07:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130725200343.GV9858@sirena.org.uk>
References: <1374781320-10793-1-git-send-email-vpalatin@chromium.org> <20130725200343.GV9858@sirena.org.uk>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Fri, 26 Jul 2013 09:06:56 -0700
X-Google-Sender-Auth: WMey4qKcWHlx1BSzWvUHQuWR-ts
Message-ID: <CAP_ceTyH3Yfw5ruSWfaDz_e=vrgkS6FT8PV1XgcCAwxLroHm1g@mail.gmail.com>
Subject: Re: [PATCH] regulator: read low power states configuration from
 device tree
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 1:03 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jul 25, 2013 at 12:42:00PM -0700, Vincent Palatin wrote:
>
>> +- regulator-suspend-disk-microvolt: voltage applied when entering S2D
>> +- regulator-suspend-disk-disabled: turn off when entering S2D
>> +- regulator-suspend-mem-microvolt: voltage applied when entering S2M
>> +- regulator-suspend-mem-disabled: turn off when entering S2M
>> +- regulator-suspend-standby-microvolt: voltage applied when entering standby
>> +- regulator-suspend-standby-disabled: turn off when entering standby
>
> The reason this isn't in device tree at the minute is that suspend to
> disk and suspend to RAM are somewhat Linux specific concepts and the
> whole thing gets more and more dynamic as time moves forwards with the
> suspend state for practical systems depending on the instantaneous
> device state prior to entering suspend and the bits that are fixed often
> involving sequencing elements and so on which get fixed in hardware
> and/or bootloader.  Do you have practical systems where this is needed?

Yes, on a Chromebook machine, an internal USB device power rail is
connected to one of the FET of a TPS65090,
the device is leaking power in suspend-to-RAM, it would be nice to cut
the FET during suspend.

> It's also not clear to me hat the -disabled properties make sense; if we
> have properties for the state when enabled I'd expect them to allow
> things to be marked as enabled or disabled (with don't touch as the
> default).

you mean declaring an optional (string) property  such as :
 regulator-suspend-mem-state
 which can take the value "enabled" or "disabled"
e.g.
power-regulator {
     compatible = "ti,tps65090";
     reg = <0x48>;
     voltage-regulators {
          VFET4 {
                    regulator-name = "usb_leaker";
                    regulator-suspend-mem-state = "disabled";
          };
    };
};
