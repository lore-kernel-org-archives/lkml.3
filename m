Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaA2LIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:08:22 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:57683 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2LIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:08:20 -0500
MIME-Version: 1.0
In-Reply-To: <1390969124.11756.43.camel@joe-AO722>
References: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
	<1390968181-31800-2-git-send-email-badarkhe.manish@gmail.com>
	<1390969124.11756.43.camel@joe-AO722>
Date: Wed, 29 Jan 2014 16:38:20 +0530
Message-ID: <CAKDJKT7ZpH89k6a4yfbBt+dpQ3oM9Khe42VwFmEjKqmu55jNzw@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] devres: introduce API "devm_kstrdup"
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thank you for your review.

On Wed, Jan 29, 2014 at 9:48 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-01-29 at 09:33 +0530, Manish Badarkhe wrote:
>> This patch introduces "devm_kstrdup" API so that the
>> device's driver can allocate memory and copy string.
> []
>> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> []
>> @@ -791,6 +791,32 @@ void * devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
>>  EXPORT_SYMBOL_GPL(devm_kmalloc);
>>
>>  /**
>> + * devm_kstrdup - Allocate resource managed space and
>> + *                and copy an existing string
>> + * @dev: Device to allocate memory for
>> + * @s: the string to duplicate
>> + * @size: Allocation size
>
> Why is size necessary at all?
> I think it should be calculated by strlen

I thought of avoiding string length calculation in function.
But,yes its better to do it in function to avoid extra parsing
of argument to function.Will update code and
post a patch.

>> +char *devm_kstrdup(struct device *dev,
>> +                const char *s, size_t size, gfp_t gfp)
>> +{
>> +     char *buf;
>> +
>> +     if (!s)
>> +             return NULL;
>> +
>> +     buf = devm_kzalloc(dev, size, gfp);
>
> If this is really necessary, please use devm_kmalloc

devm_kzalloc is always better giving zeroed memory locations.
Is there any reason not to go for it?

Regards
Manish Badarkhe
