Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbaDWOFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:05:13 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58610 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbaDWOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:05:09 -0400
MIME-Version: 1.0
In-Reply-To: <5357C4BE.3050606@monstr.eu>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
	<1398215901-25609-19-git-send-email-robherring2@gmail.com>
	<5357C4BE.3050606@monstr.eu>
Date: Wed, 23 Apr 2014 09:05:07 -0500
Message-ID: <CAL_JsqKg8oAd+JmmhERa3Xb1dD9CPz1_cVM3mb=ypWhxkZJHtQ@mail.gmail.com>
Subject: Re: [PATCH v2 18/21] powerpc: use libfdt accessors for header data
From: Rob Herring <robherring2@gmail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 8:48 AM, Michal Simek <monstr@monstr.eu> wrote:
> On 04/23/2014 03:18 AM, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> With libfdt support, we can take advantage of helper accessors in libfdt
>> for accessing the FDT header data. This makes the code more readable and
>> makes the FDT blob structure more opaque to the kernel. This also
>> prepares for removing struct boot_param_header completely.

[...]

>> @@ -117,14 +118,14 @@ static void __init move_device_tree(void)
>>       DBG("-> move_device_tree\n");
>>
>>       start = __pa(initial_boot_params);
>> -     size = be32_to_cpu(initial_boot_params->totalsize);
>> +     size = fdt_totalsize(initial_boot_params);
>
> In 19/21 you use your newly introduced of_get_flat_dt_size()
> that's why I expect you will use it here too.
> size = of_get_flat_dt_size();
>
> The same is for 14/21 where you can use this new function too.
> It means moving 14/21 to the end and using this new function
> makes more sense.

Really, I would prefer to just use libfdt accessors directly rather
than have wrappers, but including libfdt.h is not the cleanest
solution. Since x86 just needed this one function, I added a wrapper.
Since PPC needs other header fields I prefer to use the libfdt
accessors directly for all fields. The same goes for drivers/of/fdt.c.

Rob
