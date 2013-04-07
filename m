Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab3DGMBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 08:01:54 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60947 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416Ab3DGMBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 08:01:53 -0400
Date: Sun, 7 Apr 2013 17:26:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 8/9] uretprobes: Remove -ENOSYS as return probes
 implemented
Message-ID: <20130407115606.GG2186@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
 <1365004839-21982-9-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1365004839-21982-9-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040712-3620-0000-0000-000001EDB002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anton Arapov <anton@redhat.com> [2013-04-03 18:00:38]:

> Enclose return probes implementation.
> 
> Signed-off-by: Anton Arapov <anton@redhat.com>
> ---

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

>  kernel/events/uprobes.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 489f5e3..9af52f7 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -828,10 +828,6 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
>  	if (!uc->handler && !uc->ret_handler)
>  		return -EINVAL;
> 
> -	/* TODO: Implement return probes */
> -	if (uc->ret_handler)
> -		return -ENOSYS;
> -
>  	/* Racy, just to catch the obvious mistakes */
>  	if (offset > i_size_read(inode))
>  		return -EINVAL;
> -- 
> 1.8.1.4
> 

-- 
Thanks and Regards
Srikar Dronamraju

