Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3I2Gyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:54:32 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47439 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3I2Gya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:54:30 -0400
Subject: Re: [BUG/RFC 3/3] perf tools: Add missing GTK2_SUPPORT ifdefs
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
In-Reply-To: <20130927185450.GB3943@infradead.org>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
	 <1380292332-6518-1-git-send-email-jolsa@redhat.com>
	 <1380292332-6518-3-git-send-email-jolsa@redhat.com>
	 <20130927185450.GB3943@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Sep 2013 15:54:25 +0900
Message-ID: <1380437665.1727.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

2013-09-27 (금), 15:54 -0300, Arnaldo Carvalho de Melo:
> Em Fri, Sep 27, 2013 at 04:32:12PM +0200, Jiri Olsa escreveu:
> > When building minimal perf via:
> >   NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1 NO_DEMANGLE=1
> >   NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1 NO_LIBNUMA=1 NO_LIBAUDIT=1
> >   NO_LIBBIONIC=1
> > 
> > We dont link -ldl and that's causing error for gtk2 related code,
> > which is disabled on command line (NO_GTK2), but not in the code
> > (GTK2_SUPPORT).
> > 
> > We probably need some global fix/change for this browser
> > enabled/disable code.
> 
> But for now what you did is enough, since the only module that uses
> the dl mechanism is the GTK+ one, so I'm applying it.
> 
> I should have detected this before pushing out perf/core with the
> changes that introduced this problem, that is what:
> 
>   make -C tools/perf -f tests/make
> 
> was made to catch, my bad, Namhyung, please use those tests next time
> too :-)

I almost forgot about that, sorry.  Will do the tests next time.

Thanks,
Namhyung


