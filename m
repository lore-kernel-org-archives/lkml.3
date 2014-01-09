Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaAIBYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:24:21 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42913 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAIBYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:24:18 -0500
Date: Thu, 9 Jan 2014 02:24:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: suravee.suthikulpanit@amd.com
Cc: mingo@kernel.org, mingo@redhat.com, jacob.w.shin@gmail.com,
        oleg@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        hpa@zytor.com, linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/4] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20140109012411.GA7204@localhost.localdomain>
References: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1386764906-1681-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386764906-1681-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 06:28:23AM -0600, suravee.suthikulpanit@amd.com wrote:
> @@ -295,11 +301,17 @@ static int arch_build_bp_info(struct perf_event *bp)
>  		break;
>  #endif
>  	default:
> -		return -EINVAL;
> +		if (!is_power_of_2(bp->attr.bp_len))
> +			return -EINVAL;
> +		if (!cpu_has_bpext)
> +			return -EOPNOTSUPP;
> +		info->mask = bp->attr.bp_len - 1;
> +		info->len = X86_BREAKPOINT_LEN_1;

I think I asked this before but I can't remember. So dr7 must have
length as LEN_1 for breakpoint extension?
