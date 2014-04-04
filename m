Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaDDTwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:52:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbaDDTwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:52:01 -0400
Date: Fri, 4 Apr 2014 21:52:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] uprobes/x86: preparations to fix the reprel
	jmp/call handling.
Message-ID: <20140404195200.GA24356@redhat.com>
References: <20140404185038.GA14679@redhat.com> <20140404193226.GA23092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404193226.GA23092@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Oleg Nesterov wrote:
>
> +static int ttt_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	regs->sp += 8;
> +	if (ttt_emulate_op(auprobe, regs))
> +		return 0;
> +	return -ERESTART;
> +}

forgets to update ->ip before ttt_emulate_op(). Or we can simply
return -ERESTART after sp += 8. Please ignore this bug, this part
is trivial.

Oleg.

