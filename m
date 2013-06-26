Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3FZX1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:27:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:37916 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3FZX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:27:34 -0400
Date: Thu, 27 Jun 2013 01:27:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Waiman Long <waiman.long@hp.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
In-Reply-To: <20130626212221.GI6123@two.firstfloor.org>
Message-ID: <alpine.DEB.2.02.1306270109180.4013@ionos.tec.linutronix.de>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <20130626201713.GH6123@two.firstfloor.org> <51CB57F6.6010003@hp.com> <20130626212221.GI6123@two.firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013, Andi Kleen wrote:
> On Wed, Jun 26, 2013 at 05:07:02PM -0400, Waiman Long wrote:
> > Looking from the other perspective, we may want the locking code to
> > have the same behavior whether spinlock debugging is enabled or not.
> > Disabling the optimization will cause the code path to differ which
> > may not be what we want. Of course, I can change it if other people
> > also think it is the right way to do it.
> 
> Lock debugging already has quite different timing/lock semantics.

Locks have no timing related sematics and lock debugging does not
change the semantics of locks. Lock debugging adds overhead to the
locking functions, but it does not affect the semantics of locks.

Thanks,

	tglx


