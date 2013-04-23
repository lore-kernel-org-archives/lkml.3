Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3DWNV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:21:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab3DWNVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:21:55 -0400
Date: Tue, 23 Apr 2013 15:18:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130423131844.GA24467@redhat.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com> <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Jacob Shin wrote:
>
> +__weak int arch_validate_hwbkpt_addr_mask(struct perf_event *bp)
> +{
> +	return bp->attr.bp_addr_mask == 0;
> +}
> +
>  static int validate_hw_breakpoint(struct perf_event *bp)
>  {
>  	int ret;
> @@ -393,6 +398,10 @@ static int validate_hw_breakpoint(struct perf_event *bp)
>  	if (ret)
>  		return ret;
>  
> +	ret = arch_validate_hwbkpt_addr_mask(bp);
> +	if (ret)
> +		return ret;

Well, this looks obviously wrong?

arch_validate_hwbkpt_addr_mask() fails if bp_addr_mask == 0? and returns
"1" as the error code.

Either it should returns something like "bp_addr_mask ? -ENOTSUPP : 0"
or the caller should do "if (!validate_hw_breakpoint()) return -ERR".

Oleg.

