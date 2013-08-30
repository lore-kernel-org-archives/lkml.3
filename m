Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3H3WaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 18:30:18 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45158 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3H3WaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130830214452.GH13318@ZenIV.linux.org.uk>
References: <52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<5220E56A.80603@hp.com>
	<CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
	<5220F090.5050908@hp.com>
	<CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
	<5220FD51.2010709@hp.com>
	<CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
	<20130830205404.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
	<20130830214452.GH13318@ZenIV.linux.org.uk>
Date: Fri, 30 Aug 2013 15:30:14 -0700
X-Google-Sender-Auth: oOc_BAfD_hw6Giz0vi0Ms84KVC8
Message-ID: <CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 2:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Point...  Actually, I wonder if _that_ could be a solution for ->d_name.name
> printk races as well.  Remember that story?  You objected against taking
> spinlocks in printk, no matter how specialized and how narrow the area
> over which those are taken, but rcu_read_lock/rcu_read_unlock should be
> OK...  Something like %pd expecting dentry pointer and producing dentry
> name.  Sure, we still get garbage if we race with d_move(), but at least
> it's a contained garbage that way...

Yes, that sounds quite reasonable. For printk, we'd probably want to
limit the max size and depth to something fairly small (32 bytes, max
four deep or something), and we cannot take cwd/root into account
since it can happen from interrupts, but other than that it doesn't
sound horrible.

           Linus
