Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaILJZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:25:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:46356 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaILJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:25:03 -0400
Date: Fri, 12 Sep 2014 11:24:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
In-Reply-To: <alpine.DEB.2.10.1409120950260.4178@nanos>
Message-ID: <alpine.DEB.2.10.1409121120440.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Thomas Gleixner wrote:
> On Thu, 11 Sep 2014, Dave Hansen wrote:
> > Well, we use it to figure out whether we _potentially_ need to tear down
> > an VM_MPX-flagged area.  There's no guarantee that there will be one.
> 
> So what you are saying is, that if user space sets the pointer to NULL
> via the unregister prctl, kernel can safely ignore vmas which have the
> VM_MPX flag set. I really can't follow that logic.
>  
> 	mmap_mpx();
> 	prctl(enable mpx);
> 	do lots of crap which uses mpx;
> 	prctl(disable mpx);
> 
> So after that point the previous use of MPX is irrelevant, just
> because we set a pointer to NULL? Does it just look like crap because
> I do not get the big picture how all of this is supposed to work?

do_bounds() will happily map new BTs no matter whether the prctl was
invoked or not. So what's the value of the prctl at all?

The mapping is flagged VM_MPX. Why is this not sufficient?

Thanks,

	tglx

