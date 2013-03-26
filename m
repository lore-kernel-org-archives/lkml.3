Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297Ab3CZIpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3CZIpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:45:50 -0400
Date: Tue, 26 Mar 2013 09:45:33 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 4/7] uretprobes: return probe entry, prepare_uretprobe()
Message-ID: <20130326084533.GB22603@bandura.brq.redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
 <1363957745-6657-5-git-send-email-anton@redhat.com>
 <20130324152651.GC17037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324152651.GC17037@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 04:26:51PM +0100, Oleg Nesterov wrote:
> On 03/22, Anton Arapov wrote:
[snip]
> And ->dirty looks confusing... perhaps ->chained ?
> 
> 		ri = kzalloc(...);
> 		if (!ri)
> 			return;
> 
> 		ret_vaddr = arch_uretprobe_hijack_return_addr(...);
> 		if (ret_vaddr == -1)
> 			goto err;
> 
> 		if (ret_vaddr == trampoline_vaddr) {
> 			if (!utask->return_instances) {
> 				// This situation is not possible.
> 				// (not sure we should send SIGSEGV)
> 				pr_warn(...);
> 				goto err;
> 			}

  If we don't send SIGSEGV, does it make sense to restore the original
return address that was just hijacked? So that we just decline setting
the breakpoint for this very case.

Anton.

> 
> 			ri->chained = true;
> 			ret_vaddr = utask->return_instances->orig_ret_vaddr;
> 		}
> 
> 		fill-ri-and-add-push-it;
> 		return;
> 
> 	err:
> 		kfree(ri);
> 		return;
> 
> Oleg.
> 
