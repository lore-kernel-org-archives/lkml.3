Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3IQW1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:27:52 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40160 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3IQW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <87ob7x37p6.fsf@rustcorp.com.au>
References: <20130724071757.GA30970@gondor.apana.org.au> <87siz38q2t.fsf@rustcorp.com.au>
 <20130725020329.GA14625@gondor.apana.org.au> <CAKi4VA+=1vOOt0BqdQHQaeF1hP3DrRtCL_ObXY0cPeO7S_MtYw@mail.gmail.com>
 <87ob7x37p6.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 17 Sep 2013 19:27:28 -0300
Message-ID: <CAKi4VALAu0ek6tYhb_Ls34hNU1Omjhv=QJDaACAp_0gpRy98HA@mail.gmail.com>
Subject: Re: [PATCH] modules: add support for soft module dependencies
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Andreas Robinson <andr345@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        David Miller <davem@davemloft.net>, tim.c.chen@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        linux-modules <linux-modules@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 9:07 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>> On Wed, Jul 24, 2013 at 11:03 PM, Herbert Xu
>> <herbert@gondor.apana.org.au> wrote:
>>> On Thu, Jul 25, 2013 at 09:32:02AM +0930, Rusty Russell wrote:
>>>> Herbert Xu <herbert@gondor.apana.org.au> writes:
>>>> > Hi Rusty:
>>>> >
>>>> > I don't know why this patch never went into the kernel, even
>>>> > though the corresponding features have been added to modprobe
>>>> > in most if not all distros.
>>>>
>>>> Because Andreas never sent me the patch?  This is the first I've *heard*
>>>> of this feature.  Looks like it didn't hit lkml either.  And what was
>>>> 2/2?
>>>
>>> 2/2 was the patch to actually use this in crc32c.
>>>
>>>> It's not how I would have done this: post-deps are more flexibly done at
>>>> runtime, because the module may have to do work to figure out what to
>>>> pull in.  But since it already exists, I'll apply this patch: it doesn't
>>>> cost the kernel anything.
>>
>> But it did cause boot failures. The file modules.softdep file was
>> supposed to be informational until now. That's why depmod put a
>> comment saying to "copy on user's discretion to /etc/modules.d"
>> instead of parsing it directly.
>
> I'm happy to change this macro to create a modinfo line like
> "softdep:<modname>"

how is that solving the issue that this macro can be used to designate
a mandatory or optional dependency
(https://lkml.org/lkml/2013/9/10/371)? If we decide the dependency is
mandatory we can very well let modprobe use that dependency during
module load

>
> ie. tools like mkinitrd could pick it up and try to find a matching
> module, but depmod would ignore it.

Some mkinitrd-like use whatever depmod/modprobe tells them it's
needed. So kmod still needs to know about it.


>
> It's really up to Lucas, since this affects him.

IMO  saying "this is an optional dependency and we can work without"
doesn't buy us much. Distros will end up putting the soft dep in
/etc/modules.d, kmod will always use them anyway and failing to load
the soft dep will fail the module load. I'd like to have no distro
files in /etc/modules.d in future.


Lucas De Marchi
