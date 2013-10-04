Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3JDQhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:37:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34030 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3JDQh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:37:27 -0400
Message-ID: <524EEEC5.7090803@codeaurora.org>
Date: Fri, 04 Oct 2013 09:37:25 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] hwrng: msm: Add PRNG support for MSM SoC's
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <1380811955-18085-3-git-send-email-svarbanov@mm-sol.com> <524DC4B1.4050100@codeaurora.org> <524EED4E.8090505@mm-sol.com>
In-Reply-To: <524EED4E.8090505@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 09:31, Stanimir Varbanov wrote:
>
>>> +static int msm_rng_probe(struct platform_device *pdev)
>>> +{
>>> +	struct msm_rng *rng;
>>> +	struct device_node *np;
>>> +	struct resource res;
>>> +	int ret;
>>> +
>>> +	np = of_node_get(pdev->dev.of_node);
>>> +	if (!np)
>>> +		return -ENODEV;
>> This is unnecessary.
> I used this call because CONFIG_OF_DYNAMIC could be enabled at some
> time. Isn't that possible? I saw that of_node_get|put is used in .probe
> on few places in drivers.

So far we aren't selecting that config on ARM.

If you look at of_device_alloc() you'll see

    dev->dev.of_node = of_node_get(np);

so any platform devices created from of_platform_populate won't have
their of_node go away.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

