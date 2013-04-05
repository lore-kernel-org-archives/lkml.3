Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161549Ab3DEDOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 23:14:18 -0400
Received: from ozlabs.org ([203.10.76.45]:35702 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161536Ab3DEDOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 23:14:17 -0400
Date: Fri, 5 Apr 2013 13:50:25 +1100
From: Paul Mackerras <paulus@samba.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        benh@kernel.crashing.org
Subject: Re: [RFC PATCH v2 2/6] powerpc: Exception hooks for context tracking
 subsystem
Message-ID: <20130405025025.GB22465@drongo>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
 <1364551221-23177-3-git-send-email-zhong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364551221-23177-3-git-send-email-zhong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 06:00:17PM +0800, Li Zhong wrote:
> This is the exception hooks for context tracking subsystem, including
> data access, program check, single step, instruction breakpoint, machine check,
> alignment, fp unavailable, altivec assist, unknown exception, whose handlers
> might use RCU.
> 
> This patch corresponds to
> [PATCH] x86: Exception hooks for userspace RCU extended QS
>   commit 6ba3c97a38803883c2eee489505796cb0a727122
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Is there a reason why you didn't put the exception_exit() call in
ret_from_except_lite in entry_64.S, and the exception_entry() call in
EXCEPTION_PROLOG_COMMON?  That would seem to catch all these cases in
a more centralized place.

Also, I notice that with the exception_exit calls where they are, we
can still deliver signals (thus possibly taking a page fault) or call
schedule() for preemption after the exception_exit() call.  Is that
OK, or is it a potential problem?

Paul.
