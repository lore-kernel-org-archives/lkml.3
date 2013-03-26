Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab3CZMFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:05:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46852 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082Ab3CZMFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:05:37 -0400
Date: Tue, 26 Mar 2013 17:30:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 3/5] uprobes: Kill the unnecesary filp != NULL check in
 __copy_insn()
Message-ID: <20130326120037.GE639@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130324182040.GA13078@redhat.com>
 <20130324182118.GA13315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130324182118.GA13315@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032612-7182-0000-0000-000005F2D8BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-03-24 19:21:18]:

> __copy_insn(filp) can only be called after valid_vma() returns T,
> vma->vm_file passed as "filp" can not be NULL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 0a759c6..e5d479f 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -478,9 +478,6 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
>  {
>  	struct page *page;
> 
> -	if (!filp)
> -		return -EINVAL;
> -
>  	if (!mapping->a_ops->readpage)
>  		return -EIO;
>  	/*
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

