Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3BXLzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:55:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:60657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab3BXLzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:55:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,727,1355126400"; 
   d="scan'208";a="266860268"
Message-ID: <5129FFB5.9040405@intel.com>
Date: Sun, 24 Feb 2013 19:55:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in fork/exec/wake
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-10-git-send-email-alex.shi@intel.com> <1361353360.10155.9.camel@laptop> <5124BCEB.8030606@intel.com> <1361367371.10155.32.camel@laptop> <5124DC76.2010801@intel.com> <1361453587.26780.18.camel@laptop> <512631C7.8060103@intel.com> <1361523279.26780.45.camel@laptop> <5129DD1A.8070509@intel.com> <5129E223.9020807@linux.vnet.ibm.com>
In-Reply-To: <5129E223.9020807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Um, let me try to explain again, The utilisation need much time to
>> accumulate itself(345ms). Whenever with or without load weight, many
>> bursting tasks just give a minimum weight to the carrier CPU at the
>> first few ms. So, it is too easy to do a incorrect distribution here and
>> need migration on later periodic balancing.
> 
> I dont understand why forked tasks are taking time to accumulate the
> load.I understand this if it were to be a woken up task.The first time

new forked task will get its load at once.
but the CPU utilization still need time to accumulate, these are
different concept. The cpu utilization means in a past period, this cpu
runs some ms...



-- 
Thanks
    Alex
