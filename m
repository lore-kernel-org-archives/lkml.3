Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935125Ab3DPAXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:23:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:40555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3DPAXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,479,1363158000"; 
   d="scan'208";a="227548343"
Message-ID: <516C99BB.30309@intel.com>
Date: Tue, 16 Apr 2013 08:22:19 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Len Brown <lenb@kernel.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic> <516A0652.8040505@intel.com> <20130414155925.GC20547@pd.tnic> <516B9859.70004@intel.com> <516B9B57.3030902@intel.com> <20130415095203.GA26524@pd.tnic> <516C059E.20800@intel.com> <20130415231206.GE12144@pd.tnic>
In-Reply-To: <20130415231206.GE12144@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 07:12 AM, Borislav Petkov wrote:
> On Mon, Apr 15, 2013 at 09:50:22PM +0800, Alex Shi wrote:
>> For fairness and total threads consideration, powersaving cost quit
>> similar energy on kbuild benchmark, and even better.
>>
>> 	    17348.850		    27400.458		   15973.776
>> 	    13737.493		    18487.248		   12167.816
> 
> Yeah, but those lines don't look good - powersaving needs more energy
> than performance.
> 
> And what is even crazier is that fixed 1.2 GHz case. I'd guess in
> the normal case those cores are at triple the freq. - i.e. somewhere
> around 3-4 GHz. And yet, 1.2 GHz eats almost *double* the power than
> performance and powersaving.

yes, the max freq is 2.7 GHZ, plus boost.
> 
> So for the x=8 and maybe even the x=16 case we're basically better off
> with performance.
> 
> Or could it be that the power measurements are not really that accurate
> and those numbers above are not really correct?

testing has a little variation, but the power data is quite accurate. I
may change to packing tasks per cpu capacity than current cpu weight.
that should has better power efficient value.

> 
> Hmm.
> 


-- 
Thanks Alex
