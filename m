Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3FCO7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:59:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:56278 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab3FCO72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:59:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,793,1363158000"; 
   d="scan'208";a="250032421"
Message-ID: <51ACAF4D.3010600@linux.intel.com>
Date: Mon, 03 Jun 2013 07:59:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, alex.shi@intel.com,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, efault@gmx.de, pjt@google.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        len.brown@intel.com, corbet@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com>
In-Reply-To: <20130531105204.GE30394@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>   - enumeration of idle states
>
>   - how long it takes to enter+exit a particular idle state
>
>   - [ perhaps information about how destructive to CPU caches that
>       particular idle state is. ]
>
>   - new driver entry point that allows the scheduler to enter any of the
>     enumerated idle states. Platform code will not change this state, all
>     policy decisions and the idle state is decided at the power saving
>     policy level.
>
> All of this combines into a 'cost to enter and exit an idle state'
> estimation plus a way to enter idle states. It should be presented to the
> scheduler in a platform independent fashion, but without policy embedded:
> a low level platform driver interface in essence.


you're missing an aspect.
Deeper idle states on one core, allow (on Intel and AMD at least) the other cores to go faster.
So it's not so simple as "if I want more performance, go less deep". By going less deep you also reduce
overall performance of the system... as well as increase the power usage.

This aspect really really cannot be ignored, it's quite significant today, and going forward
is only going to get more and more significant.


