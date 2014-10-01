Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaJABwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 21:52:10 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51829 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJABwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 21:52:08 -0400
Message-ID: <542B5E44.40303@gmail.com>
Date: Tue, 30 Sep 2014 18:52:04 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net> <542B4DA3.5080105@gmail.com> <542B519B.6010001@landley.net>
In-Reply-To: <542B519B.6010001@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/2014 5:58 PM, Rob Landley wrote:
> On 09/30/14 19:41, Frank Rowand wrote:
>> The earliest mention I find of this on lkml is v4.  Was there earlier
>> discussion of this elsewhere?  (Just so I have a clue as to the full
>> context and don't repeat previous discussion.)  The mention of names
>> in the change logs tells me I should be able to find the discussion
>> somewhere.
> 
> The previous ones had a different topic sentence (add strictinit). So
> they added code to do less.

Thanks!  That gives me the context I was looking for.

For posterity and anyone searching in the future, the previous
threads were:

   [PATCH ...] init: Add strictinit to disable init= fallbacks

> 
>> On 9/28/2014 7:40 PM, Andy Lutomirski wrote:
>>> If a user puts init=/whatever on the command line and /whatever
>>> can't be run, then the kernel will try a few default options before
>>> giving up.  If init=/whatever came from a bootloader prompt, then
>>> this is unexpected but probably harmless.  On the other hand, if it
>>> comes from a script (e.g. a tool like virtme or perhaps a future
>>> kselftest script), then the fallbacks are likely to exist, but
>>> they'll do the wrong thing.  For example, they might unexpectedly
>>> invoke systemd.
>>>
>>> This makes a failure to run the specified init= process be fatal.
>>>
>>> As a temporary measure, users can set CONFIG_INIT_FALLBACK=y to
>>> preserve the old behavior.  If no one speaks up, we can remove that
>>> option entirely after a release or two.
>>
>> I'm speaking up already, no need to wait two releases.  I like the
>> current behavior where I can fall back into a shell without
>> recompiling the kernel and/or changing the boot command line to
>> debug an init failure.
>>
>> I would suggest that the current behavior remain the
>> default and the choice to make a failure of the specified
>> init= process fatal should be an explicit choice.
> 
> Oh please no. Having to switch kernel configuration entries _on_ in
> order to switch behavior _off_ is how you get nonsense like
> allnoconfig_y which breaks miniconfig, why is why I patch it back out
> locally:
> 
> http://landley.net/hg/aboriginal/file/1672/sources/patches/linux-deeplystupid.patch
> 
> If you're going to argue that it should "default y", that's a defensible
> choice. But please don't argue for kernel config symbols with a negative
> meaning or we'll start having allyesconfig_n brain damage too...

Yes, "default y" is a valid answer to my request.

> 
>> Instead of using a config option, would adding another kernel
>> command line option, such as 'init_fail_is_fatal', work for
>> your needs?
> 
> That was the previous series of patches you ignored, which added code so
> you can provide _extra_ kernel commands to tell it _not_ to do stuff.
> The patches did not generate noticeable enthusiasm.

But there also was not a strong push back either.  Just Chuck's suggestion
of an alternate syntax, and your suggestion of instead using a config
option (and possibly immediately deprecating the config option).

You could as easily frame the argument that the added code was to
tell the kernel to "_do_ stuff" (panic) instead of "_not_ do stuff".
But that is just semantics on my part; whatever.

I thought the general trend was to try to avoid adding config options.
The strictinit method seems fine to me.


>> I have a feeling this has already been proposed,
>> as the 'strictinit' option mentioned in the changes from v3
>> below might be the same concept?
> 
> That was it, yes.
> 
> Having to get your kernel config right (and your kernel command line
> right) in order for your system to boot is not really a new concept, is
> it? You can still specify "init=/bin/sh" if you want that. (I do it all
> the time when I need to edit a system I haven't bothered to look up the
> root password to.)

Yes, of course I can.  So it falls back to personal preference (as I said,
I like that some failed boots will drop into a shell without having to
change the kernel command line).

-Frank

