Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaIDRGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:06:07 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57515 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaIDRGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:06:04 -0400
Date: Thu, 4 Sep 2014 10:06:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH v4 1/4] thermal: rockchip: add driver for thermal
Message-ID: <20140904170559.GB10224@core.coreip.homeip.net>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com>
 <1409710239-19941-2-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409710239-19941-2-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Wed, Sep 03, 2014 at 10:10:36AM +0800, Caesar Wang wrote:
> +static int rockchip_thermal_remove(struct platform_device *pdev)
> +{
> +	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
> +
> +	rockchip_thermal_control(data, false);
> +
> +	thermal_zone_device_unregister(data->tz);
> +	cpufreq_cooling_unregister(data->cdev);
> +	cpufreq_cooling_unregister(data->cdev);

It looks like we are unregistering the same cooling device one too many times.

Thanks.

-- 
Dmitry
