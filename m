Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaKRXjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:39:52 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33583 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbaKRXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:39:49 -0500
Message-ID: <546BD8BD.2010605@au1.ibm.com>
Date: Wed, 19 Nov 2014 10:39:41 +1100
From: Jeremy Kerr <jeremy.kerr@au1.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from devices
 with an OF node
References: <1415342031.4925.27.camel@kernel.crashing.org> <1415342117.4925.29.camel@kernel.crashing.org> <1415596626.5769.14.camel@kernel.crashing.org> <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com> <1415841047.5124.62.camel@kernel.crashing.org> <CAL_Jsq+YyfMWxiOFv4x3g5hZJH0XRqCKj2He1XO9eyXWjHTMrg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+YyfMWxiOFv4x3g5hZJH0XRqCKj2He1XO9eyXWjHTMrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111823-0029-0000-0000-0000009FBAA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 20da3ad..8c7b607 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -493,6 +493,15 @@ static int device_add_attrs(struct device *dev)
>>                         goto err_remove_dev_groups;
>>         }
>>
>> +#ifdef CONFIG_OF
>> +       if (dev->of_node) {
> 
> if (IS_ENABLED(CONFIG_OF) && dev->of_node)

struct device doesn't have an of_node member if !CONFIG_OF, so we'll
need to disable this block in the preprocessor.

Cheers,


Jeremy

