Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3K2GRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 01:17:17 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64357 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3K2GRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 01:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75VcHa7cxAt_utwMVp7j+YeKcqa0_N5B=7-ZmTMD_6AV1Lw@mail.gmail.com>
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
	<CAHp75VcHa7cxAt_utwMVp7j+YeKcqa0_N5B=7-ZmTMD_6AV1Lw@mail.gmail.com>
Date: Fri, 29 Nov 2013 08:17:15 +0200
Message-ID: <CAHp75VcsYjj0_QKSeHFiFjrA92uZWdJPs5pLrzFK_HGM1ehUDw@mail.gmail.com>
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 28, 2013 at 10:46 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

One missed, but not least, thing.

>> +static struct gpiod_lookup_table *gpiod_find_lookup_table(struct device *dev)
>>  {
>>         const char *dev_id = dev ? dev_name(dev) : NULL;
>> -       struct gpio_desc *desc = ERR_PTR(-ENODEV);
>> -       unsigned int match, best = 0;
>> -       struct gpiod_lookup *p;
>> +       struct gpiod_lookup_table *table;
>>
>>         mutex_lock(&gpio_lookup_lock);
>>
>> -       list_for_each_entry(p, &gpio_lookup_list, list) {
>> -               match = 0;
>> +       list_for_each_entry(table, &gpio_lookup_list, list) {

[]

>> +               if (dev_id != table->dev_id)
>> +                       continue;
>>
>> -                       match += 2;
>> -               }
>> +               return table;
>
> What  about
>
> if (dev_id == table->dev_id)
>  return table;
>
> ?

And unlock mutex, of course! It seems you missed this in the first place.

>
>> +       }
>>
>> -               if (p->con_id) {
>> -                       if (!con_id || strcmp(p->con_id, con_id))
>> -                               continue;
>> +       mutex_unlock(&gpio_lookup_lock);
>>
>> -                       match += 1;
>> -               }
>> +       return NULL;
>> +}

-- 
With Best Regards,
Andy Shevchenko
