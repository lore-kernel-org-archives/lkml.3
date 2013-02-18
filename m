Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab3BRI4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:56:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:28551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720Ab3BRI4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:56:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,686,1355126400"; 
   d="scan'208";a="288520055"
Message-ID: <5121ECD9.3020300@intel.com>
Date: Mon, 18 Feb 2013 16:56:57 +0800
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
Subject: Re: [patch v5 10/15] sched: packing transitory tasks in wake/exec
 power balancing
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-11-git-send-email-alex.shi@intel.com> <20130218084439.GB10009@lge.com>
In-Reply-To: <20130218084439.GB10009@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 04:44 PM, Joonsoo Kim wrote:
> Hello, Alex.
> 
> On Mon, Feb 18, 2013 at 01:07:37PM +0800, Alex Shi wrote:
>> If the waked/execed task is transitory enough, it will has a chance to be
>> packed into a cpu which is busy but still has time to care it.
>> For powersaving policy, only the history util < 25% task has chance to
>> be packed, and for balance policy, only histroy util < 12.5% has chance.
>> If there is no cpu eligible to handle it, will use a idlest cpu in
>> leader group.
> 
> After exec(), task's behavior may be changed, and history util may be
> changed, too. So, IMHO, exec balancing by history util is not good idea.
> How do you think about it?
> 

sounds make sense. are there any objections?

