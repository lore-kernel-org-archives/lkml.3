Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442Ab3DCCM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:12:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:52234 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab3DCCM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:12:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="288524597"
Message-ID: <515B9011.2000209@intel.com>
Date: Wed, 03 Apr 2013 10:12:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch v6 03/21] sched: only count runnable avg on cfs_rq's nr_running
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-4-git-send-email-alex.shi@intel.com> <CAKfTPtArivjSsVn=Xc_421oqo+mXUfMaXhfyATK+s=xXO+P3eA@mail.gmail.com> <515B7F99.3000407@intel.com> <CAPM31RKSUManoOO9QO5CafVGUHZGafekstF8Xx06pdBL+E93sQ@mail.gmail.com>
In-Reply-To: <CAPM31RKSUManoOO9QO5CafVGUHZGafekstF8Xx06pdBL+E93sQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 09:23 AM, Paul Turner wrote:
> Nack:
> Vincent is correct, rq->avg is supposed to be the average time that an
> rq is runnable; this includes (for example) SCHED_RT.
> 
> It's intended to be more useful as a hint towards something like a
> power governor which wants to know how busy the CPU is in general.

Thanks PJT&Vincent. agree with your thought.
> 
>> On the other side, periodic LB balance on combined the cfs/rt load, but
>> removed the RT utilisation in cpu_power.
> 
> This I don't quite understand; these inputs are already time scaled (by decay).
> 
> Stated alternatively, what you want is:
>   "average load" / "available power", which is:
>   (rq->cfs.runnable_load_avg + rq->cfs.blocked_load_avg) / (cpu power
> scaled for rt)

Right. understand,


-- 
Thanks Alex
