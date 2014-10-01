Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaJAEyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:54:19 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:36249 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJAEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:54:18 -0400
MIME-Version: 1.0
In-Reply-To: <542B7200.6030902@landley.net>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
 <542B4DA3.5080105@gmail.com> <542B519B.6010001@landley.net>
 <542B5E44.40303@gmail.com> <542B7200.6030902@landley.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Sep 2014 21:53:56 -0700
Message-ID: <CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
To: Rob Landley <rob@landley.net>
Cc: frowand.list@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 8:16 PM, Rob Landley <rob@landley.net> wrote:
> On 09/30/14 20:52, Frank Rowand wrote:
>> On 9/30/2014 5:58 PM, Rob Landley wrote:
>>> If you're going to argue that it should "default y", that's a defensible
>>> choice. But please don't argue for kernel config symbols with a negative
>>> meaning or we'll start having allyesconfig_n brain damage too...
>>
>> Yes, "default y" is a valid answer to my request.
>
> Works for me.
>
>>>> Instead of using a config option, would adding another kernel
>>>> command line option, such as 'init_fail_is_fatal', work for
>>>> your needs?
>>>
>>> That was the previous series of patches you ignored, which added code so
>>> you can provide _extra_ kernel commands to tell it _not_ to do stuff.
>>> The patches did not generate noticeable enthusiasm.
>>
>> But there also was not a strong push back either.  Just Chuck's suggestion
>> of an alternate syntax, and your suggestion of instead using a config
>> option (and possibly immediately deprecating the config option).
>>
>> You could as easily frame the argument that the added code was to
>> tell the kernel to "_do_ stuff" (panic) instead of "_not_ do stuff".
>> But that is just semantics on my part; whatever.
>>
>> I thought the general trend was to try to avoid adding config options.
>> The strictinit method seems fine to me.
>
> Embedded guys care:
>
> http://elinux.org/Linux_Tiny
>
> http://lkml.iu.edu//hypermail/linux/kernel/1409.2/03763.html
>
>>>> I have a feeling this has already been proposed,
>>>> as the 'strictinit' option mentioned in the changes from v3
>>>> below might be the same concept?
>>>
>>> That was it, yes.
>>>
>>> Having to get your kernel config right (and your kernel command line
>>> right) in order for your system to boot is not really a new concept, is
>>> it? You can still specify "init=/bin/sh" if you want that. (I do it all
>>> the time when I need to edit a system I haven't bothered to look up the
>>> root password to.)
>>
>> Yes, of course I can.  So it falls back to personal preference (as I said,
>> I like that some failed boots will drop into a shell without having to
>> change the kernel command line).
>
> The config option lets it do that. Default Y preserves the old behavior.

I significantly prefer default N.  Scripts that play with init= really
don't want the fallback, and I can imagine contexts in which it could
be a security problem.

--Andy
