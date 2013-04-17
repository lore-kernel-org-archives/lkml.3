Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3DQBTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:19:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:31871 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab3DQBTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:19:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,488,1363158000"; 
   d="scan'208";a="323389551"
Message-ID: <516DF864.7070005@intel.com>
Date: Wed, 17 Apr 2013 09:18:28 +0800
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
References: <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic> <516A0652.8040505@intel.com> <20130414155925.GC20547@pd.tnic> <516B9859.70004@intel.com> <516B9B57.3030902@intel.com> <20130415095203.GA26524@pd.tnic> <516C059E.20800@intel.com> <20130415231206.GE12144@pd.tnic> <516C99BB.30309@intel.com> <20130416102405.GD5332@pd.tnic>
In-Reply-To: <20130416102405.GD5332@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 06:24 PM, Borislav Petkov wrote:
> On Tue, Apr 16, 2013 at 08:22:19AM +0800, Alex Shi wrote:
>> testing has a little variation, but the power data is quite accurate.
>> I may change to packing tasks per cpu capacity than current cpu
>> weight. that should has better power efficient value.
> 
> Yeah, this probably needs careful measuring - and by "this" I mean how
> to place N tasks where N is less than number of cores in the system.
> 
> I can imagine trying to migrate them all together on a single physical
> socket (maybe even overcommitting it) so that you can flush the caches
> of the cores on the other sockets and so that you can power down the
> other sockets and avoid coherent traffic from waking them up, to be one
> strategy. My supposition here is that maybe putting the whole unused
> sockets in a deep sleep state could save a lot of power.

Sure. Currently if the whole socket get into sleep, but the memory on
the node is still accessed. the cpu socket still spend some power on
'uncore' part. So the further step is reduce the remote memory access to
save more power, and that is also numa balance want to do.
And then the next step is to detect if this socket is cache intensive,
if there is much cache thresh on the node.
In theory, there is still has lots of tuning space. :)
> 
> Or not, who knows. Only empirical measurements should show us what
> actually happens.

Sure. :)
> 
> Thanks.
> 


-- 
Thanks Alex
