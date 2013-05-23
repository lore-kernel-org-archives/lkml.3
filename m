Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3EWOGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:06:11 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45828 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab3EWOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:06:09 -0400
Date: Thu, 23 May 2013 10:10:36 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130523125218.GB23650@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I can confirm your patch avoids the oops on my machine.

It does lead to interesting behavior if I run the sample program
multiple times (with added printfs):

vince@core2:~$ ./perf_mmap_close_bug 
mmap1=0x7f06a6e90000
mmap2=0x7f06a6e7f000
vince@core2:~$ ./perf_mmap_close_bug 
mmap1=0x7f878a138000
mmap2=0x7f878a127000
vince@core2:~$ ./perf_mmap_close_bug 
mmap1=0xffffffffffffffff
Error opening fd2 Invalid argument

and then it never successfully completes again.  Is this unexpected 
behavior?  Or just a normal mmap/perf interaction that I don't understand?

Vince
