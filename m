Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaAUNAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:00:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaAUNAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:00:40 -0500
Subject: Re: [PATCH v6 1/8] x86: allow to handle errors in text_poke
 function family
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <20140114182029.27fa13f9@gandalf.local.home>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	 <1386690140-19941-2-git-send-email-pmladek@suse.cz>
	 <20140114182029.27fa13f9@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jan 2014 14:00:37 +0100
Message-ID: <1390309237.14199.16.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 18:20 -0500, Steven Rostedt wrote:
> FYI, for future patches, start the subject with a capital letter. ie:
>  x86: Allow to handle errors in text_poke function family
> 
> On Tue, 10 Dec 2013 16:42:13 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > The text_poke functions called BUG() in case of error. This was too strict.
> > There are situations when the system is still usable even when the patching
> > has failed, for example when enabling the dynamic ftrace.
> > 
> > This commit modifies text_poke and text_poke_bp functions to return an error
> > code instead of calling BUG(). They used to return the patched address. But
> > the address was just copied from the first parameter. It was no extra
> > information and it has not been used anywhere yet.
> > 
> > There are some situations where it is hard to recover from an error. Masami
> > Hiramatsu <masami.hiramatsu.pt@hitachi.com> suggested to create
> > text_poke*_or_die() variants for this purpose.
> 
> I don't like the "_or_die()". Although I don't care much about it, I'm
> thinking the x86 maintainers might not like it either.
> 
> What about just doing the test in the places that would call "or_die"?
> 
> 	ret = text_poke*();
> 	BUG_ON(ret);

Exactly this solution has been used in v5 of this patch set, see 
https://lkml.org/lkml/2013/12/3/258

Masami suggested to use the "or_die()" because BUG_ON() was used on most
locations, see https://lkml.org/lkml/2013/12/6/1107

I personally do not have any strong opinion about it and will do
whatever makes x86 maintainers happy :-)

Best Regards,
Petr

