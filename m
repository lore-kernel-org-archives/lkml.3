Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaJTOlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:41:40 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:39246 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaJTOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:41:39 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 20 Oct 2014 10:48:21 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: 3.17 another perf_fuzzer lockup
In-Reply-To: <alpine.DEB.2.11.1410200045530.19577@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1410201047300.19981@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410151418570.3151@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1410161723220.9124@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410171015540.15673@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410171118090.15673@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1410200045530.19577@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Vince Weaver wrote:

> nope.  Wasted 3 days trying to bisect this.  Something during the 3.17 
> merge window changed enough to make the perf_fuzzer results 
> non-deterministic, and that makes it nearly impossibe to reproduce the
> issue properly.  Ugh.  I might be reduced to sprinkling printks around 
> unless anyone chimes in with better advice.

yes, so 3 different bisects from 3 different starting points and it 
bisects each time to:

	commit 29b88e23a9212136d39b0161a39afe587d0170a5
	Merge: 2521129 4e3a25b
	Author: Linus Torvalds <torvalds@linux-foundation.org>
	Date:   Mon Aug 4 18:34:04 2014 -0700

    	Merge tag 'driver-core-3.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/dri
    
	Pull driver core updates from Greg KH:
		"Here's the big driver-core pull request for 3.17-rc1.

which makes no sense at all :(

Vince
