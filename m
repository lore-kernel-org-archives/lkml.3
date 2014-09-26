Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaIZI2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:28:52 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:62361 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaIZI2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <1411662520-22795-4-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
	<1411662520-22795-4-git-send-email-geert+renesas@glider.be>
Date: Fri, 26 Sep 2014 10:28:48 +0200
Message-ID: <CAPDyKFq8oo2M4X3Awb4saijdwaWHMS4Eg0jEZw-3craXH5qVcg@mail.gmail.com>
Subject: Re: [PATCH v3 03/13] PM / Domains: Add DT bindings for PM QoS device latencies
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2014 18:28, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> PM QoS device start/stop and save/restore state latencies are more or
> less properties of the hardware.
> In legacy code, they're specified from platform code.
> On DT platforms, their values should come from DT.

I am not so sure about this.

First, I think there a too much software affecting these latencies to
call them hardware properties.

Second, I am not sure that the future version of genpd will have all
these four latencies, but maybe only two. Let's see. I would thus
suggest to put this patch on hold for a while.

Kind regards
Uffe

>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Should these properties be called "linux,*-latency"?
>
> v3:
>   - No changes
> v2:
>   - New
>
>  Documentation/devicetree/bindings/power/power_domain.txt | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt
> index 7bc421d84367d636..024815bc257723b1 100644
> --- a/Documentation/devicetree/bindings/power/power_domain.txt
> +++ b/Documentation/devicetree/bindings/power/power_domain.txt
> @@ -42,12 +42,22 @@ Required properties:
>   - power-domains : A phandle and PM domain specifier as defined by bindings of
>                     the power controller specified by phandle.
>
> +Optional properties:
> + - stop-latency: Stop latency of the device, in ns,
> + - start-latency: Start latency of the device, in ns,
> + - save-state-latency: Save-state latency of the device, in ns,
> + - restore-state-latency: Restore-state latency of the device, in ns.
> +
>  Example:
>
>         leaky-device@12350000 {
>                 compatible = "foo,i-leak-current";
>                 reg = <0x12350000 0x1000>;
>                 power-domains = <&power 0>;
> +               stop-latency = <250000>;
> +               start-latency = <250000>;
> +               save-state-latency = <250000>;
> +               restore-state-latency = <250000>;
>         };
>
>  The node above defines a typical PM domain consumer device, which is located
> --
> 1.9.1
>
