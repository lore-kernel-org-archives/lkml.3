Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3LWPcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 10:32:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab3LWPcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 10:32:13 -0500
Date: Mon, 23 Dec 2013 16:32:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/16] ARM: add uprobes support
Message-ID: <20131223153209.GA27754@redhat.com>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org> <1387166930-13182-16-git-send-email-dave.long@linaro.org> <1387564464.3404.106.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387564464.3404.106.camel@linaro1.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Jon Medhurst (Tixy) wrote:
>
> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
> > From: "David A. Long" <dave.long@linaro.org>
> >
> > Caveats:
> >
> >  - Thumb is not supported
> >  - XOL abort/trap handling is not implemented
>
> I shall repeat my comment from version one of the patch...
>
> What are the consequences of this, e.g. is it possible for a probe to
> get stuck in an infinite loop of faulting? I hope there are no integrity
> issues for the kernel itself.

Unless there is something arm-specific, the kernel should be fine. The
task should notice a signal after handle_singlestep() before it returns
to the user-mode.

But of course the probed application can be confused. And I have no idea
what arm does if, say, a single-stepped xol insn triggers the page fault.
We need to change instruction_pointer() back to the faulted (probed) insn
if the page fault fails. But since because arch_uprobe_xol_was_trapped()
is not implemented this won't happen.

Oleg.

