Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaKFCQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:16:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaKFCQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:16:19 -0500
Message-ID: <545AD9C7.50205@redhat.com>
Date: Wed, 05 Nov 2014 18:15:35 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v4 5/5] perf/sdt: Add support to perf record to trace
 SDT events
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com>
In-Reply-To: <5459E865.6050207@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 01:05 AM, Masami Hiramatsu wrote:
> [Off topic] I really don't like that the current SDT's semaphore. If the user apps
> see the instruction at the probe point, it is easy to check whether the event is
> enabled or not. Thus I recommend to change its implementation and update version
> instead of supporting current semaphore by perftools.

You and I have banged heads on this before, but I don't think checking
the instruction is a simple as you seem to think.  I invite you to
prototype this, and if you get it working we can discuss the tradeoffs.

The good news is that other tools (stap and gdb) won't need to care.  If
the SDT semaphore goes automatic, then we can just set that note field
to zero, unused from the tool's perspective.

Another tactic is to just discourage developers from using the semaphore
in the first place, as it's a completely optional feature.  The marker
is just a NOP, so adding some "if (enabled) {...}" around it is often a
useless load and branch.  It does make sense if the probe wants to
provide some expensively-computed arguments though, like cpython does to
prepare a function name string.  So if you see a project testing the
semaphore around simple arguments, I'd suggest they just probe directly
instead.

Thanks,
Josh
