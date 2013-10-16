Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346Ab3JPMub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:50:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42112 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934188Ab3JPMu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:50:29 -0400
Date: Wed, 16 Oct 2013 18:20:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uprobes: Introduce __create_xol_area()
Message-ID: <20131016125018.GH19729@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131013191815.GA32466@redhat.com>
 <20131013191835.GA32487@redhat.com>
 <20131016124125.GE19729@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131016124125.GE19729@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101612-0320-0000-0000-000001615854
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > 
> >  /* Slot allocation for XOL */
> > -static int xol_add_vma(struct xol_area *area)
> > +static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
> >  {
> > -	struct mm_struct *mm = current->mm;
> >  	int ret = -EALREADY;
> > 
> >  	down_write(&mm->mmap_sem);
> >  	if (mm->uprobes_state.xol_area)
> >  		goto fail;
> > 
> > -	ret = -ENOMEM;
> > -	/* Try to map as high as possible, this is only a hint. */
> > +		/* Try to map as high as possible, this is only a hint. */
> 
> Nit: This comment seems to be shifted unnecessarily.
> 

This gets corrected in the next patch.. Sorry for the noise.

-- 
Thanks and Regards
Srikar Dronamraju

