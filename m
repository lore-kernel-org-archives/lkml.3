Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3JIIZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:25:04 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:51785 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab3JIIZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:25:00 -0400
Message-ID: <5255128F.8090107@mm-sol.com>
Date: Wed, 09 Oct 2013 11:23:43 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
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
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <1380811955-18085-3-git-send-email-svarbanov@mm-sol.com> <524DC4B1.4050100@codeaurora.org> <524EED4E.8090505@mm-sol.com> <524EEEC5.7090803@codeaurora.org>
In-Reply-To: <524EEEC5.7090803@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 10/04/2013 07:37 PM, Stephen Boyd wrote:
> On 10/04/13 09:31, Stanimir Varbanov wrote:
>>
>>>> +static int msm_rng_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct msm_rng *rng;
>>>> +	struct device_node *np;
>>>> +	struct resource res;
>>>> +	int ret;
>>>> +
>>>> +	np = of_node_get(pdev->dev.of_node);
>>>> +	if (!np)
>>>> +		return -ENODEV;
>>> This is unnecessary.
>> I used this call because CONFIG_OF_DYNAMIC could be enabled at some
>> time. Isn't that possible? I saw that of_node_get|put is used in .probe
>> on few places in drivers.
> 
> So far we aren't selecting that config on ARM.
> 
> If you look at of_device_alloc() you'll see
> 
>     dev->dev.of_node = of_node_get(np);
> 
> so any platform devices created from of_platform_populate won't have
> their of_node go away.

Thanks for the pointers, it makes sense. I'll remove the calls to
of_node_get|put.

regards,
Stan


