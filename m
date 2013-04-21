Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3DURW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab3DURWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:22:25 -0400
Date: Sun, 21 Apr 2013 19:19:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] perf, x86: AMD implementation for hardware
	breakpoint address mask
Message-ID: <20130421171921.GA6645@redhat.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com> <1365528113-5458-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365528113-5458-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a comment, but the question...

On 04/09, Jacob Shin wrote:
>
> --- a/arch/x86/include/asm/hw_breakpoint.h
> +++ b/arch/x86/include/asm/hw_breakpoint.h
> @@ -14,6 +14,7 @@ struct arch_hw_breakpoint {
>  	unsigned long	address;
>  	u8		len;
>  	u8		type;
> +	u32		mask;
>  };
...
> @@ -254,6 +258,7 @@ static int arch_build_bp_info(struct perf_event *bp)
>  	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
>
>  	info->address = bp->attr.bp_addr;
> +	info->mask = bp->attr.bp_addr_mask;

OK, this matches the usage of info->address so I think this change
is right.

But otoh, why do we need info->address (or mask added by this patch)?
we could use bp->attr.bp_addr instead. arch_hw_breakpoint could have
a single filed = "type | len" for encode_dr7().

Yes, off-topic, sorry for noise.

Oleg.

