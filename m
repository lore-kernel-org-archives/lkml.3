Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3IKRRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:17:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54913 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3IKRRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:17:12 -0400
Message-ID: <5230A593.9010401@wwwdotorg.org>
Date: Wed, 11 Sep 2013 11:17:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, rob.herring@calxeda.com, mark.rutland@arm.com,
        rob@landley.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH V2] regulator: core: add support for configuring turn-on
 time through constraints
References: <1378904331-5665-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1378904331-5665-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 06:58 AM, Laxman Dewangan wrote:
> The Turn-on time of the regulator depends on the regulator device's
> electrical characteristics. Sometimes regulator turn-on time also
> depends on the capacitive load on the given platform and it can be
> more than the datasheet value.
> 
> The driver provides the enable-time as per datasheet.
> 
> Add support for configure the enable ramp time through regulator
> constraints so that regulator core can take this value for enable
> time for that regulator.

> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt

>  - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
>    For hardwares which support disabling ramp rate, it should be explicitly
>    intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
> +- regulator-enable-ramp-delay: Turn-on time for regulator(in uSec). This is
> +  the time time taken to reach within some proportion of the target voltage
> +  from off state.

This is still a bit unclear. What proportion of the target voltage?
There's no mention that this describes the delay due to the
board/environment rather than the delay due to the internal operation of
the regulator itself. How about:

- regulator-enable-ramp-delay: The time taken, in uSec, for the supply
rail to reach the target voltage, plus/minus whatever tolerance the
board design requires, once the regulator output itself has ramped up.
This value is in addition to whatever built-in ramp time is inherent in
the regulator's own internal design or configuration. This property
describes the additional ramp time required due to board design issues
such as trace capacitance and load on the supply.

That's text repeats "additional" a bit, but I think describes the
situation correctly?
