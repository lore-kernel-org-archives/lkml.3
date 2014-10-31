Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161401AbaJaAB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:01:56 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:47501 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161189AbaJaABz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
 <5452B241.5010603@amacapital.net> <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Oct 2014 17:01:30 -0700
Message-ID: <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Rannaud <e@nanocritical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 3:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Oct 30, 2014 at 3:48 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Agreed. Will apply and add the stable cc.
>
> Ho humm. Thinking about this some more, I'm starting to wonder. Not
> about this patch per se (open on a newly created file should indeed
> succeed regardless), but about the horrible glibc behavior of screwing
> up the third argument.
>
> If you want to do O_TMPFILE + linkat() (or some eventual future
> flink()), the mode really matters. So this idiotic glibc behavior of
> only forwarding the third argument if O_CREAT is set seems to be a
> bug.

We could bite the bullet and add a tmpfile syscall.   /me ducks

>
> Why the hell does glibc think it's a good idea to intersect system
> call semantics? It's not a good idea - it's just stupid in the
> extreme. And in this case it seems to actively breaks things.

Uh, because it's glibc?  Or because it's trying not to screw up and on
some system where overrunning va_arg is terrible?

>
>                      Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
