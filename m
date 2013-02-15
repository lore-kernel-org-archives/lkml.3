Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503Ab3BOMiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:38:24 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49644
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576Ab3BOMiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:38:23 -0500
Message-ID: <1360931899.2739.8.camel@laptop>
Subject: Re: [patch v4 01/18] sched: set SD_PREFER_SIBLING on MC domain to
 reduce a domain level
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Feb 2013 13:38:19 +0100
In-Reply-To: <511B9392.1080003@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	  <1358996820-23036-2-git-send-email-alex.shi@intel.com>
	 <1360663879.4485.2.camel@laptop> <511B9392.1080003@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 21:22 +0800, Alex Shi wrote:
> No, the flags set on MC/CPU domain, but is checked in their parents
> balancing, like in NUMA domain.
> Without the flag, will cause NUMA domain imbalance. like on my 2
> sockets
> NHM EP: 3 of 4 tasks were assigned on socket 0(lcpu, 10, 12, 14)
> 
> In this case, update_sd_pick_busiest() need a reduced group_capacity
> to
> return true:
>         if (sgs->sum_nr_running > sgs->group_capacity)
>                 return true;
> then numa domain balancing get chance to start.

Ah, indeed. Its always better to include such 'obvious' problems in the
changelog :-)

