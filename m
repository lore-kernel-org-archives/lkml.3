Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab3HSVSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:18:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47073 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3HSVSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:18:42 -0400
Message-ID: <52128BAD.6020903@wwwdotorg.org>
Date: Mon, 19 Aug 2013 15:18:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] max77693: added device tree support
References: <20130819104409.GA21520@lee--X1> <1376912426-14747-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1376912426-14747-1-git-send-email-a.hajda@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 05:40 AM, Andrzej Hajda wrote:
> max77693 mfd main device uses only wakeup field
> from max77693_platform_data. This field is mapped
> to wakeup-source common property in device tree.

> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt

>  Optional properties:
>  - regulators : The regulators of max77693 have to be instantiated under subnod
>    named "regulators" using the following format.
> +- wakeup-source : Indicates if the device can wakeup the system from the sleep
> +  state.

Does the property mean "can" or "should"?

"Can" implies that the property means something about the HW. What
exactly does it mean; perhaps that some specific output pin of the chip
has been wired to an input IRQ/GPIO of the SoC or PMIC that (can) wake
up the system? If so, which pin, signal, ...? Also, doesn't this also
depend on the SoC itself supporting its input IRQ/GPIO as a wakeup
source, so isn't some co-ordination required between the SoC and chip,
such that this property doesn't mean "can wakeup the system", but simply
"a signal is routed to the SoC, so perhaps it can wakeup the system".

"Should" implies policy, which probably shouldn't be represented in
device tree, since DT should describe the HW and not how it should be used.

Finally, if there was already a binding for max77693.txt, I don't think
the patch subject "added device tree support" is entirely accurate; this
change to the binding document seems to be more about adding a new
feature than adding DT support to the driver...
