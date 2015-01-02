Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbbABW3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:29:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52053 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbABW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:29:39 -0500
Date: Fri, 2 Jan 2015 23:29:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Richard Weinberger <richard@nod.at>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
Message-ID: <20150102222936.GA29018@amd>
References: <1419457167-15042-1-git-send-email-richard@nod.at>
 <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com>
 <20150102051142.GF4873@amd>
 <54A67A38.3000207@nod.at>
 <20150102194616.GA27538@amd>
 <54A7103E.6020500@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A7103E.6020500@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-02 22:40:14, Richard Weinberger wrote:
> Am 02.01.2015 um 20:46 schrieb Pavel Machek:
> >>> Does this break trinity, crashme, and similar programs?
> >>
> >> If they fork() without execve() and a child dies very fast the next fork()
> >> will be throttled.
> >> This is why I'd like to make this feature disabled by default.
> >>
> >>> Can you detect it died due to the stack canary? Then, the patch might
> >>> be actually acceptable.
> >>
> >> I don't think so as this is glibc specific.
> > 
> > Can the slowdown be impelmented in glibc, then?
> 
> glibc has a lot of asserts where it can detect stack smashing and kills the
> current process using abort(). Here it could of course also call
> sleep().

Please do it in glibc, then.

> > If not, can glibc provide enough information to the kernel to allow us
> > to do the right thing?
> 
> IMHO we should not strictly focus on the stack canary.

IMO we should. We want it enabled by default.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
