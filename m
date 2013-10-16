Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278Ab3JPMlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:41:36 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43003 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab3JPMlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:41:35 -0400
Date: Wed, 16 Oct 2013 18:11:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uprobes: Introduce __create_xol_area()
Message-ID: <20131016124125.GE19729@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131013191815.GA32466@redhat.com>
 <20131013191835.GA32487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131013191835.GA32487@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101612-5806-0000-0000-00002316E039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-10-13 21:18:35]:

> No functional changes, preparation.
> 
> Extract the code which actually allocates/installs the new area
> into the new helper, __create_xol_area().
> 
> While at it remove the unnecessary "ret = ENOMEM" and "ret = 0"
> in xol_add_vma(), they both have no effect.
> 
> Cc: stable@vger.kernel.org # 3.9+
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

One nit below.

> 
>  /* Slot allocation for XOL */
> -static int xol_add_vma(struct xol_area *area)
> +static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
>  {
> -	struct mm_struct *mm = current->mm;
>  	int ret = -EALREADY;
> 
>  	down_write(&mm->mmap_sem);
>  	if (mm->uprobes_state.xol_area)
>  		goto fail;
> 
> -	ret = -ENOMEM;
> -	/* Try to map as high as possible, this is only a hint. */
> +		/* Try to map as high as possible, this is only a hint. */

Nit: This comment seems to be shifted unnecessarily.


-- 
Thanks and Regards
Srikar Dronamraju

