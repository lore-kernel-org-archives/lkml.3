Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3IYKUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:20:33 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38976 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3IYKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <000b01ceb9c4$1c77e0b0$5567a210$%han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
	<000b01ceb9c4$1c77e0b0$5567a210$%han@samsung.com>
Date: Wed, 25 Sep 2013 15:50:31 +0530
Message-ID: <CAK9yfHwJ57sH5ZfsTYzXBhSHyaw4YtYnPo6636x11tedQBX2Qg@mail.gmail.com>
Subject: Re: [PATCH 02/20] regulator: ab8500: use devm_regulator_register()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2013 13:21, Jingoo Han <jg1.han@samsung.com> wrote:
> Use devm_regulator_register() to make cleanup paths simpler.

> -       for (i = 0; i < abx500_regulator.info_size; i++) {
> -               struct ab8500_regulator_info *info = NULL;
> -               info = &abx500_regulator.info[i];
> -
> -               dev_vdbg(rdev_get_dev(info->regulator),
> -                       "%s-remove\n", info->desc.name);
> -
> -               regulator_unregister(info->regulator);
> -       }
> +       int err;
>
>         /* remove regulator debug */
>         err = ab8500_regulator_debug_exit(pdev);

Wouldn't re-ordering (unregistering after ab8500_regulator_debug_exit)
cause any problems here ?

-- 
With warm regards,
Sachin
