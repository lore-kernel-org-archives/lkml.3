Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab3HUMan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3HUMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:30:42 -0400
Date: Wed, 21 Aug 2013 14:24:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130821122437.GB2965@redhat.com>
References: <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com> <20130819184355.GA25362@redhat.com> <CALCETrU4gTfzcpeEo-X7o-yZefKiw9BVNKdcN4fThUeiuZtOOg@mail.gmail.com> <20130820185043.GA24040@redhat.com> <CALCETrUjohT2D=jtVQ9mnbeUr2oJ9VoN812PtQhaB2ZZ89isNA@mail.gmail.com> <20130820190529.GA24512@redhat.com> <CALCETrVC15BjcRMk2tc-SRT3tUr24057Zxt5ARQ-2Eq7RhjO2w@mail.gmail.com> <20130820192340.GA25441@redhat.com> <CALCETrXnf8V+CgHDwEEviBkn0bJ60_H6G6WPmZxkQF85bqj3TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXnf8V+CgHDwEEviBkn0bJ60_H6G6WPmZxkQF85bqj3TQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Andy Lutomirski wrote:
>
> On Tue, Aug 20, 2013 at 12:23 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> but vfork(); unshare(CLONE_NEWPID) will fail?  (I
> >> admit I haven't tested it.)
> >
> > Do you mean that the child does unshare(CLONE_NEWPID) before exec?
> > It should fail with or without this patch.
> >
>
> Exactly. Shouldn't it succeed?

Ah, I am starting to understand... Sorry, I thought that you were
arguing with the patch I sent.

Yes, perhaps you are right... But this is another isssue, and needs
another change and another discussion. Afaics, we only need to change
the "clone_flags" checks in sys_unshare().

Oleg.

