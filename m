Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3EXDBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:01:47 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52458 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab3EXDBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:01:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130522161422.GP1627@sirena.org.uk>
References: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
	<20130522161422.GP1627@sirena.org.uk>
Date: Fri, 24 May 2013 11:01:45 +0800
Message-ID: <CAK=oMXepj7tmZJ3=b9ja+E1N9eAPmsPhBefAzoswVyGWBXwNOA@mail.gmail.com>
Subject: Re: [PATCH] regulator: 88pm800: add regulator driver
From: yi zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, cxie4@marvell.com, jett.zhou@marvell.com,
        linux-kernel@vger.kernel.org, Yi Zhang <yizhang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Brown:

2013/5/23 Mark Brown <broonie@kernel.org>:
> On Wed, May 22, 2013 at 08:10:53PM +0800, yizhang.mrvl@gmail.com wrote:
>
> You need a DT binding document for any new DT bindings like this one.
>
Thanks for your comments, I'll do it;

>> +static const unsigned int BUCK1_table[] = {
>> +     /* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
>> +     /* 0x50-0x7F: from 1.6 to 1.8V with step 0.05V */
>
> Write this out as code, don't use a big table for large sets of
> voltages.

     The voltage table is "const", if we write it out as code, seems
it's hard for us
     to keep this attribute;
     And the voltage of this BUCK is not linear(it's separated as two parts),
     seems I shouldn't use the framework helpers to implement it; Right?
      what do you think?

>> +static int pm800_list_voltage(struct regulator_dev *rdev, unsigned index)
>> +{
>> +     struct pm800_regulator_info *info = rdev_get_drvdata(rdev);
>> +     int ret = -EINVAL;
>> +
>> +     if (info->vol_table && (index < rdev->desc->n_voltages))
>> +             ret = info->vol_table[index];
>> +
>> +     return ret;
>> +}
>
> For things that are just table lookups use the framework helpers.
>
   OK, I'll change it; thanks for your comments;
>> +static int choose_voltage(struct regulator_dev *rdev, int min_uv, int max_uv)
>> +{
>
> Similarly here.
>
    OK, copy that; thanks;

>> +static int pm800_set_voltage(struct regulator_dev *rdev,
>> +                          int min_uv, int max_uv, unsigned *sel)
>> +{
>> +     *sel = choose_voltage(rdev, min_uv, max_uv);
>> +     if (*sel < 0)
>> +             return -EINVAL;
>> +     return regulator_set_voltage_sel_regmap(rdev, *sel);
>> +}
>
> Implement map_voltage.
>
>> +     for_each_child_of_node(nproot, np) {
>> +             if (!of_node_cmp(np->name, info->desc.name)) {
>> +                     config->init_data =
>> +                             of_get_regulator_init_data(&pdev->dev, np);
>> +                     config->of_node = np;
>> +                     break;
>> +             }
>> +     }
>
> Use of_regulator_match().

    Copy that, thanks for your comment; I'll change it;
