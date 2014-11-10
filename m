Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaKJPGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:06:55 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:61731 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKJPGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:06:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        khilman@linaro.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 10 Nov 2014 16:06:19 +0100
Message-ID: <5331397.OQCQmJO78C@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415631557-22897-2-git-send-email-grygorii.strashko@ti.com>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <1415631557-22897-2-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LqnA3gWgm1J+sWqjXA1lBv7di53U9h57SX5xhseRp0y
 xGnamg3wcxWo88o+9241rSkrk6tMXQ0YMGWzT04NghbhKYZfym
 SL7KEmE8r0D8sqmPVO/0TcgiBmQIZJXR64LqNHLjq5xeUMfuGY
 bpMFut2c3mRWhFkEOldhjGCiEg2FOtTCaJjvTeZQEU4wuRNZTh
 8EfVkPXgkH0QdfAVb+jUpqfV/iaPI2LJHdh/V+PIoLPNqEl/iB
 +1Vx2uRZ74okDpoiUDZJU+iRCoIjqGkbyhknxIr7Ye5naeaGBD
 /qPMu99u8KWVJHKTz7jextlJNKKbCus0J+CjP5hWrdLayXCr7f
 VpqdLTNKHjaRv2SKdE5E=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2014 16:59:16 Grygorii Strashko wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
> @@ -0,0 +1,31 @@
> +* TI Keystone 2 Generic PM Controller
> +
> +The TI Keystone 2 Generic PM Controller is responsible for Clock gating
> +for each controlled IP module.
> +
> +Required properties:
> +- compatible: Should be "ti,keystone-powerdomain"
> +- #power-domain-cells: Should be 0, see below:
> +
> +The PM Controller node is a PM domain as documented in
> +Documentation/devicetree/bindings/power/power_domain.txt.
> +
> +Example:
> +
> +       pm_controller: pm-controller {
> +               compatible = "ti,keystone-powerdomain";
> +               #power-domain-cells = <0>;
> +       };
> +
> +       netcp: netcp@2090000 {
> +               reg = <0x2620110 0x8>;
> +               reg-names = "efuse";
> +               ...
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;
> +               power-domains = <&pm_controller>;
> +
> +               clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
> +               dma-coherent;
> +       }

I don't get it. What keystone specific about a "ti,keystone-powerdomain"
device? It seems that the device has no registers whatsoever and the
driver doesn't really do anything that relates to the platform.

	Arnd
