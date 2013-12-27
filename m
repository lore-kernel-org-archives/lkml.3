Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3L0TZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:25:40 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:54987 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3L0TZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:25:39 -0500
Date: Fri, 27 Dec 2013 16:25:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip v2 1/2] [CLEANUP] perf-probe: Expand given path to
 absolute path
Message-ID: <20131227192530.GC13381@ghostprotocols.net>
References: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal>
 <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal>
 <52BC39D6.3090908@gmail.com>
 <20131226142248.GE30980@ghostprotocols.net>
 <52BD1ACA.7030506@hitachi.com>
 <52BD8C9B.8030206@gmail.com>
 <20131227174902.GA13381@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131227174902.GA13381@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 27, 2013 at 02:49:02PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Dec 27, 2013 at 09:20:11AM -0500, David Ahern escreveu:
> > On 12/27/13, 1:14 AM, Masami Hiramatsu wrote:
> > >Nowhere, since there is no terminal code for user
> > >command interface.
> 
> > >Those memories are released when the program terminated.
> > >I think it is just a waste of the time to free the memory
> > >pieces which are not used(and allocated) repeatedly.
> > >Or, is there any chance to call this part directly from
> > >other command?
> 
> There is always the chance of parts of a tool to be librarized, I think
> the rule is: allocator -> lifetime -> destructor, explicit.
> 
> We may want to explicitely disable some big destructor call (or lots of
> destructors, like symbols + hists, etc) because it may make exit time to
> be overly long, but at least we'll know what destructors to call when
> such code gets librarized.

Having said that, I applied the current patch, as it doesn't makes
things much worser than they already are, i.e. we need to audit that
code further, and these patches provided an useful new functionality.

- Arnaldo
