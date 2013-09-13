Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3IMTyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:54:12 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:37203 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab3IMTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<20130910222924.GB13318@ZenIV.linux.org.uk>
	<20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
	<20130910223624.GC13318@ZenIV.linux.org.uk>
	<20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
	<20130910224823.GE13318@ZenIV.linux.org.uk>
	<20130910225934.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
	<CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
	<CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
	<CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
Date: Fri, 13 Sep 2013 12:54:09 -0700
X-Google-Sender-Auth: MNMyw9j6J_WtIyT01jNKEV4x8Ek
Message-ID: <CA+55aFyZLBkcUtMYNPXafPth+CdCc=L9D=XqG_51uTYxsgchLA@mail.gmail.com>
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

On Fri, Sep 13, 2013 at 12:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - d_lru_isolate: this is when the LRU callbacks ask us to remove the
> entry from the list. This is different from d_lru_del() only in that
> it uses the raw list removal, not the lru list helper function. I'm
> not sure that's right, but that's what the code used to do.

Yes, verified. The LRU isolation functions are called with the lru
list lock held, so d_lru_isolate() basically just does the
list)_del_init() and our own state management.

Anyway, I fixed a typo in a comment (nd_dentry_unused ->
nr_dentry_unused) but the patch still looks good to me.

                   Linus
