Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3CYKbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab3CYKbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:31:31 -0400
Date: Mon, 25 Mar 2013 11:31:16 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 3/5] uprobes: Kill the unnecesary filp != NULL check in
 __copy_insn()
Message-ID: <20130325103116.GD8163@bandura.brq.redhat.com>
References: <20130324182040.GA13078@redhat.com>
 <20130324182118.GA13315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324182118.GA13315@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 07:21:18PM +0100, Oleg Nesterov wrote:
> __copy_insn(filp) can only be called after valid_vma() returns T,
> vma->vm_file passed as "filp" can not be NULL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
Acked-by: Anton Arapov <anton@redhat.com>
