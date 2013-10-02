Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3JBKIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:08:35 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33380 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3JBKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:08:34 -0400
Date: Wed, 2 Oct 2013 12:08:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Separate lbfd check out of NO_DEMANGLE
 condition
Message-ID: <20131002100830.GA24445@gmail.com>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
 <1380292332-6518-1-git-send-email-jolsa@redhat.com>
 <1380437526.1727.10.camel@leonhard>
 <87d2noo4gn.fsf@sejong.aot.lge.com>
 <20131002081757.GA3496@krava.brq.redhat.com>
 <87li2cm5je.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li2cm5je.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Jiri,
> 
> On Wed, 2 Oct 2013 10:17:57 +0200, Jiri Olsa wrote:
> > On Wed, Oct 02, 2013 at 10:18:32AM +0900, Namhyung Kim wrote:
> >> It seems that it needs libdl for loading plugins.  Adding -ldl makes
> >> above build successfully.  So we need to add -ldl for EXTLIBS IMHO.
> >> Without it, make NO_GTK2=1 NO_LIBPERL=1 NO_LIBPYTHON=1 will fail to
> >> check libbfd correctly (FYI, libperl and libpython add -ldl to the
> >> dependency list).
> >
> > hum, so on my system -liberty check wins without -lbfd, so 'NO_GTK2=1 
> > NO_LIBPERL=1 NO_LIBPYTHON=1' passes
> >
> > I need to check Ingo's latest changes on this, not sure how if this 
> > problem is relevant any longer ;-)
> 
> AFAICS, Ingo's patch does "-lbfd -ldl" rather than "-lbfd".  So probably 
> there's no problem then. :)

I didn't fully demangle the maze of demangler feature tests yet :-) I 
added a single testcase, the rest is still detected using the old method.

Any assymetry in detection is probably a bug in my patches.

If that nested series of conditions is really necessary then we can add 
separate testcases for each, the same file built with different linker 
flags.

Thanks,

	Ingo
