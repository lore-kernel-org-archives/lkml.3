Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaKMS4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:56:33 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62756 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaKMS4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:56:31 -0500
MIME-Version: 1.0
In-Reply-To: <CABuKBe+vRJUk1fB2mwUzGnnVcS-3N9U2uwgW1ZFwKBOe5sWf0Q@mail.gmail.com>
References: <1415816222-32200-1-git-send-email-wens@csie.org> <CABuKBe+vRJUk1fB2mwUzGnnVcS-3N9U2uwgW1ZFwKBOe5sWf0Q@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 14 Nov 2014 02:56:10 +0800
X-Google-Sender-Auth: BzgfZWjvr-YUmzQ00eCsSBNxBx4
Message-ID: <CAGb2v67MRg7C2_U_CWfGfcZWjn_1+k3tAwb=OU+Eo-0i8kBRnA@mail.gmail.com>
Subject: Re: [PATCH] of: pass name argument for of_io_request_and_map as const
 char *
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 5:04 PM, Matthias Brugger
<matthias.bgg@gmail.com> wrote:
> I already send a patch for that which got accepted by Grant [0].
> Although right now, I'm not able to find it on his repository [1].

Oh great! Please ignore this one then.

ChenYu

> Cheers,
> Matthias
>
> [0] https://lkml.org/lkml/2014/11/4/588
> [1] https://git.kernel.org/cgit/linux/kernel/git/glikely/linux.git/
>
> 2014-11-12 19:17 GMT+01:00 Chen-Yu Tsai <wens@csie.org>:
>> The name argument for of_io_request_and_map is only passed to
>> request_mem_region, which is a macro of __request_region, which
>> takes a const name argument.
>>
>> Make the name argument const, so when we pass const strings we
>> don't get the following warnings:
>>
>>     warning: passing argument 3 of 'of_io_request_and_map' discards
>>     'const' qualifier from pointer target type [enabled by default]
>>
>>     In file included from drivers/clk/sunxi/clk-sunxi.c:20:0:
>>     include/linux/of_address.h:108:15: note: expected 'char *' but
>>     argument is of type 'const char *'
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> Cc: Matthias Brugger <matthias.bgg@gmail.com>
>> ---
>>
>> I ran into this while switching some of the sunxi clock code to use
>> of_io_request_and_map.
>>
>> ---
>>  drivers/of/address.c       | 2 +-
>>  include/linux/of_address.h | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/of/address.c b/drivers/of/address.c
>> index afdb782..e02828f 100644
>> --- a/drivers/of/address.c
>> +++ b/drivers/of/address.c
>> @@ -871,7 +871,7 @@ EXPORT_SYMBOL(of_iomap);
>>   *             return PTR_ERR(base);
>>   */
>>  void __iomem *of_io_request_and_map(struct device_node *np, int index,
>> -                                       char *name)
>> +                                       const char *name)
>>  {
>>         struct resource res;
>>         void __iomem *mem;
>> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
>> index 8cb14eb..d88e81b 100644
>> --- a/include/linux/of_address.h
>> +++ b/include/linux/of_address.h
>> @@ -106,7 +106,7 @@ extern int of_address_to_resource(struct device_node *dev, int index,
>>                                   struct resource *r);
>>  void __iomem *of_iomap(struct device_node *node, int index);
>>  void __iomem *of_io_request_and_map(struct device_node *device,
>> -                                       int index, char *name);
>> +                                       int index, const char *name);
>>  #else
>>
>>  #include <linux/io.h>
>> @@ -123,7 +123,7 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
>>  }
>>
>>  static inline void __iomem *of_io_request_and_map(struct device_node *device,
>> -                                       int index, char *name)
>> +                                       int index, const char *name)
>>  {
>>         return IOMEM_ERR_PTR(-EINVAL);
>>  }
>> --
>> 2.1.3
>>
>
>
>
> --
> motzblog.wordpress.com
