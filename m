Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaHNKR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:17:57 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54033 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753913AbaHNKRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:17:55 -0400
Message-ID: <1408011468.21373.4.camel@hornet>
Subject: Re: [PATCH v2] perf: Handle compat ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drew Richardson <Drew.Richardson@arm.com>
Date: Thu, 14 Aug 2014 11:17:48 +0100
In-Reply-To: <20140707124315.GN6758@twins.programming.kicks-ass.net>
References: <20140617121328.GO3213@twins.programming.kicks-ass.net>
	 <1403009029-30967-1-git-send-email-pawel.moll@arm.com>
	 <1404230760.25766.5.camel@hornet>
	 <20140707124315.GN6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 13:43 +0100, Peter Zijlstra wrote:
> On Tue, Jul 01, 2014 at 05:06:00PM +0100, Pawel Moll wrote:
> > On Tue, 2014-06-17 at 13:43 +0100, Pawel Moll wrote:
> > > When running a 32-bit userspace on a 64-bit kernel (eg. i386
> > > application on x86_64 kernel or 32-bit arm userspace on arm64
> > > kernel) some of the perf ioctls must be treated with special
> > > care, as they have a pointer size encoded in the command.
> > > 
> > > For example, PERF_EVENT_IOC_ID in 32-bit world will be encoded
> > > as 0x80042407, but 64-bit kernel will expect 0x80082407. In
> > > result the ioctl will fail returning -ENOTTY.
> > > 
> > > This patch solves the problem by adding code fixing up the
> > > size as compat_ioctl file operation.
> > > 
> > > Reported-by: Drew Richardson <drew.richardson@arm.com>
> > > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > 
> > This just is a polite and friendly nag...
> > 
> > Any, strong or not, opinions on the matter?
> 
> Sorry, travel, cracks, falling, etc..
> 
> Queued it, we'll see what happens with this one ;-)

Has it managed to hold on to the ground between the cracks then? ;-)

(asking because can't see it in your perf/core branch on git.kernel.org)

Pawel

