Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3EIUVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:21:50 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:39605 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3EIUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyCuksrVPwO=R_xX2An8qavo17aCZ5bfN=FWo1gZZfAsQ@mail.gmail.com>
References: <20130509192655.GG25399@ZenIV.linux.org.uk>
	<CA+55aFyCuksrVPwO=R_xX2An8qavo17aCZ5bfN=FWo1gZZfAsQ@mail.gmail.com>
Date: Thu, 9 May 2013 13:21:47 -0700
X-Google-Sender-Auth: v3GkXxflPiq63Zqyn7JfWEQ0UhA
Message-ID: <CA+55aFwfOS0uNrjuB92ntNsOMZYKOAABw+i29BoPLwhMOY+-hA@mail.gmail.com>
Subject: Re: [git pull] more vfs.git stuff
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. I get one more commit - a racy usbmon thing. Which looks fine per
> se, but would look even better if it just made mmap_active an atomic_t
> instead, wouldn't you say?

Oh, I see, the spinlock protects the read too and the logic there. Not
that I'm at all sure we care, since if that code races with somebody
else doing an mmap, there's a race at a much higher level anyway. So I
don't think the spinlock really gives any more serialization between
the reading/writing of that mmap_active count. You're going to get
either the old or the new value anyway, and an atomic will do that
too.

So whatever. I just don't want to pull stuff that gets me unexpected
patches that weren't in the pull request.

                 Linus
