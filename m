Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3DHEUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:20:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:20055 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab3DHET7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:19:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,427,1363158000"; 
   d="scan'208";a="318779473"
Message-ID: <5162454B.2050502@intel.com>
Date: Mon, 08 Apr 2013 12:19:23 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch v7 20/21] sched: don't do power balance on share cpu power
 domain
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <1365040862-8390-21-git-send-email-alex.shi@intel.com> <516236AE.60501@linux.vnet.ibm.com> <5162389F.4020208@linux.vnet.ibm.com>
In-Reply-To: <5162389F.4020208@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 11:25 AM, Preeti U Murthy wrote:
> Hi Alex,
> 
> I am sorry I overlooked the changes you have made to the power
> scheduling policies.Now you have just two : performance and powersave.
> 
> Hence you can ignore my below comments.But if you use group->capacity
> instead of group->weight for threshold,like you did for balance policy
> in your version5 of this patchset, dont you think the below patch can be
> avoided? group->capacity being the threshold will automatically ensure
> that you dont pack onto domains that share cpu power.


this patch is different from balance policy, the powersave still try to
move 2 busy tasks into one cpu core on Intel cpu. It is just don't keep
packing in cpu core, like if there are 2 half busy tasks in one cpu
core, with this patch, each of SMT thread has one half busy task,
without this patch, 2 half busy task are packed into one thread.

The removed balance policy just pack one busy task per cpu core.  Yes,
the 'balance' policy has its meaning. but that is different.

-- 
Thanks Alex
