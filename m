Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaGINGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:06:43 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41472 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbaGINGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:06:40 -0400
Message-ID: <53BD3E54.3030205@collabora.com>
Date: Wed, 09 Jul 2014 15:06:28 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, rafael.j.wysocki@intel.com, nm@ti.com,
        b.zolnierkie@samsaung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Thierry Reding <treding@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common
 ppmu driver
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com> <5323432E.5060005@samsung.com> <532656B1.2010907@samsung.com>
In-Reply-To: <532656B1.2010907@samsung.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 02:58 AM, Chanwoo Choi wrote:
> Hi Tomasz,
>
> On 03/15/2014 02:58 AM, Tomasz Figa wrote:
>>
>> However, this driver, even after applying your series, is still far
>> from a state that would allow it to be enabled. The most important
>> issue is direct access to CMU registers, based on static mapping,
>> which is not allowed on multiplatform kernels and
>> multiplatform-awareness for drivers is currently a must.
>>
>> To allow this driver to be enabled, it needs to be converted to use
>> common clock framework functions to configure all clocks, e.g.
>> clk_set_rate(), clk_set_parent(), etc., without accessing CMU
>> registers directly.
>>
>> Of course as long as the driver is effectively unusable, to keep
>> development, we can proceed with refactoring it step-by-step and
>> your series would be basically the first step, after addressing the
>> review comments.
>>
>
> I agree your opinion. When setting frequency of memory bus, this
> driver access directly to CMU registers. I know it should be modified
> by using common clk framework as your comment.
>
> I'll send patch set about using common clk framework instead of CMU
> register based on static mapping after finished the review and apply
> of this patch set as next step.

Hi Chanwoo,

any news on this?

I would love to test this devfreq driver with the clk_set_floor_rate API 
I'm adding to the common clk framework.

Regards,

Tomeu
