Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaKSOqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:46:21 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63323 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKSOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <3422452.OFUjscQXRB@wuerfel>
References: <1415342031.4925.27.camel@kernel.crashing.org> <546BD8BD.2010605@au1.ibm.com>
 <1416364544.5704.23.camel@kernel.crashing.org> <3422452.OFUjscQXRB@wuerfel>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 19 Nov 2014 08:45:58 -0600
Message-ID: <CAL_JsqKk5UdFEa02wA+3N5BCM7coWAK=4jAr96Pw5eFh2n0ioQ@mail.gmail.com>
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

On Wed, Nov 19, 2014 at 2:38 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 19 November 2014 13:35:44 Benjamin Herrenschmidt wrote:
>> On Wed, 2014-11-19 at 10:39 +1100, Jeremy Kerr wrote:
>> > Hi Rob,
>> >
>> > >> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> > >> index 20da3ad..8c7b607 100644
>> > >> --- a/drivers/base/core.c
>> > >> +++ b/drivers/base/core.c
>> > >> @@ -493,6 +493,15 @@ static int device_add_attrs(struct device *dev)
>> > >>                         goto err_remove_dev_groups;
>> > >>         }
>> > >>
>> > >> +#ifdef CONFIG_OF
>> > >> +       if (dev->of_node) {
>> > >
>> > > if (IS_ENABLED(CONFIG_OF) && dev->of_node)
>> >
>> > struct device doesn't have an of_node member if !CONFIG_OF, so we'll
>> > need to disable this block in the preprocessor.
>>
>> Actually that's no longer the case since 2.6.39 afaik
>
> I wonder if we should create a small helper for this, like
>
> static inline struct device_node *dev_of_node(struct device *of_node)
> {
>         if (!IS_ENABLED(CONFIG_OF))
>                 return NULL;
>
>         return dev->of_node;
> }
>
> Adding the IS_ENABLED() in a lot of drivers isn't horrible, but we seem
> to be doing it a lot.

I think you misread things. of_node is always present now, so it
should always be NULL for !CONFIG_OF.

Rob
