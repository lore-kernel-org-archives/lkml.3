Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab3D3B3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:29:40 -0400
Received: from mx3.valvesoftware.com ([208.64.203.145]:46299 "EHLO
	mx3.valvesoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab3D3B3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:29:39 -0400
X-Greylist: delayed 1261 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 21:29:39 EDT
Message-ID: <517F190B.9000902@valvesoftware.com>
Date: Mon, 29 Apr 2013 18:06:19 -0700
From: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <sonnyrao@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com> <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com> <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com> <517F14D1.3070307@redhat.com>
In-Reply-To: <517F14D1.3070307@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: 86b76815-e903-4403-b95d-5abb05264373
X-Mlf-Version: 7.3.6.7163
X-Mlf-UniqueId: o201304300108350093028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 05:48 PM, Rik van Riel wrote:
> On 04/29/2013 06:03 PM, Linus Torvalds wrote:
>
>> Seriously, you can compile yourself a 64-bit kernel and continue to
>> use your 32-bit user-land. And you can complain to whatever distro you
>> used that it didn't do that in the first place. But we're not going to
>> bother with trying to tune PAE for some particular load. It's just not
>> worth it to anybody.
>
> I can think of one way to "tune PAE" that will help
> avoid the breakage, and at the same time draw the
> attention of users.
>
> Limit the memory that a 32 bit PAE kernel uses, to
> something small enough where the user will not
> encounter random breakage.  Maybe 8 or 12GB?
>
> It could also print out a friendly message, to
> inform the user they should upgrade to a 64 bit
> kernel to enjoy the use of all of their memory.
>
> It is a bit of a heavy stick, but I suspect that
> it would clue in all of the affected users.
>
> If you have no objection to this, I'll whip up a
> patch.
>

That would be pretty useful, especially if I can then convince 
distributors to apply it and roll it out ASAP. I haven't personally 
observed any problems with mem=15G whereas mem=16G exhibits the IO issue 
upfront and more than that exhibits the OOM-killer / low memory 
starvation issue that existed before Johannes change.

Thanks,
  - Pierre-Loup
