Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3ILRgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:36:23 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33989 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3ILRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:36:19 -0400
Message-ID: <5231FB85.7070206@hp.com>
Date: Thu, 12 Sep 2013 13:36:05 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in read_seqbegin_or_lock()
 & friend
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com> <CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
In-Reply-To: <CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:38 PM, Linus Torvalds wrote:
> On Thu, Sep 12, 2013 at 7:55 AM, Waiman Long<Waiman.Long@hp.com>  wrote:
>> Change log
>> ----------
>> v1->v2:
>>    - Rename the new seqlock primitives to read_seqexcl_lock* and
>>      read_seqexcl_unlock*.
> Applied. Except I peed in the snow and renamed the functions
> again.That whole "seqexcl" looked too odd to me. It not only looks a
> bit too much like random noise, but it makes it seem a whole different
> lock from the "seqlock" thing.
>
> I wanted to pattern the name after "write_seq[un]lock()", since it
> most resembles that (not just in implementation, but in usage: the
> traditional read-sequence isn't a lock, it's a begin/retry sequence,
> so the usage pattern is totally different too, and the naming is
> different).
>
> I ended up picking "read_seq[un]lock_excl()". I could have gone with
> "excl_" as a prefix too, I guess. Whatever. Now the "_excl" thing
> looks a bit like the "_bh"/"_irqX" context modifier, and I think it
> matches our normal lock naming pattern better.
>
>              Linus

I think your new names are better than mine. I am not good at naming 
stuff. Thank for the merge and the rename.

-Longman
