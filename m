Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3H2PUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:20:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:48879 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3H2PUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:20:54 -0400
Message-ID: <521F66C6.6060401@hp.com>
Date: Thu, 29 Aug 2013 11:20:38 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com> <1375758759-29629-2-git-send-email-Waiman.Long@hp.com> <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
In-Reply-To: <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 09:40 PM, Linus Torvalds wrote:
> Just FYI: I've merged two preparatory patches in my tree for the whole
> lockref thing. Instead of applying your four patches as-is during the
> merge window, I ended up writing two patches that introduce the
> concept and use it in the dentry code *without* introducing any of the
> new semantics yet.
>
> Waiman, I attributed the patches to you, even if they don't actually
> look much like any of the patches you sent out. And because I was
> trying very hard to make sure that no actual semantics changed, my
> version doesn't have the dget_parent() lockless update code, for
> example. I literally just did a search-and-replace of "->d_count" with
> "->d_lockref.count" and then I fixed up a few things by hand (undid
> one replacement in a comment, and used the helper functions where they
> were semantically identical).
>
>   You don't have to rewrite your patches if you don't want to, I'm
> planning on cherry-picking the actual code changes during the merge
> window.
>
>                    Linus

Thanks for merging the 2 preparatory patches for me. I will rebase my 
patches with the latest linux git tree. A new v8 patch set will be sent 
out sometime next week. I am looking forward to the v3.12 merge window 
which I think is coming soon.

Cheer,
Longman
