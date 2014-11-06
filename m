Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaKFFd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:33:59 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47744 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaKFFd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:33:57 -0500
Message-ID: <545B083D.2000205@hitachi.com>
Date: Thu, 06 Nov 2014 14:33:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Josh Stone <jistone@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Re: [PATCH v4 5/5] perf/sdt: Add support to perf record to
 trace SDT events
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545AD9C7.50205@redhat.com>
In-Reply-To: <545AD9C7.50205@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/06 11:15), Josh Stone wrote:
> On 11/05/2014 01:05 AM, Masami Hiramatsu wrote:
>> [Off topic] I really don't like that the current SDT's semaphore. If the user apps
>> see the instruction at the probe point, it is easy to check whether the event is
>> enabled or not. Thus I recommend to change its implementation and update version
>> instead of supporting current semaphore by perftools.
> 
> You and I have banged heads on this before, but I don't think checking
> the instruction is a simple as you seem to think.  I invite you to
> prototype this, and if you get it working we can discuss the tradeoffs.

Would you have the prototype? I'd like to look :)

> The good news is that other tools (stap and gdb) won't need to care.  If
> the SDT semaphore goes automatic, then we can just set that note field
> to zero, unused from the tool's perspective.
> 
> Another tactic is to just discourage developers from using the semaphore
> in the first place, as it's a completely optional feature.  The marker
> is just a NOP, so adding some "if (enabled) {...}" around it is often a
> useless load and branch.  It does make sense if the probe wants to
> provide some expensively-computed arguments though, like cpython does to
> prepare a function name string.  So if you see a project testing the
> semaphore around simple arguments, I'd suggest they just probe directly
> instead.

I see, and we did that on qemu. I consider that someone maybe use
it in the future unless we remove it. If we can succeed to discourage
people using semaphore, we also should remove it.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


