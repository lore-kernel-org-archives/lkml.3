Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3CPU4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:56:37 -0400
Received: from two.firstfloor.org ([193.170.194.197]:49808 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3CPU4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:56:36 -0400
Date: Sat, 16 Mar 2013 21:56:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20130316205634.GU11268@two.firstfloor.org>
References: <20130312191118.GA17439@redhat.com>
 <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com>
 <20130312203514.GA23488@redhat.com>
 <20130313174641.GA28083@redhat.com>
 <20130313174705.GB28083@redhat.com>
 <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org>
 <20130315163916.GA31995@redhat.com>
 <20130316202327.GA18613@redhat.com>
 <20130316203221.GT11268@two.firstfloor.org>
 <20130316204539.GA19462@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316204539.GA19462@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps rcu can be better, although a global rwsem looks simpler,
> I dunno.

It's a general problem with lots of sysctls.
> 
> But argv_split() or its usage should be changed anyway, and GFP_KERNEL
> won't work under rcu_read_lock().

rcu strings has a helper function to copy the string for sleepy cases.

> 
> To me 1/2 looks as a simplification anyway, but I won't argue if we
> decide to add rcu/locking and avoid this patch.

Ok I'll revisit. I think the problem last time was that the rcu strings
needed a kernel_text_address() function that worked on all
architectures.

Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
