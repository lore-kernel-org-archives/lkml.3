Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbbABWcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:32:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbbABWcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:32:42 -0500
Date: Fri, 2 Jan 2015 23:32:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
cc: Richard Weinberger <richard@nod.at>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20150102222936.GA29018@amd>
Message-ID: <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz>
References: <1419457167-15042-1-git-send-email-richard@nod.at> <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com> <20150102051142.GF4873@amd> <54A67A38.3000207@nod.at> <20150102194616.GA27538@amd> <54A7103E.6020500@nod.at>
 <20150102222936.GA29018@amd>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2015, Pavel Machek wrote:

> > > Can the slowdown be impelmented in glibc, then?
> > 
> > glibc has a lot of asserts where it can detect stack smashing and kills the
> > current process using abort(). Here it could of course also call
> > sleep().
> 
> Please do it in glibc, then.

You also want to protect against binaries that are evil on purpose, right?

There is no guarantee that those will calling the kernel through glibc at 
all.

-- 
Jiri Kosina
SUSE Labs

