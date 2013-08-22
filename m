Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3HVTYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:24:00 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:40745 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3HVTX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
	<CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
	<20130822185317.GI31117@1wt.eu>
	<CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
Date: Thu, 22 Aug 2013 12:23:58 -0700
X-Google-Sender-Auth: 0V_jhroZ3O9hkyR2ExE9QbcrooM
Message-ID: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Willy Tarreau <w@1wt.eu>, "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 12:05 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Does this work for the procfs case?  As far as I understand it (which
> isn't saying much), it goes through the symlink-following path.

Right. The /proc case is still separate, and we really should do
something about that too. But again, I don't think I_LINKABLE is the
thing to use there either. We probably should tighten up the magic
/proc follow-link a lot.

> What if we added another field to struct nameidata that's indicates
> what restrictions need to be enforced when following magical symlinks
> and then enforcing them when nd_jump_link gets used.  (There are only
> two of these, both in procfs.)

Yes, I think that might be just the kind of thing to do. Except some
tightening could well be quite regardless of any extra flags.

            Linus
