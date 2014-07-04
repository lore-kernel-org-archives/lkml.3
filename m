Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaGDJxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:53:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52174 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaGDJxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:53:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-b1-53b679a2b0dc
Message-id: <53B679A0.1060306@samsung.com>
Date: Fri, 04 Jul 2014 11:53:36 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 1/4] drm/dsi: Add flag for continuous clock behavior
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-2-git-send-email-acourbot@nvidia.com>
 <53B5131B.1060702@samsung.com>
 <CAAVeFu+sTWhwCTd9ntqdJQA1aaFV93zHnyRSj6WA-8VicFuvgQ@mail.gmail.com>
In-reply-to: <CAAVeFu+sTWhwCTd9ntqdJQA1aaFV93zHnyRSj6WA-8VicFuvgQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7qLKrcFG7R9NLb4/vAUq8WVr+/Z
	LM69esRicXnXHDaLzi+z2CxeHWxjsTjVJmvxc9c8FgcOj52z7rJ73O8+zuTR2/yOzePzJjmP
	jXNDA1ijuGxSUnMyy1KL9O0SuDK2nVzNWPBWqGLaZP8Gxl38XYycHBICJhIvDq9lg7DFJC7c
	Ww9kc3EICSxllPj8bg0rhPOJUeLBvbWMIFW8AloSM9pWMYPYLAKqEl0T17CD2GwCmhJ/N98E
	myQqECFxoO8ZK0S9oMSPyfdYQGwRgVCJ/p9HwIYyCxxikji0/x/YUGEBD4ljiycxQmx7yihx
	f+MlsA5OgWCJhmXLwCYxC6hLTJq3iBnClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZVjKKppckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGCHh/mUH4+JjVocYBTgYlXh4G1dsCBZiTSwrrsw9xCjBwawk
	wttStC1YiDclsbIqtSg/vqg0J7X4ECMTB6dUA6PLH8+Zd8TUjttsnLD8jcvqgJRpvJz2/1tl
	9vvnW/y8//RXtKFTheM0EZWcOTtSLDfGKkU9lWbY6d9vc8nqxedHZvecTueIH2z0rGRQnpjT
	dOJ0MkNvWqHsQY75RaHHLmzROrCn4a/Qorf5G1zv7a06rLqYdYbw7aNPPRbtsplrEZJ/88aN
	fXeVWIozEg21mIuKEwEvEoNnVQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 07:57 AM, Alexandre Courbot wrote:
> Hi Andrejz,
>
> On Thu, Jul 3, 2014 at 5:23 PM, Andrzej Hajda <a.hajda@samsung.com> wrote:
>> Hi Alexandre,
>>
>> Thanks for the patch.
>>
>> On 07/02/2014 02:19 PM, Alexandre Courbot wrote:
>>> As per section 5.6.1 of the DSI specification, all DSI transmitters must
>>> support continuous clock behavior on the clock lane, while non-continuous
>>> mode support is only optional. Add a flag that allows devices to indicate
>>> that they require continuous clock mode to operate properly.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>> ---
>>>  include/drm/drm_mipi_dsi.h | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
>>> index 944f33f..5913ef4 100644
>>> --- a/include/drm/drm_mipi_dsi.h
>>> +++ b/include/drm/drm_mipi_dsi.h
>>> @@ -94,6 +94,8 @@ void mipi_dsi_host_unregister(struct mipi_dsi_host *host);
>>>  #define MIPI_DSI_MODE_VSYNC_FLUSH    BIT(8)
>>>  /* disable EoT packets in HS mode */
>>>  #define MIPI_DSI_MODE_EOT_PACKET     BIT(9)
>>> +/* use continuous clock behavior on the clock lane */
>>> +#define MIPI_DSI_MODE_CLOCK_CONTINUOUS       BIT(10)
>>>
>> According to MIPI DSI specification "All DSI transmitters and receivers
>> shall support continuous clock behavior on the Clock Lane, and
>> optionally may support non-continuous clock behavior". It suggests that
>> continuous clock should be default behavior. So maybe better is to
>> introduce sth like:
>> +#define MIPI_DSI_MODE_CLOCK_NON_CONTINUOUS     BIT(10)
> I started under the assumption that current host drivers assumed
> non-continuous clock (as the Tegra driver currently does).

Exynos DSI driver uses continuous clock.
Currently, in mainline,  there are no more dsi hosts using drm_mipi_dsi.h.
As I stated before I prefer to follow dsi specification and it states
clearly that
continuous behavior is required, non-continouous is optional.
Moreover for tegra chip continuous behavior is also the default one.

Regards
Andrzej

>  In that
> light, it seemed to make sense (and to be less intrusive) to introduce
> that flag as a restriction rather than a capability. But if you think
> this should be a capability I am not strongly against it - either way,
> host drivers need to be changed to take that flag into account.
>

