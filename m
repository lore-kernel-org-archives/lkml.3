Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaKSPj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:39:59 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56190 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaKSPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <11269246.iBzpsM0jDI@wuerfel>
References: <1415342031.4925.27.camel@kernel.crashing.org> <3422452.OFUjscQXRB@wuerfel>
 <CAL_JsqKk5UdFEa02wA+3N5BCM7coWAK=4jAr96Pw5eFh2n0ioQ@mail.gmail.com> <11269246.iBzpsM0jDI@wuerfel>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 19 Nov 2014 09:39:36 -0600
Message-ID: <CAL_JsqJm9c+GozQssLmjuSLzcsqDiMW8=1P_fM6-Zfdk=N6Lqg@mail.gmail.com>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from devices
 with an OF node
To: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@au1.ibm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 8:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 19 November 2014 08:45:58 Rob Herring wrote:
>> > static inline struct device_node *dev_of_node(struct device *of_node)
>> > {
>> >         if (!IS_ENABLED(CONFIG_OF))
>> >                 return NULL;
>> >
>> >         return dev->of_node;
>> > }
>> >
>> > Adding the IS_ENABLED() in a lot of drivers isn't horrible, but we seem
>> > to be doing it a lot.
>>
>> I think you misread things. of_node is always present now, so it
>> should always be NULL for !CONFIG_OF.
>>
>
> No, I didn't misread it but I should have been clearer with the intention:
> The idea is to tell the compiler that we know it will be NULL when CONFIG_OF
> is unset, so it can optimize out all code that does
>
>         struct device_node *dn = dev_of_node(dev);
>
>         if (dn) {
>                 ...
>                 /* complex code */
>                 ...
>         }
>
> and we can avoid using an #ifdef or if(IS_ENABLED()) in the source to
> compile out the DT-only sections of a driver.

Oh, right. That would definitely be worthwhile to do.

Rob
