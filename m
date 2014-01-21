Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaAUOCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:02:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:8936 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754441AbaAUOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:02:32 -0500
Date: Tue, 21 Jan 2014 09:02:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 1/8] x86: allow to handle errors in text_poke
 function family
Message-ID: <20140121090229.5936c2ba@gandalf.local.home>
In-Reply-To: <1390309237.14199.16.camel@pathway.suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-2-git-send-email-pmladek@suse.cz>
	<20140114182029.27fa13f9@gandalf.local.home>
	<1390309237.14199.16.camel@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 14:00:37 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> > > There are some situations where it is hard to recover from an error. Masami
> > > Hiramatsu <masami.hiramatsu.pt@hitachi.com> suggested to create
> > > text_poke*_or_die() variants for this purpose.
> > 
> > I don't like the "_or_die()". Although I don't care much about it, I'm
> > thinking the x86 maintainers might not like it either.
> > 
> > What about just doing the test in the places that would call "or_die"?
> > 
> > 	ret = text_poke*();
> > 	BUG_ON(ret);
> 
> Exactly this solution has been used in v5 of this patch set, see 
> https://lkml.org/lkml/2013/12/3/258
> 
> Masami suggested to use the "or_die()" because BUG_ON() was used on most
> locations, see https://lkml.org/lkml/2013/12/6/1107

If BUG_ON() is used in most locations, then we can make text_poke()
default to bug, and the just have a text_poke_safe() function that does
not bug. Or some similar name.

The "_die" has a bad taste in several developers mouth ;-)

-- Steve
