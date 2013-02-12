Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab3BLK03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:26:29 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34417
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881Ab3BLK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:26:28 -0500
Message-ID: <1360664784.4485.17.camel@laptop>
Subject: Re: [patch v4 07/18] sched: set initial load avg of new forked task
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:26:24 +0100
In-Reply-To: <1358996820-23036-8-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-8-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> +       /*
> +        * set the initial load avg of new task same as its load
> +        * in order to avoid brust fork make few cpu too heavier
> +        */
> +       if (flags & ENQUEUE_NEWTASK)
> +               se->avg.load_avg_contrib = se->load.weight; 

I seem to have vague recollections of a discussion with pjt where we
talk about the initial behaviour of tasks; from this haze I had the
impression that new tasks should behave like full weight..

PJT is something more fundamental screwy?

