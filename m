Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab3CGR1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:27:45 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48510
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932263Ab3CGR1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:27:44 -0500
Message-ID: <1362677252.10972.26.camel@laptop>
Subject: Re: [PATCH] sched: wakeup buddy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 07 Mar 2013 18:27:32 +0100
In-Reply-To: <5136EB06.2050905@linux.vnet.ibm.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
> @@ -3351,7 +3420,13 @@ select_task_rq_fair(struct task_struct *p, int
> sd_flag, int wake_flags)
>         }
>  
>         if (affine_sd) {
> -               if (cpu != prev_cpu && wake_affine(affine_sd, p,
> sync))
> +               /*
> +                * If current and p are wakeup related, and balance is
> +                * guaranteed, we will try to make them running
> closely
> +                * to gain cache benefit.
> +                */
> +               if (cpu != prev_cpu && wakeup_related(p) &&
> +                                       wake_affine(affine_sd, p,
> sync))
>                         prev_cpu = cpu;


OK, so there's two issues I have with all this are:

 - it completely wrecks task placement for things like interrupts (sadly
I don't
     have a good idea about a benchmark where this matters).
 - yet another random number.. :/

Also, I'm starting to dislike the buddy name; its somewhat over-used.

