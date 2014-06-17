Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaFQNTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:19:11 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59210 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752082AbaFQNTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:19:09 -0400
Message-ID: <1403011143.4535.4.camel@hornet>
Subject: Re: [PATCH] perf: Handle compat ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drew Richardson <Drew.Richardson@arm.com>
Date: Tue, 17 Jun 2014 14:19:03 +0100
In-Reply-To: <20140617121328.GO3213@twins.programming.kicks-ass.net>
References: <1402671812-9078-1-git-send-email-pawel.moll@arm.com>
	 <20140617121328.GO3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 13:13 +0100, Peter Zijlstra wrote:
> On Fri, Jun 13, 2014 at 04:03:32PM +0100, Pawel Moll wrote:
> > When running a 32-bit userspace on a 64-bit kernel (eg. i386
> > application on x86_64 kernel or 32-bit arm userspace on arm64
> > kernel) some of the perf ioctls must be treated with special
> > care, as they have a pointer size encoded in the command.
> > 
> > For example, PERF_EVENT_IOC_ID in 32-bit world will be encoded
> > as 0x80042407, but 64-bit kernel will expect 0x80082407. In
> > result the ioctl will fail returning -ENOTTY.
> > 
> > This patch solves the problem by adding code fixing up the
> > size as compat_ioctl file operation.
> > 
> > Reported-by: Drew Richardson <drew.richardson@arm.com>
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > ---
> 
> This gets me (on my favourite x86_64 .config):
> 
> kernel/events/core.c: In function ‘perf_compat_ioctl’:
> kernel/events/core.c:3726:32: error: ‘compat_uptr_t’ undeclared (first use in this function)
> kernel/events/core.c:3726:32: note: each undeclared identifier is reported only once for each function it appears in

Right, sorry. I've added the size check last minute and haven't
re-tested it with x86_64. #include for compat.h was missing (wonder
where was it included for arm64 ;-)

Already posted v2.

Pawel

