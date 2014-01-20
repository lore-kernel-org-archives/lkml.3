Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaATCzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 21:55:48 -0500
Received: from ozlabs.org ([203.10.76.45]:39149 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaATCzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 21:55:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, riel@redhat.com,
        aarcange@redhat.com, aquini@redhat.com, mst@redhat.com,
        vdavydov@parallels.com, amit.shah@redhat.com, dfediuck@redhat.com,
        alitke@redhat.com, "Daniel Kiper" <dkiper@net-space.pl>
Subject: Re: [RFC PATCH 3/4] virtio_balloon: add pressure notification via a new virtqueue
In-Reply-To: <20140116203819.0e7be6d4@redhat.com>
References: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com> <1389889445-3855-4-git-send-email-lcapitulino@redhat.com> <87y52ftus0.fsf@rustcorp.com.au> <20140116203819.0e7be6d4@redhat.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 20 Jan 2014 12:43:45 +1030
Message-ID: <8761pftn6u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Capitulino <lcapitulino@redhat.com> writes:
> On Fri, 17 Jan 2014 09:10:47 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Luiz Capitulino <lcapitulino@redhat.com> writes:
>> > From: Luiz capitulino <lcapitulino@redhat.com>
>> >
>> > This commit adds support to a new virtqueue called message virtqueue.
>> 
>> OK, this needs a lot of thought (especially since reworking the virtio
>> balloon is on the TODO list for the OASIS virtio technical committee...)
>> 
>> But AFAICT this is a way of explicitly saying "no" to the host's target
>> (vs the implicit method of just not meeting the target).  I'm not sure
>> that gives enough information to the host.  On the other hand, I'm not
>> sure what information we *can* give.
>> 
>> Should we instead be counter-proposing a target?
>
> The problem is how to estimate a target value. I found it simpler
> to just try to obey what the host is asking for (and fail if not
> possible) than trying to make the guest negotiate with the host.

Understood, but we already do this the other way where the host tells
the guest how much memory to give up.

And is a guest expected to automatically inflate the balloon even if the
host doesn't want the memory, or wait to be asked?

> >> What does qemu do with this information?
> >
> > There are two possible scenarios:
> >
> >  1. The balloon driver is currently inflating when it gets under
> >     pressure
> >
> >     QEMU resets "num_pages" to the current balloon size. This
> >     cancels the on-going inflate
> >
> >  2. The balloon driver is not inflating, eg. it's possibly sleeping
> >
> >    QEMU issues a deflate
> >
> > But note that those scenarios are not supposed to be used with the
> > current device, they are part of the automatic ballooning feature.
> > I CC'ed you on the QEMU patch, you can find it here case you didn't
> > see it:
> >
> >  http://marc.info/?l=kvm&m=138988966315690&w=2

Yes, caught that after I replied; I should have checked first.

It seems like we are still figuring out how to do ballooning.  The
best approach in cases like this is to make it simple, so I don't hate
this.

But note that Daniel Kiper and I have been discussing a new virtio
balloon for draft 2 of the standard.  I'll CC you when I post that to
one of the OASIS virtio mailing lists.

Cheers,
Rusty.
