Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3HZNTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:19:10 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:53387 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751669Ab3HZNTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:19:08 -0400
Message-ID: <521B5597.6030802@overkiz.com>
Date: Mon, 26 Aug 2013 15:18:15 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH v2 2/4] watchdog: at91sam9_wdt: update device tree doc
References: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com> <1371799414-3654-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1371799414-3654-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6180909014064330873
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I missed Grant's ack on this patch:

Acked-by: Grant Likely<grant.likely@linaro.org>

Best Regards,

Boris
On 21/06/2013 09:23, Boris BREZILLON wrote:
> Add new at91sam9 watchdog properties to the documentation.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 ++++++++++++++++++--
>   1 file changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> index fcdd48f..e043106 100644
> --- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> @@ -9,11 +9,37 @@ Required properties:
>   
>   Optional properties:
>   - timeout-sec: contains the watchdog timeout in seconds.
> +- interrupts : Should contain WDT interrupt.
> +- atmel,max-heartbeat-sec : Should contain the maximum heartbeat value in
> +	seconds. This value should be less than 16. It is used to compute the
> +	WDV field.
> +- atmel,min-heartbeat-sec : Should contain the minimum heartbeat value in
> +	seconds. This value should be less than 4 times the max-heartbeat-sec
> +	value. It is used to compute the WDD field.
> +- atmel,watchdog-type : Should be "hardware" or "software". Hardware watchdog
> +	use the at91 watchdog reset. Software watchdog use the watchdog
> +	interrupt to trigger a software reset.
> +- atmel,reset-type : Should be "proc" or "all".
> +	"all" : assert peripherals and processor reset signals
> +	"proc" : assert the processor reset signal
> +	This is valid only when using "hardware" watchdog.
> +- atmel,disable : Should be present if you want to disable the watchdog.
> +- atmel,idle-halt : Should be present if you want to stop the watchdog when
> +	entering idle state.
> +- atmel,dbg-halt : Should be present if you want to stop the watchdog when
> +	entering debug state.
>   
>   Example:
> -
>   	watchdog@fffffd40 {
>   		compatible = "atmel,at91sam9260-wdt";
>   		reg = <0xfffffd40 0x10>;
> -		timeout-sec = <10>;
> +		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +		timeout-sec = <15>;
> +		atmel,watchdog-type = "hardware";
> +		atmel,reset-type = "all";
> +		atmel,dbg-halt;
> +		atmel,idle-halt;
> +		atmel,max-heartbeat-sec = <16>;
> +		atmel,min-heartbeat-sec = <0>;
> +		status = "okay";
>   	};

