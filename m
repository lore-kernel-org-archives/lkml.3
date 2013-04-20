Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3DTQ4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab3DTQ4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:56:53 -0400
Date: Sat, 20 Apr 2013 18:53:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] perf: Add support for hardware breakpoint address
	masks
Message-ID: <20130420165334.GA14814@redhat.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Jacob Shin wrote:
>
> The following patchset adds address masks to existing perf hardware
> breakpoint mechanism to allow trapping on an address range (currently
> only single address) on supported architectures.
>
> perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> beyond) is provided, and perf tool has been extended to do:
>
>   $ perf stat -e mem:0x1000:w:0xf a.out
>                               ^^^
>                               "don't care" bit mask
>
>   which will count writes to [0x1000 ~ 0x1010)

Please help me understand...

Assuming that cpu_has_bpext == T, suppose that

	bp_addr		= 0x1001;
	bp_bp_addr_mask	= 0xf;

Is it the same as 0x1000/0xf above?

IOW, what exactly this mask means? I guess, mem:ADDR:w:MASK
should trigger the trap if CPU writes to the addr and

	(addr & ~MASK) == (ADDR & ~MASK)

correct?

And does attr.bp_len "contribute" to the mask?

I mean, if bp_len == X86_BREAKPOINT_LEN_8, does this mean that
bp_bp_addr_mask and (bp_bp_addr_mask | 7) have the same effect?

Oleg.

