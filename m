Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaG2PME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:12:04 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:48632 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaG2PMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <53D79771.1020406@suse.de>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-4-git-send-email-afaerber@suse.de>
	<CAD=FV=VK0KJknJ2099S7fEDzBnpPCrpSZ36WPkJB156GpcyEfg@mail.gmail.com>
	<53D79771.1020406@suse.de>
Date: Tue, 29 Jul 2014 08:11:59 -0700
X-Google-Sender-Auth: 7k3fpjWOapJkyCcAAxG87Fzca8A
Message-ID: <CAD=FV=UR5NWXCpK3zB-NSnkMUgKaYAHV1YLdPAvP83JMqekk0Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos5250: Fold common ChromeOS parts
 into Snow
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Tue, Jul 29, 2014 at 5:45 AM, Andreas Färber <afaerber@suse.de> wrote:
> Doug,
>
> Am 25.07.2014 18:02, schrieb Doug Anderson:
>> On Fri, Jul 18, 2014 at 10:20 AM, Andreas Färber <afaerber@suse.de> wrote:
>>> +/*
>>> + * On Snow we've got SIP WiFi and so can keep drive strengths low to
>>> + * reduce EMI.
>>> + */
>>> +&mmc_3 {
>>> +       status = "okay";
>>> +       num-slots = <1>;
>>> +       supports-highspeed;
>>> +       broken-cd;
>>> +       card-detect-delay = <200>;
>>> +       samsung,dw-mshc-ciu-div = <3>;
>>> +       samsung,dw-mshc-sdr-timing = <2 3>;
>>> +       samsung,dw-mshc-ddr-timing = <1 2>;
>>> +
>>> +       slot@0 {
>>> +               reg = <0>;
>>> +               bus-width = <4>;
>>> +               pinctrl-names = "default";
>>> +               pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_bus4>;
>>
>> This actually looks like a bug on snow.  I don't think these pinctrl
>> statements are taking effect and I think they belong at the mmc level,
>> not the slot level.  That's not a new bug introduced by you, though.
>> Mind fixing it?  You've already got it right for Spring mmc_1.
>
> I was taught never to mix code movements with functional changes, as it
> hides them even if mentioned in the commit message. Would you like me to
> fix it pre- or post-move? Post-move would be easiest for me. ;)

Agreed.  Sorry for implying that it belonged as part of this patch.
I'd be happy if it was somewhere in the series, ideally before you
introduce the Spring device tree so diffs are cleaner for it.  I don't
care if it's pre-move or post-move.

-Doug
