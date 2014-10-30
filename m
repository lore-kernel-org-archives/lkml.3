Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbaJ3I0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:26:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaJ3I0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:26:11 -0400
Date: Thu, 30 Oct 2014 01:26:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] tracing/syscalls: ignore numbers outside NR_syscalls'
 range
Message-ID: <20141030082606.GA7945@infradead.org>
References: <1414620418-29472-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414620418-29472-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 11:06:58PM +0100, Rabin Vincent wrote:
> ARM has some private syscalls (for example, set_tls(2)) which lie
> outside the range of NR_syscalls.  If any of these are called while
> syscall tracing is being performed, out-of-bounds array access will
> occur in the ftrace and perf sys_{enter,exit} handlers.

While this patch looks like good caution, having syscalls outside of
NR_syscalls seems like a receipe for a disaster.  Can you try to fix
that issue as ell, please?
