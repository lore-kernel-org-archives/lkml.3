Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3HVUsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:48:51 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:44504 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3HVUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
 <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
 <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
 <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu> <CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
 <CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 13:48:28 -0700
Message-ID: <CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 1:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Aug 22, 2013 at 1:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Let me rephrase that: why do we allow these types of lookup to recurse
>> like normal symlinks?  I'm proposing that these links immediately
>> terminate lookup  [..]
>
> It can nest *inside* a regular symlink. So there should not be any
> recursion of pure /proc style symlink jumps, but they live within the
> nesting that is normal symlink behavior.
>

Sure.  But aren't they always last?

With the current code structure, trying to enforce some kind of
security restriction in the middle of lookup seems really unpleasant.
But if the final step is to verify one of these links and then either
reject or end lookup right there, it'll be (IMO) much easier to
understand.

--Andy


>             Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
