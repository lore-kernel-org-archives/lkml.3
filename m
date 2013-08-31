Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3HaX2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 19:28:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39282 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3HaX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 19:28:13 -0400
Date: Sun, 1 Sep 2013 00:27:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130831232758.GO13318@ZenIV.linux.org.uk>
References: <5220F090.5050908@hp.com>
 <CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
 <5220FD51.2010709@hp.com>
 <CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
 <20130830205404.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
 <20130830214452.GH13318@ZenIV.linux.org.uk>
 <CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
 <20130831212355.GN13318@ZenIV.linux.org.uk>
 <CA+55aFwxQ2zN+kbt0Atob-Rims4B1pxgFniXbbA=YDAfb+wWAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwxQ2zN+kbt0Atob-Rims4B1pxgFniXbbA=YDAfb+wWAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 03:49:31PM -0700, Linus Torvalds wrote:
> On Sat, Aug 31, 2013 at 2:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Hmm...  OK, most of these suckers are actually doing just one component;
> > we can look into 'print the ancestors as well' later, but the minimal
> > variant would be something like this and it already covers a lot of those
> > guys.  Comments?
> 
> Doesn't look wrong, but remember the /proc debugging thing? We
> definitely wanted more than just one pathname component, and I don't
> think that's completely rare.
> 
> So I think it would be better to prepare for that, and simply print to
> a local buffer, and then use the "string()" function on the end
> result. Rather than do it directly from the dentry like you do, and
> then having to do that widen() thing because you couldn't do the
> strnlen() that that code wanted..

Actually, right now I'm debugging a variant that avoids local buffers; use
is %pD3 for grandparent/parent/name, etc., up to %pD4.  %pd is equivalent
to %pD1 (just the dentry name).  Keep in mind that things like NFS use
a _lot_ of what would be %pD2 in debugging printks and the string can grow
fairly long, so I'd rather live with widen() than mess with local buffers
here.  I'll send an updated variant when I'm more or less satisfied with
it...
