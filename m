Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3CGRWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:22:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59345 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab3CGRWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:22:19 -0500
Message-ID: <1362676917.10972.23.camel@laptop>
Subject: Re: [PATCH] sched: wakeup buddy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 07 Mar 2013 18:21:57 +0100
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
> +static inline int wakeup_related(struct task_struct *p)
> +{
> +       if (wakeup_buddy(p, current)) {
> +               /*
> +                * Now check whether current still focus on his buddy.
> +                */
> +               if (wakeup_buddy(current, p))
> +                       return 1;
> +       }
> +
> +       return 0;
> +}

Not commenting on the thing in general, but:

static inline bool wakeup_related(struct task_struct *p)
{
	return wakeup_buddy(p, current) && wakeup_buddy(current, p);
}

is far shorter and easier to read :-)

