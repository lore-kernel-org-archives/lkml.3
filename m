Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaKZFwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:52:39 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:59172 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaKZFwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:52:37 -0500
MIME-Version: 1.0
In-Reply-To: <54756424.6020409@suse.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141126002501.GA11752@redhat.com>
	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<5475596A.9010301@suse.com>
	<CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>
	<54756424.6020409@suse.com>
Date: Tue, 25 Nov 2014 21:52:37 -0800
X-Google-Sender-Auth: 5ebAo9aerG0xmpupqYZYtpghWj4
Message-ID: <CA+55aFzVyTi_pR4y3=Z3y1bWkXbvgoJaykoyn0pUE7eTYgr+ZQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Juergen Gross <jgross@suse.com>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 9:24 PM, Juergen Gross <jgross@suse.com> wrote:
>
> Working on it. Triggering it via sysrq(l) isn't working: machine hung
> up. I'll try a dump, but this might take some time due to the machine
> size...

Actually, in that patch that did this:

-       pgd = pgd_offset(current->active_mm, address);
+       pgd = (pgd_t *)__va(read_cr3()) + pgd_index(address);

make the code do:

        pgd = (pgd_t *)__va(read_cr3()) + pgd_index(address);
        WARN_ON(pdg != pgd_offset(current->active_mm, address));

and now you should get a nice backtrace for exactly when it happens,
but it's on a working kernel, so nothing will lock up.

Hmm?

And leave it running for a while, and see if the trace is always the
same, or if there are variations on it...

Thanks,

                      Linus
