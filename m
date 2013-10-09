Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3JIIiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab3JIIiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:38:17 -0400
Date: Wed, 9 Oct 2013 10:38:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 53/52] tools/perf/build: Clean up feature_print_code()
Message-ID: <20131009083804.GA1005@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-38-git-send-email-mingo@kernel.org>
 <20131007221233.GF2900@krava.redhat.com>
 <20131008084610.GB3295@gmail.com>
 <20131008155110.GA15558@krava.redhat.com>
 <20131009064205.GG7664@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009064205.GG7664@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 08:42:05AM +0200, Ingo Molnar wrote:

SNIP

> > 
> > I think the issue might be in the eval handling the $(info $(MSG)).
> > With following change on top of your v2 patchset it works for me.
> 
> Indeed - and that works here too. Initially I was trying to solve it by 
> forcing expansion:
> 
> 	MSG := ...
> 
> but I forgot that expansion does not necessarily force evaluation of the 
> expression and that Make can still optimize such assignments away if their 
> result is not used by a target, correct?

I saw that the $(info $(MSG)) output was delayed to next
iteration, that's why an extra item (DUMMY) was needed
to display all of them

so I guessed the eval had issues with $(info ...) and put
it away.. not sure what the actual reason was.. we could
go with your explanation ;-)


> 
> I've applied your cleanup patch below and added your signoff - is that 
> fine with you?

sure, np

thanks,
jirka
