Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3H2BkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:40:08 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:45563 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3H2BkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
Date: Wed, 28 Aug 2013 18:40:04 -0700
X-Google-Sender-Auth: zlOGFcXviUE5sJcukLeCotcl5vk
Message-ID: <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just FYI: I've merged two preparatory patches in my tree for the whole
lockref thing. Instead of applying your four patches as-is during the
merge window, I ended up writing two patches that introduce the
concept and use it in the dentry code *without* introducing any of the
new semantics yet.

Waiman, I attributed the patches to you, even if they don't actually
look much like any of the patches you sent out. And because I was
trying very hard to make sure that no actual semantics changed, my
version doesn't have the dget_parent() lockless update code, for
example. I literally just did a search-and-replace of "->d_count" with
"->d_lockref.count" and then I fixed up a few things by hand (undid
one replacement in a comment, and used the helper functions where they
were semantically identical).

 You don't have to rewrite your patches if you don't want to, I'm
planning on cherry-picking the actual code changes during the merge
window.

                  Linus
