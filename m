Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3LEIFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab3LEIFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:05:40 -0500
Date: Thu, 5 Dec 2013 09:05:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 28/28] perf tools: Add udis86 disassembler feature check
Message-ID: <20131205080513.GA1251@krava.brq.redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
 <1386076182-14484-29-git-send-email-jolsa@redhat.com>
 <20131204185024.GC14788@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204185024.GC14788@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:50:24PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 03, 2013 at 02:09:42PM +0100, Jiri Olsa escreveu:
> > Adding udis86 disassembler feature check which support
> > is needed for kvm:kvm_emulate_insn tracepoint.
> >  
> > +$(call feature_check,udis86)
> > +ifeq ($(feature-udis86), 1)
> > +  LIBTRACEEVENT_CFLAGS += -DHAVE_UDIS86
> > +  EXTLIBS += -ludis86
> > +else
> > +  msg := $(warning No udis86 support.);
> > +endif
> 
> That is really an incomplete message, what package should I install?
> Perhaps we should add this there then:
> 
> http://bit.ly/1hyrN52

nice :-)

> 
> Wow, that was easy, but yeah, could be made easier 8-) ;-P

so something like:
No udis86 found. Please install udis86-devel.

or:
No udis86 found, disabling kvm tracepoints instruction disassembly. Please install udis86-devel.

jirka
