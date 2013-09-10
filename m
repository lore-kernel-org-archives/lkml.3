Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3IJOCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:02:02 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46090 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IJOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:01:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130725020329.GA14625@gondor.apana.org.au>
References: <20130724071757.GA30970@gondor.apana.org.au> <87siz38q2t.fsf@rustcorp.com.au>
 <20130725020329.GA14625@gondor.apana.org.au>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 10 Sep 2013 11:01:38 -0300
Message-ID: <CAKi4VA+=1vOOt0BqdQHQaeF1hP3DrRtCL_ObXY0cPeO7S_MtYw@mail.gmail.com>
Subject: Re: [PATCH] modules: add support for soft module dependencies
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
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

On Wed, Jul 24, 2013 at 11:03 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Thu, Jul 25, 2013 at 09:32:02AM +0930, Rusty Russell wrote:
>> Herbert Xu <herbert@gondor.apana.org.au> writes:
>> > Hi Rusty:
>> >
>> > I don't know why this patch never went into the kernel, even
>> > though the corresponding features have been added to modprobe
>> > in most if not all distros.
>>
>> Because Andreas never sent me the patch?  This is the first I've *heard*
>> of this feature.  Looks like it didn't hit lkml either.  And what was
>> 2/2?
>
> 2/2 was the patch to actually use this in crc32c.
>
>> It's not how I would have done this: post-deps are more flexibly done at
>> runtime, because the module may have to do work to figure out what to
>> pull in.  But since it already exists, I'll apply this patch: it doesn't
>> cost the kernel anything.

But it did cause boot failures. The file modules.softdep file was
supposed to be informational until now. That's why depmod put a
comment saying to "copy on user's discretion to /etc/modules.d"
instead of parsing it directly.

If dependencies expressed with softdeps can be required dependencies
now, depmod needs to be updated to work it out otherwise we will get
missing dependencies as happened with the crypto stuff after this
patch. I'm CC'ing Tom who had the boot failure; it looks like the same
boot failure that caused this feature to get reverted the first time
(the deps being required by sd_mod).

Even if it is an optional module, it would be great to have depmod
updated so it parses the file directly now that we are exporting this
info. I can do that once we agree what we want to do with softdeps
coming directly from kernel itself.

However looking at the only user right now, crct10dif: couldn't we
detect at runtime if this module can be used instead of just trying to
load it as a pre softdep and possibly failing?


Lucas De Marchi
