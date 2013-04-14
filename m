Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3DNBhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 21:37:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:14442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab3DNBhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 21:37:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,469,1363158000"; 
   d="scan'208";a="317873248"
Message-ID: <516A0834.6080201@intel.com>
Date: Sun, 14 Apr 2013 09:36:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Mike Galbraith <efault@gmx.de>, Len Brown <lenb@kernel.org>,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic> <1365785311.5814.36.camel@marge.simpson.net> <20130412171251.GF2368@pd.tnic>
In-Reply-To: <20130412171251.GF2368@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2013 01:12 AM, Borislav Petkov wrote:
> On Fri, Apr 12, 2013 at 06:48:31PM +0200, Mike Galbraith wrote:
>> (just saying there are other aspects besides joules in there)
> 
> Yeah, but we don't allow any regressions in sched*, do we? Can we pick
> only the good cherries? :-)
> 

Thanks for all of discussion on this threads. :)
I think we can bear a little power efficient lose when want powersaving.

For second question, the performance increase come from cpu boost
feature, the hardware feature diffined, if there are some cores idle in
cpu socket, other core has more chance to boost on higher frequency. The
task packing try to pack tasks so that left more idle cores.

The difficult to merge this feature into current performance is that
current balance policy is trying to give as much as possible cpu
resources to each of task. that just conflict with the cpu boost condition.

-- 
Thanks
    Alex
