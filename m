Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaJTEmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 00:42:00 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47635 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaJTEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 00:41:56 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 20 Oct 2014 00:48:43 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: 3.17 another perf_fuzzer lockup
In-Reply-To: <alpine.DEB.2.11.1410171118090.15673@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1410200045530.19577@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410151418570.3151@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1410161723220.9124@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410171015540.15673@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410171118090.15673@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2014, Vince Weaver wrote:

> On Fri, 17 Oct 2014, Vince Weaver wrote:
> 
> > Now to find out why this could happen.  Probably something to do with 
> > crazy RCU magic :(
> 
> it looks like there's an unbalanced get_ctx() / put_ctx() here, as the
> software event context on the main process should not get decremented
> to 0 unless that process is exiting, yet it happens.
> 
> Maybe this is bisectable.  Hmmm.

nope.  Wasted 3 days trying to bisect this.  Something during the 3.17 
merge window changed enough to make the perf_fuzzer results 
non-deterministic, and that makes it nearly impossibe to reproduce the
issue properly.  Ugh.  I might be reduced to sprinkling printks around 
unless anyone chimes in with better advice.

Vince
