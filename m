Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaCUEgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 00:36:33 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34021 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaCUEgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 00:36:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140321042737.GA4439@kroah.com>
References: <1983239.9vdN5jE4dT@daeseok-laptop.cloud.net>
	<20140321042737.GA4439@kroah.com>
Date: Fri, 21 Mar 2014 13:36:31 +0900
Message-ID: <CAHb8M2DKZP9+Xs-OP_MnaTCKgmNPXAxrYs3GwO55NcsHdyTWzA@mail.gmail.com>
Subject: Re: [PATCH v2] staging: cxt1e1: replace OS_kmalloc/OS_kfree with kmalloc/kfree
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: nandini h <nandu.hgowda@gmail.com>, devel <devel@driverdev.osuosl.org>,
        Shaun Laing <shaun@xresource.ca>,
        =?UTF-8?B?R8O8bMWfYWggS8O2c2U=?= <gulsah.1004@gmail.com>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        peter.p.waskiewicz.jr@intel.com,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Himangi Saraogi <himangi774@gmail.com>, viro <viro@zeniv.linux.org.uk>,
        Joe Perches <joe@perches.com>, Chekameh Cobbler <fempsci@gmail.com>,
        Trac Notifications <speiro@ai2.upv.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-21 13:27 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Fri, Mar 21, 2014 at 01:15:23PM +0900, Daeseok Youn wrote:
>>
>> Replace OS_kmalloc/OS_kfree with kmalloc/kfree.
>
> You should replace it with kzalloc, not kmalloc, as OS_kmalloc() zeroed
> out the allocated data:

I think some case does not need to get zeroed memory. :-)
I will change that and send it again.

Thanks for review.
Daeseok Youn.

>
>
>> -static inline void *
>> -OS_kmalloc (size_t size)
>> -{
>> -    char       *ptr = kmalloc (size, GFP_KERNEL | GFP_DMA);
>> -
>> -    if (ptr)
>> -        memset (ptr, 0, size);
>> -    return ptr;
>> -}
>
> greg k-h
