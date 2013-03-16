Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab3CPUZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3CPUZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:25:46 -0400
Date: Sat, 16 Mar 2013 21:23:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 0/2] finx argv_split() vs sysctl race
Message-ID: <20130316202327.GA18613@redhat.com>
References: <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com> <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com> <20130313174641.GA28083@redhat.com> <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org> <20130315163916.GA31995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315163916.GA31995@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Oleg Nesterov wrote:
>
> To remind, say, argv_split(poweroff_cmd) can race with sysctl changing this
> string, in this case it can write to the memory after argv[] array. We can
> fix this, or we can rewrite argv_split/free:

OK, please see 1/2.

And this reminds me about set_task_comm() which pretends it does something
meaningful for the reader of the mutable ->comm, see the offtopic 2/2.

> But, whatever we do with argv_split(), it can hit the string "in between".
> Personally I think we do not really care, but...
>
> Perhaps we should add proc_dostring_lock() which takes some lock and
> modify the callers of argv_split() (or add argv_split_lock) ?
>
> Or perhaps we should introduce the rwsem which should protect every
> sysctl-string and proc_dostring() should take this lock?

Please tell me if you think we should do something with that.

Oleg.

