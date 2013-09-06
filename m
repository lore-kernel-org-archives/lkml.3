Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab3IFCBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 22:01:50 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35920 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3IFCBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 22:01:49 -0400
Message-ID: <5229377E.5050805@hp.com>
Date: Thu, 05 Sep 2013 22:01:34 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com> <1378407316-59852-2-git-send-email-Waiman.Long@hp.com> <CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com> <5228E992.5050901@hp.com> <CA+55aFzx4YHY3e5AH0U5AkAQSc8pZyC35jBP4t2jpbi8NHM18g@mail.gmail.com>
In-Reply-To: <CA+55aFzx4YHY3e5AH0U5AkAQSc8pZyC35jBP4t2jpbi8NHM18g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 04:42 PM, Linus Torvalds wrote:
> On Thu, Sep 5, 2013 at 1:29 PM, Waiman Long<waiman.long@hp.com>  wrote:
>> It is not as simple as doing a strncpy().
> Yes it damn well is.
>
> Stop the f*cking stupid arguments, and instead listen to what I say.
>
> Here. Let me bold-face the most important part for you, so that you
> don't miss it in all the other crap:
>
>     MAKE prepend() JUST USE "strncpy()" INSTEAD OF "memcpy()".
>
> Nothing else. Seriously. Your "you can't do it because we copy
> backwards" arguments are pure and utter garbage, exactly BECAUSE YOU
> DON'T CHANGE ANY OF THAT. You can actually use the unreliable length
> variable BUT YOU MUST STILL STOP AT A ZERO.
>
> Get it?
>
> You're complicating the whole thing for no good reason. I'm telling
> you (and HAVE BEEN telling you multiple times) that you cannot use
> "memcpy()" because the length may not be reliable, so you need to
> check for zero in the middle and stop early. All your arguments have
> been totally pointless, because you don't seem to see that simple and
> fundamental issue. You don't change ANYTHING else. But you damn well
> not do a "memcpy", you do something that stops when it hits a NUL
> character.
>
> We call that function "strncpy()". I'd actually prefer to write it out
> by hand (because somebody could implement "strncpy()" as a
> questionable function that accesses past the NUL as long as it's
> within the 'n'), and because I think we might want to do that
> word-at-a-time version of it, but for a first approximation, just do
> that one-liner version.
>
> Don't do anything else. Don't do locking. Don't do memchr. Just make
> sure that you stop at a NUL character, and don't trust the length,
> because the length may not match the pointer. That's was always ALL
> you needed to do.
>
>                Linus
I am sorry that I misunderstand what you said. I will do what you and Al 
advise me to do.

-Longman
