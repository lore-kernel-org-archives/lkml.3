Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaGDF5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 01:57:44 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:43161 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaGDF5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 01:57:42 -0400
MIME-Version: 1.0
In-Reply-To: <53B5131B.1060702@samsung.com>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-2-git-send-email-acourbot@nvidia.com> <53B5131B.1060702@samsung.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 4 Jul 2014 14:57:21 +0900
Message-ID: <CAAVeFu+sTWhwCTd9ntqdJQA1aaFV93zHnyRSj6WA-8VicFuvgQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm/dsi: Add flag for continuous clock behavior
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrejz,

On Thu, Jul 3, 2014 at 5:23 PM, Andrzej Hajda <a.hajda@samsung.com> wrote:
>
> Hi Alexandre,
>
> Thanks for the patch.
>
> On 07/02/2014 02:19 PM, Alexandre Courbot wrote:
>> As per section 5.6.1 of the DSI specification, all DSI transmitters must
>> support continuous clock behavior on the clock lane, while non-continuous
>> mode support is only optional. Add a flag that allows devices to indicate
>> that they require continuous clock mode to operate properly.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  include/drm/drm_mipi_dsi.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
>> index 944f33f..5913ef4 100644
>> --- a/include/drm/drm_mipi_dsi.h
>> +++ b/include/drm/drm_mipi_dsi.h
>> @@ -94,6 +94,8 @@ void mipi_dsi_host_unregister(struct mipi_dsi_host *host);
>>  #define MIPI_DSI_MODE_VSYNC_FLUSH    BIT(8)
>>  /* disable EoT packets in HS mode */
>>  #define MIPI_DSI_MODE_EOT_PACKET     BIT(9)
>> +/* use continuous clock behavior on the clock lane */
>> +#define MIPI_DSI_MODE_CLOCK_CONTINUOUS       BIT(10)
>>
>
> According to MIPI DSI specification "All DSI transmitters and receivers
> shall support continuous clock behavior on the Clock Lane, and
> optionally may support non-continuous clock behavior". It suggests that
> continuous clock should be default behavior. So maybe better is to
> introduce sth like:
> +#define MIPI_DSI_MODE_CLOCK_NON_CONTINUOUS     BIT(10)

I started under the assumption that current host drivers assumed
non-continuous clock (as the Tegra driver currently does). In that
light, it seemed to make sense (and to be less intrusive) to introduce
that flag as a restriction rather than a capability. But if you think
this should be a capability I am not strongly against it - either way,
host drivers need to be changed to take that flag into account.
