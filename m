Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaKJRjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:39:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43727 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbaKJRi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:38:57 -0500
Message-ID: <5460F806.3040305@ti.com>
Date: Mon, 10 Nov 2014 19:38:14 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <1415631557-22897-2-git-send-email-grygorii.strashko@ti.com> <5331397.OQCQmJO78C@wuerfel>
In-Reply-To: <5331397.OQCQmJO78C@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 11/10/2014 05:06 PM, Arnd Bergmann wrote:
> On Monday 10 November 2014 16:59:16 Grygorii Strashko wrote:
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
>> @@ -0,0 +1,31 @@
>> +* TI Keystone 2 Generic PM Controller
>> +
>> +The TI Keystone 2 Generic PM Controller is responsible for Clock gating
>> +for each controlled IP module.
>> +
>> +Required properties:
>> +- compatible: Should be "ti,keystone-powerdomain"
>> +- #power-domain-cells: Should be 0, see below:
>> +
>> +The PM Controller node is a PM domain as documented in
>> +Documentation/devicetree/bindings/power/power_domain.txt.
>> +
>> +Example:
>> +
>> +       pm_controller: pm-controller {
>> +               compatible = "ti,keystone-powerdomain";
>> +               #power-domain-cells = <0>;
>> +       };
>> +
>> +       netcp: netcp@2090000 {
>> +               reg = <0x2620110 0x8>;
>> +               reg-names = "efuse";
>> +               ...
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               ranges;
>> +               power-domains = <&pm_controller>;
>> +
>> +               clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
>> +               dma-coherent;
>> +       }
> 
> I don't get it. What keystone specific about a "ti,keystone-powerdomain"
> device? It seems that the device has no registers whatsoever and the
> driver doesn't really do anything that relates to the platform.

That's true. but it was the only one acceptable way  to enable
Generic clock manipulation PM callbacks for the DT-boot case.
After several unsuccessful attempts the idea to use GPD
was introduced by Kevin there:
  https://lkml.org/lkml/2014/9/8/643

So, The Keystone 2 Generic PM Controller is just a proxy PM layer here between
device and Generic clock manipulation PM callbacks.
It fills per-device clock list when device is attached to GPD and
ensures that all clocks from that list enabled/disabled when device is
started/stopped.

Regards,
-grygorii
