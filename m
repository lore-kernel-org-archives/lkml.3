Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915Ab3IDPQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:16:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39266 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab3IDPQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:16:12 -0400
Message-ID: <52274E9F.4050708@ti.com>
Date: Wed, 4 Sep 2013 10:15:43 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Sachin Kamat <sachin.kamat@linaro.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <yong.shen@linaro.org>,
        <s.hauer@pengutronix.de>, <marek.vasut@gmail.com>,
        <Nancy.Chen@freescale.com>
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org> <1378276263-10735-7-git-send-email-sachin.kamat@linaro.org> <5227355C.1020205@ti.com> <20130904151241.GB10849@sirena.org.uk>
In-Reply-To: <20130904151241.GB10849@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 10:12 AM, Mark Brown wrote:
> On Wed, Sep 04, 2013 at 08:27:56AM -0500, Nishanth Menon wrote:
>> On 09/04/2013 01:31 AM, Sachin Kamat wrote:
> 
>>>  	abb = devm_kzalloc(dev, sizeof(struct ti_abb), GFP_KERNEL);
>>> -	if (!abb) {
>>> -		dev_err(dev, "%s: Unable to allocate ABB struct\n", __func__);
>>> -		ret = -ENOMEM;
>>> -		goto err;
>>> -	}
>>> +	if (!abb)
>>> +		return -ENOMEM;
> 
>> here.
> 
> kzalloc() complains loudly when it fails, there's been a general thing
> for removing the per-device logs as redundant.
> 
True, but for the remaining, I do not thing it kind of helps to quiet
things up.

-- 
Regards,
Nishanth Menon
