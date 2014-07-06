Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaGFJbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:31:20 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:43679 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaGFJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:31:18 -0400
MIME-Version: 1.0
In-Reply-To: <53B679A0.1060306@samsung.com>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-2-git-send-email-acourbot@nvidia.com> <53B5131B.1060702@samsung.com>
 <CAAVeFu+sTWhwCTd9ntqdJQA1aaFV93zHnyRSj6WA-8VicFuvgQ@mail.gmail.com> <53B679A0.1060306@samsung.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 6 Jul 2014 18:30:57 +0900
Message-ID: <CAAVeFuLxJ0AwHJFf1A3z1ezCXHonMayQUoy-Re2_R=3mLaS7Rg@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm/dsi: Add flag for continuous clock behavior
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 6:53 PM, Andrzej Hajda <a.hajda@samsung.com> wrote:
> On 07/04/2014 07:57 AM, Alexandre Courbot wrote:
>> Hi Andrejz,
>>
>> On Thu, Jul 3, 2014 at 5:23 PM, Andrzej Hajda <a.hajda@samsung.com> wrote:
>>> Hi Alexandre,
>>>
>>> Thanks for the patch.
>>>
>>> On 07/02/2014 02:19 PM, Alexandre Courbot wrote:
>>>> As per section 5.6.1 of the DSI specification, all DSI transmitters must
>>>> support continuous clock behavior on the clock lane, while non-continuous
>>>> mode support is only optional. Add a flag that allows devices to indicate
>>>> that they require continuous clock mode to operate properly.
>>>>
>>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>>> ---
>>>>  include/drm/drm_mipi_dsi.h | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
>>>> index 944f33f..5913ef4 100644
>>>> --- a/include/drm/drm_mipi_dsi.h
>>>> +++ b/include/drm/drm_mipi_dsi.h
>>>> @@ -94,6 +94,8 @@ void mipi_dsi_host_unregister(struct mipi_dsi_host *host);
>>>>  #define MIPI_DSI_MODE_VSYNC_FLUSH    BIT(8)
>>>>  /* disable EoT packets in HS mode */
>>>>  #define MIPI_DSI_MODE_EOT_PACKET     BIT(9)
>>>> +/* use continuous clock behavior on the clock lane */
>>>> +#define MIPI_DSI_MODE_CLOCK_CONTINUOUS       BIT(10)
>>>>
>>> According to MIPI DSI specification "All DSI transmitters and receivers
>>> shall support continuous clock behavior on the Clock Lane, and
>>> optionally may support non-continuous clock behavior". It suggests that
>>> continuous clock should be default behavior. So maybe better is to
>>> introduce sth like:
>>> +#define MIPI_DSI_MODE_CLOCK_NON_CONTINUOUS     BIT(10)
>> I started under the assumption that current host drivers assumed
>> non-continuous clock (as the Tegra driver currently does).
>
> Exynos DSI driver uses continuous clock.
> Currently, in mainline,  there are no more dsi hosts using drm_mipi_dsi.h.
> As I stated before I prefer to follow dsi specification and it states
> clearly that
> continuous behavior is required, non-continouous is optional.
> Moreover for tegra chip continuous behavior is also the default one.

Makes perfect sense indeed, especially if we have only two users of
this interface for now. Will resubmit this series to make the Tegra
driver use continuous clock by default, and update the panels it used
to far to make use of the new flag.

Thanks,
Alex.
