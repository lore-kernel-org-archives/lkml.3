Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3JBFoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:44:03 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9663 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3JBFn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:43:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 01 Oct 2013 22:43:57 -0700
Message-ID: <524BB1B9.1040806@nvidia.com>
Date: Wed, 2 Oct 2013 08:40:09 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: Re: [PATCHv3 2/4] drm/tegra: Add runtime pm support for gr2d
References: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com> <1380024325-18280-3-git-send-email-amerilainen@nvidia.com> <524B10F0.7000301@wwwdotorg.org>
In-Reply-To: <524B10F0.7000301@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 09:14 PM, Stephen Warren wrote:
> On 09/24/2013 06:05 AM, Arto Merilainen wrote:
>> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
>
>> @@ -327,11 +336,48 @@ static int __exit gr2d_remove(struct platform_device *pdev)
>>   		host1x_syncpt_free(gr2d->client.syncpts[i]);
>>
>>   	host1x_channel_free(gr2d->channel);
>> +
>> +	if (pm_runtime_enabled(&pdev->dev))
>> +		pm_runtime_disable(&pdev->dev);
>> +	else
>> +		gr2d_runtime_suspend(&pdev->dev);
>
> This code is slightly different to the code in e.g.
> sound/soc/tegra/tegra20_i2s.c:remove(), whereas the code in probe() is
> identical. I'm not sure whether there's some advantage in this version?
> If so, perhaps the sound drivers should be updated to be consistent. If
> not, perhaps this driver should do the same thing as the I2S driver, so
> we keep the drivers consistent, and provide the same "example" code
> everywhere.

Hmm. I cannot immediately see any advantage in this version... I will 
update the patch.

>
>> +static int gr2d_runtime_suspend(struct device *dev)
>> +{
>> +	struct gr2d *gr2d;
>> +
>> +	gr2d = dev_get_drvdata(dev);
>> +	if (!gr2d)
>> +		return -EINVAL;
>
> Presumably, gr2d will never be NULL here, unless there's some chronic
> bug. Can't we re-write those last 5 lines as simply:
>
> 	struct gr2d *grd2 = dev_get_drvdata(dev);
>
> If that's not valid, we should probably update the audio drivers (and
> perhaps others) too.

I think you are correct. I cannot see any reason why that check is required.

- Arto
