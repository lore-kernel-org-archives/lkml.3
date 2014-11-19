Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaKSQae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:30:34 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44789 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaKSQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:30:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJm9c+GozQssLmjuSLzcsqDiMW8=1P_fM6-Zfdk=N6Lqg@mail.gmail.com>
References: <1415342031.4925.27.camel@kernel.crashing.org> <3422452.OFUjscQXRB@wuerfel>
 <CAL_JsqKk5UdFEa02wA+3N5BCM7coWAK=4jAr96Pw5eFh2n0ioQ@mail.gmail.com>
 <11269246.iBzpsM0jDI@wuerfel> <CAL_JsqJm9c+GozQssLmjuSLzcsqDiMW8=1P_fM6-Zfdk=N6Lqg@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 19 Nov 2014 16:30:12 +0000
X-Google-Sender-Auth: 7vvb5zHRZCb3PWa_V9FP3xqmwZ0
Message-ID: <CACxGe6twb55zSfMhDpmtEFdTZVCVR0VZxNZbRhPwWD949LEuXQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from devices
 with an OF node
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@au1.ibm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 3:39 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Nov 19, 2014 at 8:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wednesday 19 November 2014 08:45:58 Rob Herring wrote:
>>> > static inline struct device_node *dev_of_node(struct device *of_node)
>>> > {
>>> >         if (!IS_ENABLED(CONFIG_OF))
>>> >                 return NULL;
>>> >
>>> >         return dev->of_node;
>>> > }
>>> >
>>> > Adding the IS_ENABLED() in a lot of drivers isn't horrible, but we seem
>>> > to be doing it a lot.
>>>
>>> I think you misread things. of_node is always present now, so it
>>> should always be NULL for !CONFIG_OF.
>>>
>>
>> No, I didn't misread it but I should have been clearer with the intention:
>> The idea is to tell the compiler that we know it will be NULL when CONFIG_OF
>> is unset, so it can optimize out all code that does
>>
>>         struct device_node *dn = dev_of_node(dev);
>>
>>         if (dn) {
>>                 ...
>>                 /* complex code */
>>                 ...
>>         }
>>
>> and we can avoid using an #ifdef or if(IS_ENABLED()) in the source to
>> compile out the DT-only sections of a driver.
>
> Oh, right. That would definitely be worthwhile to do.

Agreed.

g.
