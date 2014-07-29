Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaG2Mpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:45:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaG2Mpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:45:41 -0400
Message-ID: <53D79771.1020406@suse.de>
Date: Tue, 29 Jul 2014 14:45:37 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
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
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos5250: Fold common ChromeOS parts
 into Snow
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>	<1405704009-8430-4-git-send-email-afaerber@suse.de> <CAD=FV=VK0KJknJ2099S7fEDzBnpPCrpSZ36WPkJB156GpcyEfg@mail.gmail.com>
In-Reply-To: <CAD=FV=VK0KJknJ2099S7fEDzBnpPCrpSZ36WPkJB156GpcyEfg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

Am 25.07.2014 18:02, schrieb Doug Anderson:
> On Fri, Jul 18, 2014 at 10:20 AM, Andreas Färber <afaerber@suse.de> wrote:
>> +/*
>> + * On Snow we've got SIP WiFi and so can keep drive strengths low to
>> + * reduce EMI.
>> + */
>> +&mmc_3 {
>> +       status = "okay";
>> +       num-slots = <1>;
>> +       supports-highspeed;
>> +       broken-cd;
>> +       card-detect-delay = <200>;
>> +       samsung,dw-mshc-ciu-div = <3>;
>> +       samsung,dw-mshc-sdr-timing = <2 3>;
>> +       samsung,dw-mshc-ddr-timing = <1 2>;
>> +
>> +       slot@0 {
>> +               reg = <0>;
>> +               bus-width = <4>;
>> +               pinctrl-names = "default";
>> +               pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_bus4>;
> 
> This actually looks like a bug on snow.  I don't think these pinctrl
> statements are taking effect and I think they belong at the mmc level,
> not the slot level.  That's not a new bug introduced by you, though.
> Mind fixing it?  You've already got it right for Spring mmc_1.

I was taught never to mix code movements with functional changes, as it
hides them even if mentioned in the commit message. Would you like me to
fix it pre- or post-move? Post-move would be easiest for me. ;)

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
