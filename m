Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3D2P7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:59:17 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:42769 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab3D2P7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:59:15 -0400
Date: Mon, 29 Apr 2013 17:59:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ptrace/x86: ptrace_write_dr7() should create bp if
 !disabled
Message-ID: <20130429155909.GB31230@somewhere>
References: <20130418184350.GA4407@redhat.com>
 <20130418184419.GA4444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184419.GA4444@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:44:19PM +0200, Oleg Nesterov wrote:
> 24f1e32c "hw-breakpoints: Rewrite the hw-breakpoints layer on top
> of perf events" introduced the minor regression. Before this commit
> 
> 	PTRACE_POKEUSER DR7, enableDR0
> 	PTRACE_POKEUSER DR0, address
> 
> was perfectly valid, now PTRACE_POKEUSER(DR7) fails if DR0 was not
> previously initialized by PTRACE_POKEUSER(DR0).
> 
> Change ptrace_write_dr7() to do ptrace_register_breakpoint(addr => 0)
> if !bp && !disabled. This fixes watchpoint-zeroaddr from ptrace-tests,
> see https://bugzilla.redhat.com/show_bug.cgi?id=660204.
> 
> Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
