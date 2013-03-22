Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3CVFTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:19:23 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:43574 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3CVFTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
References: <20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
	<20130322001257.GH21522@ZenIV.linux.org.uk>
	<CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
	<20130322012208.GJ21522@ZenIV.linux.org.uk>
	<CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
	<20130322014037.GK21522@ZenIV.linux.org.uk>
	<20130322043715.GL21522@ZenIV.linux.org.uk>
	<CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
Date: Thu, 21 Mar 2013 22:19:21 -0700
X-Google-Sender-Auth: 2omByw4lgQDbJKhe1UJ8rFOg7EM
Message-ID: <CA+55aFxhPXvpPQcCvY7xRMWwsHGNoOdzpdZw7zJbR5-_QDW1tA@mail.gmail.com>
Subject: Re: [CFT] Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 9:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So why not just use "new_inode_pseudo()" instead? IOW, something like
> this (totally untested, natch) patch?

Ok, so I think that patch is still probably the right way to go, but
it's broken for a silly reason: because it's not using iget_locked()
any more, it also needs to remove the now unnecessary (and actively
incorrect) call to unlock_new_inode().

So remove that one line too, and maybe it could even work. Still not
*tested*, though.

              Linus
