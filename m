Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3AaA1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:27:17 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:34210 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab3AaA1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:27:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130131001339.GC14801@flint.arm.linux.org.uk>
References: <20130130200648.GA13298@flint.arm.linux.org.uk>
 <20130130215211.GA28418@flint.arm.linux.org.uk> <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
 <20130130221946.GA14801@flint.arm.linux.org.uk> <CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com>
 <CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com> <20130131001339.GC14801@flint.arm.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Jan 2013 11:26:53 +1100
X-Google-Sender-Auth: ER9wyMI1_F4xOFDjx4XzfjJ4z3U
Message-ID: <CA+55aFxfeXWAiXV18qGgOk9+2HHiD7LUuyk55brHFXd+_c6eZQ@mail.gmail.com>
Subject: Re: BUG: circular locking dependency detected
To: Russell King <rmk@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:13 AM, Russell King <rmk@arm.linux.org.uk> wrote:
>
> Which may or may not be a good thing depending how you look at it; it
> means that once your kernel blanks, you get a lockdep dump.  At that
> point you lose lockdep checking for everything else because lockdep
> disables itself after the first dump.

Fair enough, we may want to revert the lockdep checking for
console_lock, and make re-enabling it part of the patch-series that
fixes the locking.

Daniel/Dave? Does that sound reasonable?

              Linus
