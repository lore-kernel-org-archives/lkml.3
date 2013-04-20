Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3DTQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377Ab3DTQZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:25:27 -0400
Date: Sat, 20 Apr 2013 18:22:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Add hardware breakpoint address mask
Message-ID: <20130420162223.GA13393@redhat.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com> <1365528113-5458-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365528113-5458-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Jacob Shin wrote:
>
> @@ -612,6 +612,9 @@ static int hw_breakpoint_add(struct perf_event *bp, int flags)
>  	if (!(flags & PERF_EF_START))
>  		bp->hw.state = PERF_HES_STOPPED;
>
> +	if (bp->attr.bp_addr_mask && !arch_has_hw_breakpoint_addr_mask())
> +		return -EOPNOTSUPP;
> +

This is called by sched_in... Isn't it "too late" ?

Perhaps arch_validate_hwbkpt_settings() should validate mask/cpu_has_bpext?

Oleg.

