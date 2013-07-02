Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab3GBU11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:27:27 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:44845 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3GBU1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:27:23 -0400
Date: Tue, 2 Jul 2013 16:32:42 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: [testcase] perf: yet another fuzzer triggered crash
In-Reply-To: <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Vince Weaver wrote:

> I'm in the process of kernel bisecting this, though all I can tell you so 
> far is 2.6.32 is unaffected by the bug but 3.2 and later are.

well, I spent 2 days bisecting between 3.1 and 3.2 (after 
wasting time bisecting between 3.0 and 3.1 by mistake) 
(also, a pox on whoever introduced that ethernet .config change between 
3.1. 3.2).

and of course what it gives me is
   a240f76165e6255384d4bdb8139895fac7988799

   perf, core: Introduce attrs to count in either host or guest mode

so the test case wasn't crashing because the auto-generated file
was setting exclude_guest and exclude_host causing perf_event_open() 
to fail.  If I drop setting those bits it still crashes.  

I guess back to the drawing board.

Vince
