Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3HSR5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3HSR5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:57:10 -0400
Date: Mon, 19 Aug 2013 19:51:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Colin Walters <walters@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130819175124.GA23167@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CA+55aFzTr7zm2uyZOxMA8wP3FoKPtk__kgGBqf7peMW2Ov8KJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTr7zm2uyZOxMA8wP3FoKPtk__kgGBqf7peMW2Ov8KJA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Linus Torvalds wrote:
>
> So I think your patch is correct, although I'm not sure why you move
> the test.

I didn't really, we have 2 tests, in do_fork() and copy_process().
I think it would be better to do the similar checks in one place.

This is off-topic and needs a separate change anyway, but perhaps
we should add the new helper which checks clone_flags. copy_process()
is huge.

> The new test you have look complicated as hell, so I think
> you're actually making things worse by making them unreadable.

Oh I agree. I'll wait for the comments on intent, then try to
cleanup it somehow. Unless a better fix comes.

Oleg.

