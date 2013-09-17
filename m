Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3IQVd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:33:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60884 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3IQVd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:33:56 -0400
Message-ID: <5238CABF.4010606@wwwdotorg.org>
Date: Tue, 17 Sep 2013 15:33:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, swarren@nvidia.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, rob@landley.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com
Subject: Re: [PATCH V3] regulator: core: add support for configuring turn-on
 time through constraints
References: <1379418354-27269-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379418354-27269-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 05:45 AM, Laxman Dewangan wrote:
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

> +- regulator-enable-ramp-delay: Turn-on time for regulator(in microsecond).

You need a space before (. You don't even need the brackets.
microseconds not microsecond.

> +  This is the time time taken to reach the target voltage from off state.
> +  The delay specified in the DT to just completely override what the drivers
> +  know.

This description references driver behaviour which it really shouldn't.
Instead, it should describe the HW itself. How about the following text,
which I suggested last time:

- regulator-enable-ramp-delay: The time taken, in microseconds, for the
supply rail to reach the target voltage, plus/minus whatever tolerance
the board design requires. This property describes the total system ramp
time required due to the combination of internal ramping of the
regulator itself, and board design issues such as trace capacitance and
load on the supply.

