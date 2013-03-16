Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3CPUry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab3CPUrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:47:52 -0400
Date: Sat, 16 Mar 2013 21:45:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 0/2] finx argv_split() vs sysctl race
Message-ID: <20130316204539.GA19462@redhat.com>
References: <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com> <20130313174641.GA28083@redhat.com> <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org> <20130315163916.GA31995@redhat.com> <20130316202327.GA18613@redhat.com> <20130316203221.GT11268@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316203221.GT11268@two.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Andi Kleen wrote:
>
> On Sat, Mar 16, 2013 at 09:23:27PM +0100, Oleg Nesterov wrote:
> > On 03/15, Oleg Nesterov wrote:
> > >
> > > To remind, say, argv_split(poweroff_cmd) can race with sysctl changing this
> > > string, in this case it can write to the memory after argv[] array. We can
> > > fix this, or we can rewrite argv_split/free:
> >
> > OK, please see 1/2.
> >
> > And this reminds me about set_task_comm() which pretends it does something
> > meaningful for the reader of the mutable ->comm, see the offtopic 2/2.
>
> I had "rcu strings" to handle the sysctl string race problem in a
> generic way some time ago.
>
> http://lwn.net/Articles/368684/
>
> Unfortunately never made it in. Perhaps it should be revisited.

Perhaps rcu can be better, although a global rwsem looks simpler,
I dunno.

But argv_split() or its usage should be changed anyway, and GFP_KERNEL
won't work under rcu_read_lock().

To me 1/2 looks as a simplification anyway, but I won't argue if we
decide to add rcu/locking and avoid this patch.

Oleg.

