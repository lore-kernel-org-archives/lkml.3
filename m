Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaCDFBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:01:46 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49948 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaCDFBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:01:45 -0500
MIME-Version: 1.0
In-Reply-To: <1393903494.20435.13.camel@joe-AO722>
References: <2825545.2YpN0JuVSn@daeseok-laptop.cloud.net>
	<1393903494.20435.13.camel@joe-AO722>
Date: Tue, 4 Mar 2014 14:01:44 +0900
Message-ID: <CAHb8M2DOE-Rk6b4zLNHwa3x_WKY5Ex7N26xs7BuQMH+okV6O8A@mail.gmail.com>
Subject: Re: [PATCH 3/7] staging: cxt1e1: Fix line length over 80 characters
 in linux.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        Shaun Laing <shaun@xresource.ca>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        "ying.xue" <ying.xue@windriver.com>,
        David Miller <davem@davemloft.net>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for review.

How about fix it as your comment within another patch?

I sent many smaller patches for fixing coding style and other things.
And I think this patch has just fixed about long line length, so I
want to let it leave this change and
I will send a patch after fixing as your comment.

just my opinion.

Regards.
Daeseok Youn.

2014-03-04 12:24 GMT+09:00 Joe Perches <joe@perches.com>:
> On Tue, 2014-03-04 at 11:08 +0900, Daeseok Youn wrote:
>> clean up checkpatch.pl warnings:
>>  WARNING: Line length over 80 characters
>
> Please run your patches through checkpatch.
>
>> diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
>
>> @@ -431,13 +432,15 @@ create_chan(struct net_device *ndev, ci_t *ci,
>>               priv = OS_kmalloc(sizeof(struct c4_priv));
>>               if (!priv)
>>               {
>> -                     pr_warning("%s: no memory for net_device !\n", ci->devname);
>> +                     pr_warning("%s: no memory for net_device !\n",
>> +                                ci->devname);
>
> pr_warn would be nice
>
>> @@ -458,10 +461,12 @@ create_chan(struct net_device *ndev, ci_t *ci,
>>               switch (hi->promfmt)
>>               {
>>               case PROM_FORMAT_TYPE1:
>> -                     memcpy(dev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
>> +                     memcpy(dev->dev_addr,
>> +                            (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
>
> Likely better to remove the (FLD_TYPE1 *) altogether.
>
>>                       break;
>>               case PROM_FORMAT_TYPE2:
>> -                     memcpy(dev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
>> +                     memcpy(dev->dev_addr,
>> +                            (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
>
> Likely better to remove the (FLD_TYPE2 *) too.
> Maybe consolidate the blocks too.
>
>
>> @@ -1053,13 +1065,15 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
>>               switch (hi->promfmt)
>>               {
>>               case PROM_FORMAT_TYPE1:
>> -                     memcpy(ndev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
>> +                     memcpy(ndev->dev_addr,
>> +                            (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
>
> unnecessary casts?
>
>>                       /* unaligned data acquisition */
>>                       memcpy(&tmp, (FLD_TYPE1 *) (hi->mfg_info.pft1.Id), 4);
>
> here too.
>
>>                       ci->brd_id = cpu_to_be32(tmp);
>>                       break;
>>               case PROM_FORMAT_TYPE2:
>> -                     memcpy(ndev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
>> +                     memcpy(ndev->dev_addr,
>> +                            (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
>>                       /* unaligned data acquisition */
>>                       memcpy(&tmp, (FLD_TYPE2 *) (hi->mfg_info.pft2.Id), 4);
>
> etc.
>
>
