Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3K0Pu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:50:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab3K0Pu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:50:57 -0500
Date: Wed, 27 Nov 2013 16:50:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] tools/perf/util: Document and clean up readn() a bit
Message-ID: <20131127155017.GG1208@krava.brq.redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-2-git-send-email-jolsa@redhat.com>
 <20131125192909.GA27323@ghostprotocols.net>
 <20131126175335.GA9300@gmail.com>
 <5295AFA3.6060007@intel.com>
 <20131127115746.GB10528@gmail.com>
 <52960D71.7010107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52960D71.7010107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 08:19:13AM -0700, David Ahern wrote:
> On 11/27/13, 4:57 AM, Ingo Molnar wrote:
> >Okay, I thought this was an intentional 'all or nothing' interface -
> >but looking at the readn() users they can tolerate partial results
> >just fine.
> 
> I believe that is the intent -- an all or nothing interface.

all the users either checks the returned value with the size
or do (ret < 0) and fail

and one instance in the read_attr does not check anything and
blindly hopes it will read all ;-)

I have similar patch that also change callers to use proper
ssize_t instead of int.. I can rebase and send it separately
or combine it with yours.. let me know

jirka
