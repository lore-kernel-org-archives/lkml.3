Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbaJAA6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:58:12 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37099 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaJAA6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:58:10 -0400
Message-ID: <542B519B.6010001@landley.net>
Date: Tue, 30 Sep 2014 19:58:03 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: frowand.list@gmail.com, Andy Lutomirski <luto@amacapital.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net> <542B4DA3.5080105@gmail.com>
In-Reply-To: <542B4DA3.5080105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/14 19:41, Frank Rowand wrote:
> The earliest mention I find of this on lkml is v4.  Was there earlier
> discussion of this elsewhere?  (Just so I have a clue as to the full
> context and don't repeat previous discussion.)  The mention of names
> in the change logs tells me I should be able to find the discussion
> somewhere.

The previous ones had a different topic sentence (add strictinit). So
they added code to do less.

> On 9/28/2014 7:40 PM, Andy Lutomirski wrote:
>> If a user puts init=/whatever on the command line and /whatever
>> can't be run, then the kernel will try a few default options before
>> giving up.  If init=/whatever came from a bootloader prompt, then
>> this is unexpected but probably harmless.  On the other hand, if it
>> comes from a script (e.g. a tool like virtme or perhaps a future
>> kselftest script), then the fallbacks are likely to exist, but
>> they'll do the wrong thing.  For example, they might unexpectedly
>> invoke systemd.
>>
>> This makes a failure to run the specified init= process be fatal.
>>
>> As a temporary measure, users can set CONFIG_INIT_FALLBACK=y to
>> preserve the old behavior.  If no one speaks up, we can remove that
>> option entirely after a release or two.
> 
> I'm speaking up already, no need to wait two releases.  I like the
> current behavior where I can fall back into a shell without
> recompiling the kernel and/or changing the boot command line to
> debug an init failure.
> 
> I would suggest that the current behavior remain the
> default and the choice to make a failure of the specified
> init= process fatal should be an explicit choice.

Oh please no. Having to switch kernel configuration entries _on_ in
order to switch behavior _off_ is how you get nonsense like
allnoconfig_y which breaks miniconfig, why is why I patch it back out
locally:

http://landley.net/hg/aboriginal/file/1672/sources/patches/linux-deeplystupid.patch

If you're going to argue that it should "default y", that's a defensible
choice. But please don't argue for kernel config symbols with a negative
meaning or we'll start having allyesconfig_n brain damage too...

> Instead of using a config option, would adding another kernel
> command line option, such as 'init_fail_is_fatal', work for
> your needs?

That was the previous series of patches you ignored, which added code so
you can provide _extra_ kernel commands to tell it _not_ to do stuff.
The patches did not generate noticeable enthusiasm.

> I have a feeling this has already been proposed,
> as the 'strictinit' option mentioned in the changes from v3
> below might be the same concept?

That was it, yes.

Having to get your kernel config right (and your kernel command line
right) in order for your system to boot is not really a new concept, is
it? You can still specify "init=/bin/sh" if you want that. (I do it all
the time when I need to edit a system I haven't bothered to look up the
root password to.)

Rob
