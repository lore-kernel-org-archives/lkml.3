Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3KLIHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:07:17 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49326 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3KLIHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:07:11 -0500
Message-ID: <5281E09B.3060303@linux.vnet.ibm.com>
Date: Tue, 12 Nov 2013 13:32:35 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mgorman@suse.de, dave@sr71.net, hannes@cmpxchg.org, tony.luck@intel.com,
        matthew.garrett@nebula.com, riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        amit.kachhap@linaro.org, thomas.abraham@linaro.org,
        markgross@thegnar.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <52442F6F.5020703@linux.vnet.ibm.com>
In-Reply-To: <52442F6F.5020703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111208-2000-0000-0000-00000E7FA374
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 06:28 PM, Srivatsa S. Bhat wrote:
> On 09/26/2013 05:10 AM, Andrew Morton wrote:
>> On Thu, 26 Sep 2013 04:56:32 +0530 "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>>> Experimental Results:
>>> ====================
>>>
>>> Test setup:
>>> ----------
>>>
>>> x86 Sandybridge dual-socket quad core HT-enabled machine, with 128GB RAM.
>>> Memory Region size = 512MB.
>>
>> Yes, but how much power was saved ;)
>>
> 
> I don't have those numbers yet, but I'll be able to get them going forward.
> 

Hi,

I performed experiments on an IBM POWER 7 machine and got actual power-savings
numbers (upto 2.6% of total system power) from this patchset. I presented them
at the Kernel Summit but forgot to post them on LKML. So here they are:

Hardware-setup:
--------------
IBM POWER 7 machine: 4 socket (NUMA), 32 cores, 128GB RAM

 - 4 NUMA nodes with 32 GB RAM each
 - Booted with numa=fake=1 and treated them as 4 memory regions


Software setup:
--------------
Workload: Run modified ebizzy for half an hour, which allocates and frees large
quantities of memory frequently. The modified ebizzy touches every allocated
page a number of times (4 times) before freeing it up. This ensures that
allocating a page in the "wrong" memory region makes it very costly in terms
of power-savings, since every allocated page is accessed before getting
freed (and accesses cause energy consumption). Thus, with this modified
benchmark, sub-optimal MM decisions (in terms of memory power-savings) get
magnified and hence become noticeable.


Power-savings compared to mainline (3.12-rc4):
---------------------------------------------
With this patchset applied, the average power of the system reduced by 2.6%
compared to the mainline kernel during the benchmark run. The total system
power is an excellent metric for such evaluations, since it brings out the
overall power-efficiency of the patchset. (IOW, if the patchset shoots up the
CPU or disk power-consumption while causing memory power savings, then the
total system power will not show much difference). So these numbers indicate
that the patchset performs quite well in reducing the power-consumption of
the system as a whole.

This is not the most ideal hardware configuration to test on, since I had
only 4 memory regions to play with, but this gives a good initial indication
of the kind of power savings that can be achieved with this patchset.

I am expecting the same patchset to give us power-savings of upto 5% of the
total system power on a newer prototype hardware that I have (since it has
more memory regions and lower base power consumption).


Regards,
Srivatsa S. Bhat

