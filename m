Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3GOH3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:29:32 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18262 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3GOH3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:29:31 -0400
Date: Mon, 15 Jul 2013 09:29:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: linux@roeck-us.net, thierry.reding@gmail.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common
 codes
Message-ID: <20130715092922.36a7960a@endymion.delvare>
In-Reply-To: <51E39114.505@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-2-git-send-email-wni@nvidia.com>
	<20130712152615.23464a6b@endymion.delvare>
	<51E39114.505@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Mon, 15 Jul 2013 14:05:08 +0800, Wei Ni wrote:
> On 07/12/2013 09:26 PM, Jean Delvare wrote:
> > Can I see a recent version of the code which will need this change? It
> > makes no sense to apply this first part which makes the code more
> > complex with no benefit, without the second part which needs it, so
> > they should be applied together or not at all.
> 
> In my RFC patches, there had many codes about thermal fw, which need
> this patch, so I put them together.
> And now I split the RFC patches, this series is preparing to use the
> thermal fw.
> As you said, I want to register lm90 as the thermal zone device, it need
> to hook some callback, such as .get_temp. if apply this patch, I can
> write the .get_temp simply, something like:
> 
> +static int lm90_read_temp2_temp(struct thermal_zone_device *thz,
> unsigned long *temp)
> +{
> +        struct lm90_data *data = thz->devdata;
> +        struct i2c_client *client = to_i2c_client(data->hwmon_dev->parent);
> +        struct device *dev = &client->dev;+
> +
> +        *temp = (long)read_temp11(dev, TEMP11_REMOTE_TEMP);
> +
> +        return 0;
> +}
> +
> +static struct thermal_zone_device_ops remote_ops = {
> +        .get_temp = lm90_read_temp2_temp,
> +};
> 
> If without this patch, I have to rewrite the lm90_read_temp2_temp(),
> which almost same as the show_temp11(), I think it's not good. When use
> this patch and following 3/3 patch, the code will be more readable and
> clear.

I understand the idea.

> Anyway, if you want, I can send this patch as a separate one. :)

Yes please, I think it would help me do a better code review and
testing as well.

-- 
Jean Delvare
