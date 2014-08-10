Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaHJTfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 15:35:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaHJTfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 15:35:09 -0400
Date: Sun, 10 Aug 2014 21:33:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <private@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce
	writer locking)
Message-ID: <20140810193308.GA31867@redhat.com>
References: <53E6CF2B.6090709@roeck-us.net> <CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Kees Cook wrote:
>
> On Sat, Aug 9, 2014 at 6:47 PM, Guenter Roeck <private@roeck-us.net> wrote:
> > Hi folks,
> >
> > I am having some trouble with commit dbd952127d (seccomp: introduce
> > writer locking) when running my qemu tests on the upstream kernel.
>
> Eek, sorry this is causing you trouble!
>
> > With powerpc, I get the following crash.
> >
> > ftrace: allocating 20093 entries in 59 pages
> > ------------[ cut here ]------------
> > kernel BUG at kernel/fork.c:1108!
>
> For your tree, does this resolve to copy_seccomp()'s
>
>         BUG_ON(!spin_is_locked(&current->sighand->siglock));
>
> line?

This is almost off-topic, and I too do not understand whats going on...

But I'd suggest to change this check to use  lockdep_is_held() in any
case.

Oleg.

