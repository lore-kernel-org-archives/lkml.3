Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbaGOKCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:02:05 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:51937 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbaGOKCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <5098448.1h12jNJ4cv@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-19-git-send-email-lftan@altera.com>
	<5098448.1h12jNJ4cv@wuerfel>
Date: Tue, 15 Jul 2014 18:02:01 +0800
X-Google-Sender-Auth: eHzxXptKrBedHD1YC5PL5ObUKqs
Message-ID: <CAFiDJ59ip=m-6hUOukYaWGNc+id06BwBq-imAzqn+RTpZ6vvEw@mail.gmail.com>
Subject: Re: [PATCH v2 18/29] nios2: Device tree support
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 July 2014 16:45:45 Ley Foon Tan wrote:
>> +static struct of_device_id altera_of_bus_ids[] __initdata = {
>> +       { .compatible = "simple-bus", },
>> +       { .compatible = "altr,avalon", },
>> +       {}
>> +};
>
> Can you change the avalon bus nodes to be compatible to with "simple-bus"
> as well, so you can use the default id list?
Yes, it is compatible with both "altr,avalon" and "simple-bus". We can
change it to default id list.

compatible = "altr,avalon", "simple-bus";

>
>> +static int __init nios2_soc_device_init(void)
>> +{
>> +       struct soc_device *soc_dev;
>> +       struct soc_device_attribute *soc_dev_attr;
>> +       const char *machine;
>> +
>> +       soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
>> +       if (soc_dev_attr) {
>> +               machine = of_flat_dt_get_machine_name();
>> +               if (machine)
>> +                       soc_dev_attr->machine = kasprintf(GFP_KERNEL, "%s",
>> +                                               machine);
>> +
>> +               soc_dev_attr->family = "Nios II";
>> +
>> +               soc_dev = soc_device_register(soc_dev_attr);
>> +               if (IS_ERR(soc_dev)) {
>> +                       kfree(soc_dev_attr->machine);
>> +                       kfree(soc_dev_attr);
>> +               }
>> +       }
>> +
>> +       return of_platform_bus_probe(NULL, altera_of_bus_ids, NULL);
>> +}
>> +
>> +device_initcall(nios2_soc_device_init);
>>
> I think you should use of_platform_populate instead of of_platform_bus_probe
> here.

Okay, will change to of_platform_populate().

Regards
Ley Foon
