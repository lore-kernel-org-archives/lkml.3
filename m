Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaDVGHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:07:04 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43502 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaDVGG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:06:59 -0400
Date: Tue, 22 Apr 2014 08:06:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-event/cgroup: explicitly init the early_init field
Message-ID: <20140422060654.GB9133@gmail.com>
References: <1398144517-9496-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398144517-9496-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jianyu Zhan <nasa4836@gmail.com> wrote:

> For a cgroup subsystem who should init early, then it should carefully
> take care of the implementation of css_alloc, because it will be called
> before mm_init() setup the world.
> 
> Luckily we don't, and we better explicitly assign the early_init field
> to 0, for document reason.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  kernel/events/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index f83a71a..b3a8916 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8062,5 +8062,6 @@ struct cgroup_subsys perf_event_cgrp_subsys = {
>  	.css_free	= perf_cgroup_css_free,
>  	.exit		= perf_cgroup_exit,
>  	.attach		= perf_cgroup_attach,
> +	.early_init	= 0,

How can that field ever be nonzero?

I.e. under what exact circumstances does this patch make sense?

Thanks,

	Ingo
