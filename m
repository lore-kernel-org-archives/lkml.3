Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3EBEiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 00:38:05 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:51627 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3EBEhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 00:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <517EEF72.5090100@valvesoftware.com>
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com>
 <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com>
 <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com> <517EEF72.5090100@valvesoftware.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 1 May 2013 21:37:27 -0700
X-Google-Sender-Auth: 9mt0XD1kFuAIqnh_mh0B1Pgfd-A
Message-ID: <CAPz6YkXqxNNvXcjRv1APbUoreLofSGAxM5XKz-F8fz_SCV0egw@mail.gmail.com>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
To: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 3:08 PM, Pierre-Loup A. Griffais
<pgriffais@valvesoftware.com> wrote:
> On 04/29/2013 03:03 PM, Linus Torvalds wrote:
>>
>> On Mon, Apr 29, 2013 at 2:53 PM, Pierre-Loup A. Griffais
>> <pgriffais@valvesoftware.com> wrote:
>>>
>>>
>>> Other than this particular concern, what's the high-level take-away? Is
>>> PAE
>>> support in the Linux kernel a false promise than distros should not be
>>> shipping by default, if at all? Should it be removed from the kernel
>>> entirely if these configurations are knowingly broken by commits like
>>> this?
>>
>>
>> PAE is "make it barely work". The whole concept is fundamentally
>> flawed, and anybody who runs a 32-bit kernel with 16GB or RAM doesn't
>> even understand *how* flawed and stupid that is.
>>
>> Don't do it. Upgrade to 64-bit, or live with the fact that IO
>> performance will suck. The fact that it happened to work better under
>> your particular load with one particular IO size is entirely just
>> "random noise".
>>
>> Yeah, the difference between "we can cache it" and "we have to do IO"
>> is huge. With a 32-bit kernel, we do IO much earlier now, just to
>> avoid some really nasty situations. That makes you go from the "can
>> sit in the cache" to the "do lots of IO" situation. Tough.
>>
>> Seriously, you can compile yourself a 64-bit kernel and continue to
>> use your 32-bit user-land. And you can complain to whatever distro you
>> used that it didn't do that in the first place. But we're not going to
>> bother with trying to tune PAE for some particular load. It's just not
>> worth it to anybody.
>
>
> All of this came from me trying to reproduce slowdowns reported by other
> people; I personally run a 64-bit kernel and understand how bad of an idea
> it is to attempt to run 32-bit kernels with PAE enabled on modern machines.
> However, my goal is to avoid ending up with a variety of end-users that
> don't necessarily understand this getting bitten by it and breaking their
> systems by upgrading their kernels. I will indeed bring this up with
> distributors and point out than shipping PAE kernels by default is not a
> good idea given these problems and your stance on the matter.
>

Sorry just saw this (my stupid gmail filters for lkml) The slow-down
we ran into wasn't even on PAE -- it was *just* with highmem on a 2GB
system.  The non-zero amount (90MB? or so) of highmem was enough to
cause major problems due to that particular underflow.

I would say regardless of how much memory you have, if the system can
use a 64-bit kernel, then it almost certainly should.  I've seen some
very minor performance impacts on 64-bit capable Atom systems with
tiny L2 caches, but it's almost in the noise and not worth the pain.

> Thanks,
>  - Pierre-Loup
>
>>
>>                  Linus
>>
>
