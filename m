Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3J1SxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab3J1SxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:53:10 -0400
Date: Mon, 28 Oct 2013 19:54:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/13] uprobes: allow ignoring of probe hits
Message-ID: <20131028185425.GA12863@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-3-git-send-email-dave.long@linaro.org> <20131019170214.GA8324@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019170214.GA8324@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, sorry for delay.

On 10/19, Oleg Nesterov wrote:
>
> On 10/15, David Long wrote:
> >
> > @@ -1732,9 +1732,6 @@ static void handle_swbp(struct pt_regs *regs)
> >  		return;
> >  	}
> >
> > -	/* change it in advance for ->handler() and restart */
> > -	instruction_pointer_set(regs, bp_vaddr);
> > -
>
> Well, this looks obviously wrong. This SET_IP() has the comment ;)
>
> Note also that with this breaks __skip_sstep() on x86.

Hmm. Thinking more, it seems that this patch has another problem.

IIUC, the whole point of arch_uprobe_ignore() is to avoid
handler_chain() if the condition was not satisfied, so you need
to call it before handler_chain() ?

Otherwise this logic should go into can_skip_sstep() and we simply
do not need the new hook, just we need to tweak the (ugly)
UPROBE_SKIP_SSTEP logic.

Oleg.

