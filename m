Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaKZGVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:21:49 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:39061 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaKZGVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:21:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzVyTi_pR4y3=Z3y1bWkXbvgoJaykoyn0pUE7eTYgr+ZQ@mail.gmail.com>
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
	<CA+55aFzVyTi_pR4y3=Z3y1bWkXbvgoJaykoyn0pUE7eTYgr+ZQ@mail.gmail.com>
Date: Tue, 25 Nov 2014 22:21:46 -0800
X-Google-Sender-Auth: XLVaW0gwofj4abnO_6Ouiyu6G0Y
Message-ID: <CA+55aFzOSfdvgrkfiN=zZg4mSoot-tJQiVRh5ENW2-rzmLMy1w@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Juergen Gross <jgross@suse.com>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 9:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And leave it running for a while, and see if the trace is always the
> same, or if there are variations on it...

Amusing.

Lookie here:

   http://lists.xenproject.org/archives/html/xen-changelog/2005-08/msg00310.html

That's from 2005.

Anyway, I don't see why the cr3 issue matters, *unless* there is some
situation where the scheduler can run with interrupts enabled. And why
this is Xen-related, I have no idea.

The Xen patches seem to have lost that

 /* On Xen the line below does not always work. Needs investigating! */

line when backporting the 2.6.29 patches to Xen. And clearly nobody
investigated.

So please do get me back-traces, and we'll investigate. Better late
than never. But it does sound Xen-specific - although it's possible
that Xen just triggers some timing (and has apparently been able to
trigger it since 2005) that DaveJ now triggers on his one machine.

So DaveJ, even though this does appear Xen-centric (Xentric?) and
you're running on bare hardware, maybe you could do the same thing in
that x86-64 vmalloc_fault(). The timing with Jürgen is kind of
intriguing - if 3.18-rc made it happen much more often for him, maybe
it really is very timing-sensitive, and you actually are seeing a
non-Xen version of the same thing...

                           Linus
