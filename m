Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3IZGOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:14:09 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53766 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3IZGOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:14:08 -0400
MIME-Version: 1.0
In-Reply-To: <000b01ceba5c$e35a8140$aa0f83c0$%han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
	<000b01ceba5c$e35a8140$aa0f83c0$%han@samsung.com>
Date: Thu, 26 Sep 2013 11:44:07 +0530
Message-ID: <CAK9yfHxSFZv-=cdsoLzYBBZhShX9iMgoBBfOCJDLA3_P_dGetg@mail.gmail.com>
Subject: Re: [PATCH V2 05/18] regulator: fixed: use devm_regulator_register()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        David Dajun Chen <david.chen@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 26 September 2013 07:35, Jingoo Han <jg1.han@samsung.com> wrote:
> Use devm_regulator_register() to make cleanup paths simpler.

>         struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
>
> -       regulator_unregister(drvdata->dev);
>         kfree(drvdata->desc.supply_name);
>         kfree(drvdata->desc.name);

Sorry, couldn't go through all your patches yesterday.
This one looks a bit scary too as some of the driver data is already
freed before unregistering.

-- 
With warm regards,
Sachin
