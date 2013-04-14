Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3DNP7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 11:59:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47620 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab3DNP7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 11:59:35 -0400
Date: Sun, 14 Apr 2013 17:59:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Len Brown <lenb@kernel.org>, mingo@redhat.com, peterz@infradead.org,
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
Message-ID: <20130414155925.GC20547@pd.tnic>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
 <516724F5.20504@kernel.org>
 <5167C9FA.8050406@intel.com>
 <20130412162348.GE2368@pd.tnic>
 <516A0652.8040505@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516A0652.8040505@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 09:28:50AM +0800, Alex Shi wrote:
> Even some scenario the total energy cost more, at least the avg watts
> dropped in that scenarios.

Ok, what's wrong with x = 32 then? So basically if you're looking at
avg watts, you don't want to have more than 16 threads, otherwise
powersaving sucks on that particular uarch and platform. Can you say
that for all platforms out there?

Also, I've added in the columns below the Energy = Power * Time thing.

And the funny thing is, exactly there where avg watts is better in
powersaving, energy for workload retire is worse. And the other way
around. Basically, avg watts vs retire energy is reciprocal. Great :-\.

> Len said he has low p-state which can work there. but that's is
> different. I had sent some data in another email list to show the
> difference:
> 
> The following is 2 times kbuild testing result for 3 kinds condiation on
> SNB EP box, the middle column is the lowest p-state testing result, we
> can see, it has the lowest power consumption, also has the lowest
> performance/watts value.
> At least for kbuild benchmark, powersaving policy has the best
> compromise on powersaving and power efficient. Further more, due to cpu
> boost feature, it has better performance in some scenarios.
> 
>    powersaving + ondemand  userspace + fixed 1.2GHz performance+ondemand
> x = 8    231.318 /75 57           165.063 /166 36        253.552 /63 62
> x = 16   280.357 /49 72           174.408 /106 54        296.776 /41 82
> x = 32   325.206 /34 90           178.675 /90 62         314.153 /37 86
> 
> x = 8    233.623 /74 57           164.507 /168 36        254.775 /65 60
> x = 16   272.54  /38 96           174.364 /106 54        297.731 /42 79
> x = 32   320.758 /34 91           177.917 /91 61         317.875 /35 89
> x = 64   326.837 /33 92           179.037 /90 62         320.615 /36 86

	    17348.850		    27400.458		   15973.776
	    13737.493		    18487.248		   12167.816
	    11057.004		    16080.750		   11623.661

	    17288.102		    27637.176		   16560.375
	    10356.52		    18482.584		   12504.702
	    10905.772		    16190.447		   11125.625
	    10785.621		    16113.330		   11542.140

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
