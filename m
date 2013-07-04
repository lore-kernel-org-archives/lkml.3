Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab3GDOr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:47:58 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:44715 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3GDOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:47:56 -0400
Message-ID: <51D58B0E.8090206@hp.com>
Date: Thu, 04 Jul 2013 10:47:42 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ian Kent <raven@themaw.net>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 04/12] auto-fs: rename d_count field of dentry to d_refcount
References: <1372908808-33304-1-git-send-email-Waiman.Long@hp.com> <CA+55aFzKfPG=CH+vZBUQMNd32qsuxPF1D3c3DB2Dm8w1QCb1+w@mail.gmail.com>
In-Reply-To: <CA+55aFzKfPG=CH+vZBUQMNd32qsuxPF1D3c3DB2Dm8w1QCb1+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 11:50 PM, Linus Torvalds wrote:
> On Wed, Jul 3, 2013 at 8:33 PM, Waiman Long<Waiman.Long@hp.com>  wrote:
>> Because of the d_count name change made in dcache.h, all references
>> to d_count have to be changed to d_refcount.  There is no change in
>> logic and everything should just work.
> These filesystem patches need to be just joined into the same patch
> that does the d_count ->  d_refcount change.
>
> Otherwise the kernel won't build in lots of configurations for some
> commits, which makes things like bisecting much more painful than it
> should be.
>
> So we can't do piece-meal changes that break the build for parts of the tree.
>
>                Linus

I could change patch 3 so that I keep the d_count name, but #define 
d_refcount to d_count. In that way, I can do piece-meal changes without 
breaking the build. Alternatively, I could collapse patches 3-11 into a 
single big patch which will be harder to review.

Regards,
Longman
