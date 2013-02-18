Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3BRJPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:15:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:35191 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab3BRJPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:15:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,686,1355126400"; 
   d="scan'208";a="258284299"
Message-ID: <5121F15B.50403@intel.com>
Date: Mon, 18 Feb 2013 17:16:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 01/15] sched: set initial value for runnable avg of
 sched entities.
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-2-git-send-email-alex.shi@intel.com> <20130218082843.GA10009@lge.com>
In-Reply-To: <20130218082843.GA10009@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 04:28 PM, Joonsoo Kim wrote:
> On Mon, Feb 18, 2013 at 01:07:28PM +0800, Alex Shi wrote:
>> > We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
>> > after a new task forked.
>> > Otherwise random values of above variables cause mess when do new task
> I think that these are not random values. In arch_dup_task_struct(),
> we do '*dst = *src', so, these values come from parent process. If we use
> these value appropriately, we can anticipate child process' load easily.
> So to initialize the load_avg_contrib to zero is not good idea for me.

Um, for a new forked task, calling them random value is appropriate,
since uncertain value of decay_count make random behaviour in
enqueue_entity_load_avg().
And many comments said new forked task need not follow parent's
utilisations, like what's you claimed for exec.

-- 
Thanks Alex
