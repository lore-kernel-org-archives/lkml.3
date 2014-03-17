Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaCQO5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:57:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933197AbaCQO5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:57:01 -0400
Date: Mon, 17 Mar 2014 15:56:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/5] perf tools: Add machine pointer into thread struct
Message-ID: <20140317145644.GE6469@krava.brq.redhat.com>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-5-git-send-email-jolsa@redhat.com>
 <20140314141612.GE2396@ghostprotocols.net>
 <878us9tht4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878us9tht4.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:17:43PM +0900, Namhyung Kim wrote:
> Hi Arnaldo,
> 
> On Fri, 14 Mar 2014 11:16:12 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Mar 14, 2014 at 03:00:05PM +0100, Jiri Olsa escreveu:
> >> Need machine pointer in thread object, so we could
> >> lookup the process thread in following patch.
> >
> > Can't we use the already existing thread->mg.machine for that?
> 
> It needs to know the machine when ->mg is not allocated yet.

right

> 
> That means we can now get rid of the mg->machine?

not really, it's heavilly used in kernel symbol handling,
to get machine details.. and there's no kernel thread
specific info, which we could use to get machine pointer

we would need to factor this part to be able to get rid
of mg->machine

jirka
