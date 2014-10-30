Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbaJ3KSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:18:31 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49591 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758164AbaJ3KS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:18:28 -0400
Date: Thu, 30 Oct 2014 10:18:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/syscalls: ignore numbers outside NR_syscalls'
 range
Message-ID: <20141030101808.GO27405@n2100.arm.linux.org.uk>
References: <1414620418-29472-1-git-send-email-rabin@rab.in>
 <20141030082606.GA7945@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030082606.GA7945@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 01:26:06AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 29, 2014 at 11:06:58PM +0100, Rabin Vincent wrote:
> > ARM has some private syscalls (for example, set_tls(2)) which lie
> > outside the range of NR_syscalls.  If any of these are called while
> > syscall tracing is being performed, out-of-bounds array access will
> > occur in the ftrace and perf sys_{enter,exit} handlers.
> 
> While this patch looks like good caution, having syscalls outside of
> NR_syscalls seems like a receipe for a disaster.  Can you try to fix
> that issue as ell, please?

No.  We've had them since the inception of Linux on ARM.  They predate
this tracing crap by more than a decade.  We're not changing them
because that would be a massive user API breakage.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
