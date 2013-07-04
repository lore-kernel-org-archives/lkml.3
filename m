Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab3GDDuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:50:11 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:40262 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113Ab3GDDuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:50:08 -0400
MIME-Version: 1.0
In-Reply-To: <1372908808-33304-1-git-send-email-Waiman.Long@hp.com>
References: <1372908808-33304-1-git-send-email-Waiman.Long@hp.com>
Date: Wed, 3 Jul 2013 20:50:07 -0700
X-Google-Sender-Auth: 9lVA-8T_wAwdd1xxN1XdtbkNHB0
Message-ID: <CA+55aFzKfPG=CH+vZBUQMNd32qsuxPF1D3c3DB2Dm8w1QCb1+w@mail.gmail.com>
Subject: Re: [PATCH v4 04/12] auto-fs: rename d_count field of dentry to d_refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 8:33 PM, Waiman Long <Waiman.Long@hp.com> wrote:
> Because of the d_count name change made in dcache.h, all references
> to d_count have to be changed to d_refcount.  There is no change in
> logic and everything should just work.

These filesystem patches need to be just joined into the same patch
that does the d_count -> d_refcount change.

Otherwise the kernel won't build in lots of configurations for some
commits, which makes things like bisecting much more painful than it
should be.

So we can't do piece-meal changes that break the build for parts of the tree.

              Linus
