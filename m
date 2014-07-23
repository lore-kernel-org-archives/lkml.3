Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaGWQyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:54:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:53959 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaGWQyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:54:02 -0400
Date: Wed, 23 Jul 2014 13:53:58 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/41] perf tools: Identify which comms are from exec
Message-ID: <20140723165358.GP20303@kernel.org>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-6-git-send-email-adrian.hunter@intel.com>
 <20140714203237.GA18133@kernel.org>
 <53C513CC.1010202@intel.com>
 <20140723140752.GJ20303@kernel.org>
 <20140723140908.GK20303@kernel.org>
 <53CFE6F3.4010605@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CFE6F3.4010605@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 23, 2014 at 07:46:43PM +0300, Adrian Hunter escreveu:
> On 23/07/2014 5:09 p.m., Arnaldo Carvalho de Melo wrote:
> >Em Wed, Jul 23, 2014 at 11:07:52AM -0300, Arnaldo Carvalho de Melo escreveu:
> >>Em Tue, Jul 15, 2014 at 02:43:08PM +0300, Adrian Hunter escreveu:
> >>>>>@@ -106,6 +107,8 @@ int comm__override(struct comm *comm, const char *str, u64 timestamp)
> >>>>>  	comm_str__put(old);
> >>>>>  	comm->comm_str = new;
> >>>>>  	comm->start = timestamp;
> >>>>>+	if (exec && !comm->exec)
> >>>>>+		comm->exec = true;

> >>>>Why do you need the !comm->exec test?

> >>>Dunno

> >>I saw that you kept it in the last patchkit submitted, I'll just drop
> >>it, needless obfuscation.
 
> Sorry I forgot.
 
> >Also why do you need to "identify which comms are from exec", was it
> >good for?
 
> It is for grouping together all the data from a single execution, which
> is needed for pairing calls and returns e.g. any outstanding calls when
> a process exec's will never return.

Ok, thanks, I'll add it to the patch log, as I did with some others.

I'll continue after lunch, what I have so far is in the tmp.perf/core in
my tree, at git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git

- Arnaldo
