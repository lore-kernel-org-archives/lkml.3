Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3CLSbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:31:11 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:56407 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534Ab3CLSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130310230442.GB21522@ZenIV.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
	<20130307153052.GA18246@redhat.com>
	<20130310230442.GB21522@ZenIV.linux.org.uk>
Date: Tue, 12 Mar 2013 11:31:08 -0700
X-Google-Sender-Auth: m3o4BFYwUjjOaFW8393gcFeJaIc
Message-ID: <CA+55aFyLhuQ_agP3rBy0DxSx+RwOaDN3VxBPgi9ZDAc74Co5Gg@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> The interesting part is what to do with it; it's not enough to make that
> BUG_ON() to STFU, unfortunately.

Why? That's what I did last week, it seemed to be the RightThing(tm)
to do. It somebody has opened a symlink, opening that again through
/proc gives you the same symlink. That would be the natural semantics,
no? You do *not* want to follow it any further, afaik.

And yes, I tested the ENOTDIR semantics too while doing that, and it
seems to be the right thing again. It's not a directory. It's a
symlink.

But hey, if there is some deeper reason for why we'd need to do
anything more that I'm missing, and not just your dislike of the
semantics, thats' fine too.

That said, the thing I think is the *real* bug is that we expose this
O_NOFOLLOW|O_PATH file descriptor through /proc at all. How does that
happen to begin with? Normal O_PATH file descriptors don't do that,
afaik, and they get instantiated as some very special file descriptors
that don't show up as such for most operations. So I think there is
some O_NOFOLLOW magic going on there...

           Linus
