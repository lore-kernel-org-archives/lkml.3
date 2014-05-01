Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaEATLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaEATLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:11:39 -0400
Date: Thu, 1 May 2014 21:11:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] uprobes: fix scratch register selection for
	rip-relative fixups
Message-ID: <20140501191123.GA17949@redhat.com>
References: <1398964141-25097-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398964141-25097-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01, Denys Vlasenko wrote:
>
> Before this patch, instructions such as div, mul,
> shifts with count in CL, cmpxchg are mishandled.

Thanks. I'll try to read this patch tomorrow, but you do know that I can't
review (or even understand ;) the change in riprel_analyze().

As for other changes, perhaps we can cleanup them later somehow, but I am
not going to discuss this now. I agree that the fix should be as simple
as possible.

Only on nit,

> -#define UPROBE_FIX_RIP_AX	0x08
> -#define UPROBE_FIX_RIP_CX	0x10
> +#define UPROBE_FIX_RIP_SI	0x08
> +#define UPROBE_FIX_RIP_DI	0x10
> +#define UPROBE_FIX_RIP_BX	0x20
> +#define UPROBE_FIX_RIP_ALL	0x38

OK, but please define UPROBE_FIX_RIP_ALL as

	#define UPROBE_FIX_RIP_ALL	\
		(UPROBE_FIX_RIP_SI | UPROBE_FIX_RIP_DI | UPROBE_FIX_RIP_BX)

Please do not bother to do this right now, lets wait for review.

Oleg.

