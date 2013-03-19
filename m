Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3CSQh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:37:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13983 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab3CSQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:37:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 09:37:16 -0700
Message-ID: <51489439.7080901@nvidia.com>
Date: Tue, 19 Mar 2013 18:37:13 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCHv7 10/10] drm: tegra: Add gr2d device
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com> <1363178186-2017-11-git-send-email-tbergstrom@nvidia.com> <20130315121332.GA3374@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130315121332.GA3374@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.03.2013 14:13, Thierry Reding wrote:
> Also you now create a lookup table (or bitfield actually) as we
> discussed but you still pass around a function to check the lookup table
> against. What I originally intended was to not pass a function around at
> all but directly use the lookup table/bitfield. However I think we can
> leave this as-is for now and change it later if required.

Yeah, I think it's better if we leave this as is now. We should actually
have one table for host1x and one for 2D. The host1x one should be
shared between the drivers, but the table for client unit should be
local to the driver.

Let's take this up again when we have another driver.

> 
>> +static int gr2d_probe(struct platform_device *pdev)
>> +{
>> +     struct device *dev = &pdev->dev;
>> +     struct host1x_drm *host1x = host1x_get_drm_data(dev->parent);
>> +     int err;
>> +     struct gr2d *gr2d = NULL;
>> +     struct host1x_syncpt **syncpts;
> 
> I don't think there's a need for this temporary variable. You could just
> use gr2d->client.syncpts directly.

I actually ended up with pretty long lines when I tried this, so I hope
it's ok to leave as is.

> 
>> +     gr2d = devm_kzalloc(dev, sizeof(*gr2d), GFP_KERNEL);
>> +     if (!gr2d)
>> +             return -ENOMEM;
>> +
>> +     syncpts = devm_kzalloc(dev, sizeof(*syncpts), GFP_KERNEL);

F.ex. this line would split two two lines.

Otherwise the changes should be now pretty much ok. You sent a bunch of
changes (thanks) that I merged to my tree. I'll just need to do some
testing and re-split the patches and send v8.

Terje
