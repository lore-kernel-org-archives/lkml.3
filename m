Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3D0RCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 13:02:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab3D0RCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 13:02:14 -0400
Date: Sat, 27 Apr 2013 18:58:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/3] perf tools: allow user to specify hardware
	breakpoint bp_len
Message-ID: <20130427165856.GA30282@redhat.com>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com> <1367002666-6910-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367002666-6910-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Jacob Shin wrote:
>
> @@ -518,12 +518,10 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
>  	if (parse_breakpoint_type(type, &attr))
>  		return -EINVAL;
>
> -	/*
> -	 * We should find a nice way to override the access length
> -	 * Provide some defaults for now
> -	 */
>  	if (attr.bp_type == HW_BREAKPOINT_X)
>  		attr.bp_len = sizeof(long);
> +	else if (len)
> +		attr.bp_len = len;
>  	else
>  		attr.bp_len = HW_BREAKPOINT_LEN_4;

Stupid question... So X86_FEATURE_BPEXT only works for r/w? I mean, it
doesn't allow to specify the mask for an execute breakpoint?

Otherwise the code above should be probably updated, say,

	if (!len) {
		len = attr.bp_type == HW_BREAKPOINT_X ?
			sizeof(long) : HW_BREAKPOINT_LEN_4;
	}
	attr.bp_len = len;

Oleg.

