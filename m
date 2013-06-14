Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3FNOsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:48:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10362 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3FNOse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:48:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 14 Jun 2013 07:47:16 -0700
Message-ID: <51BB2D3A.1050407@nvidia.com>
Date: Fri, 14 Jun 2013 20:18:26 +0530
From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Organization: NVIDIA Graphics Pvt Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] gpu: host1x: add runtime pm support for dc
References: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com> <1371117218-2326-4-git-send-email-mkulkarni@nvidia.com> <20130613184938.GE32574@mithrandir> <51BA18EF.4090302@wwwdotorg.org>
In-Reply-To: <51BA18EF.4090302@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013 12:39 AM, Stephen Warren wrote:
> On 06/13/2013 12:49 PM, Thierry Reding wrote:
>> On Thu, Jun 13, 2013 at 03:23:37PM +0530, Mayuresh Kulkarni wrote:
>> [...]
>>> diff --git a/drivers/gpu/host1x/drm/dc.c
>>> b/drivers/gpu/host1x/drm/dc.c
>> [...]
>>> @@ -1128,9 +1129,7 @@ static int tegra_dc_probe(struct
>>> platform_device *pdev) return PTR_ERR(dc->clk); }
>>>
>>> -	err = clk_prepare_enable(dc->clk); -	if (err < 0) -		return
>>> err; +	platform_set_drvdata(pdev, dc);
>>
>> Why do you move the call to platform_set_drvdata() up here?
>
> Presumably the suspend/resume functions need to get the value out of
> the device they're passed, so it needs to be set up early?
>

Yes that is correct, Stephen. The run-time pm call-backs need 2 things: 
correct driver data pointer and correct clock pointer within it. Hence I 
had to move this line upper in sequence.

Same is applicable to gr2d and host1x patches as well.
