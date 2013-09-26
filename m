Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3IZSGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:06:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:17839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab3IZSGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:06:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,987,1371106800"; 
   d="scan'208";a="409925495"
Message-ID: <524477AC.9090400@linux.intel.com>
Date: Thu, 26 Sep 2013 11:06:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, srinivas.pandruvada@linux.intel.com,
        willy@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        santosh.shilimkar@ti.com, kosaki.motohiro@gmail.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, thomas.abraham@linaro.org,
        amit.kachhap@linaro.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <20130925234734.GK18242@two.firstfloor.org> <52438AA9.3020809@linux.intel.com> <20130925182129.a7db6a0fd2c7cc3b43fda92d@linux-foundation.org> <20130926015016.GM18242@two.firstfloor.org> <20130925195953.826a9f7d.akpm@linux-foundation.org> <524439D5.8020306@linux.vnet.ibm.com> <52445993.7050608@linux.intel.com> <52446841.2030301@linux.vnet.ibm.com>
In-Reply-To: <52446841.2030301@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>
>>>
>>> Arjan, are you referring to the fact that Intel/SNB systems can exploit
>>> memory self-refresh only when the entire system goes idle? Is that why
>>> this
>>> patchset won't turn out to be that useful on those platforms?
>>
>> no we can use other things (CKE and co) all the time.
>>
>
> Ah, ok..
>
>> just that we found that statistical grouping gave 95%+ of the benefit,
>> without the cost of being aggressive on going to a 100.00% grouping
>>
>
> And how do you do that statistical grouping? Don't you need patches similar
> to those in this patchset? Or are you saying that the existing vanilla
> kernel itself does statistical grouping somehow?

so the way I scanned your patchset.. half of it is about grouping,
the other half (roughly) is about moving stuff.

the grouping makes total sense to me.
actively moving is the part that I am very worried about; that part burns power to do
(and performance).... for which the ROI is somewhat unclear to me
(but... data speaks. I can easily be convinced with data that proves one way or the other)

is moving stuff around the 95%-of-the-work-for-the-last-5%-of-the-theoretical-gain
or is statistical grouping enough to get > 95% of the gain... without the cost of moving.


>
> Also, I didn't fully understand how NUMA policy will help in this case..
> If you want to group memory allocations/references into fewer memory regions
> _within_ a node, will NUMA policy really help? For example, in this patchset,
> everything (all the allocation/reference shaping) is done _within_ the
> NUMA boundary, assuming that the memory regions are subsets of a NUMA node.
>
> Regards,
> Srivatsa S. Bhat
>

