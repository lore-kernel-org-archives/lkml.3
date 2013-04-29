Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144Ab3D2WQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:16:43 -0400
Received: from mx3.valvesoftware.com ([208.64.203.145]:35194 "EHLO
	mx3.valvesoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab3D2WQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:16:41 -0400
Message-ID: <517EEF72.5090100@valvesoftware.com>
Date: Mon, 29 Apr 2013 15:08:50 -0700
From: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <sonnyrao@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com> <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com> <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
In-Reply-To: <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: 86b76815-e903-4403-b95d-5abb05264373
X-Mlf-Version: 7.3.6.7163
X-Mlf-UniqueId: o201304292211060086769
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 03:03 PM, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 2:53 PM, Pierre-Loup A. Griffais
> <pgriffais@valvesoftware.com> wrote:
>>
>> Other than this particular concern, what's the high-level take-away? Is PAE
>> support in the Linux kernel a false promise than distros should not be
>> shipping by default, if at all? Should it be removed from the kernel
>> entirely if these configurations are knowingly broken by commits like this?
>
> PAE is "make it barely work". The whole concept is fundamentally
> flawed, and anybody who runs a 32-bit kernel with 16GB or RAM doesn't
> even understand *how* flawed and stupid that is.
>
> Don't do it. Upgrade to 64-bit, or live with the fact that IO
> performance will suck. The fact that it happened to work better under
> your particular load with one particular IO size is entirely just
> "random noise".
>
> Yeah, the difference between "we can cache it" and "we have to do IO"
> is huge. With a 32-bit kernel, we do IO much earlier now, just to
> avoid some really nasty situations. That makes you go from the "can
> sit in the cache" to the "do lots of IO" situation. Tough.
>
> Seriously, you can compile yourself a 64-bit kernel and continue to
> use your 32-bit user-land. And you can complain to whatever distro you
> used that it didn't do that in the first place. But we're not going to
> bother with trying to tune PAE for some particular load. It's just not
> worth it to anybody.

All of this came from me trying to reproduce slowdowns reported by other 
people; I personally run a 64-bit kernel and understand how bad of an 
idea it is to attempt to run 32-bit kernels with PAE enabled on modern 
machines. However, my goal is to avoid ending up with a variety of 
end-users that don't necessarily understand this getting bitten by it 
and breaking their systems by upgrading their kernels. I will indeed 
bring this up with distributors and point out than shipping PAE kernels 
by default is not a good idea given these problems and your stance on 
the matter.

Thanks,
  - Pierre-Loup

>
>                  Linus
>

