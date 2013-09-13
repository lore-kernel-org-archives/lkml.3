Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3IMUej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:34:39 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:64336 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3IMUeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130913203149.GW13318@ZenIV.linux.org.uk>
References: <20130910223624.GC13318@ZenIV.linux.org.uk>
	<20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
	<20130910224823.GE13318@ZenIV.linux.org.uk>
	<20130910225934.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
	<CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
	<CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
	<CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
	<20130913200000.GT13318@ZenIV.linux.org.uk>
	<CA+55aFxizbVmQE2Y94BRj3kDFdf6hzNHuy-O0qBFw3jnT_mMLw@mail.gmail.com>
	<20130913203149.GW13318@ZenIV.linux.org.uk>
Date: Fri, 13 Sep 2013 16:34:37 -0400
X-Google-Sender-Auth: 52wTdrLFxjcS1-zNL88twi4Y2zk
Message-ID: <CA+55aFyOzHB=WAqzrSoyF=94dO7OYgc3nm0hW00c+TWq7TvOJA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 4:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 13, 2013 at 04:25:48PM -0400, Linus Torvalds wrote:
>>
>> Yes. And I found the opposite bug in one place: when we are collecting
>> dentries by walking the parents etc, we do *not* hold the global RCU
>> lock,
>
> ???  LRU list lock, presumably?

Heh, yes. You wouldn't believe how many times I mis-typed "lru" as
"rcu" while doing that patch.

Much of the other dentry work this merge window was all about rcu, so
my fingers end up being confused..

         Linus
