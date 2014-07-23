Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbaGWDPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:15:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:33565 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbaGWDPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:15:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565823139"
Message-ID: <53CF28BD.6050603@linux.intel.com>
Date: Wed, 23 Jul 2014 11:15:09 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>,
        "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
 in copy_params
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com> <20140722012352.GD6822@agk-dp.fab.redhat.com> <20140722020458.GE6822@agk-dp.fab.redhat.com>
In-Reply-To: <20140722020458.GE6822@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/22 10:04, Alasdair G Kergon wrote:
> On Tue, Jul 22, 2014 at 02:23:52AM +0100, Alasdair G Kergon wrote:
>> Unanswered.  Let's ask the same question in a different way:
>   
> A quick search for 'vold' returns:
>    https://android.googlesource.com/platform/system/vold/
> and the code there requests a fixed 64K allocation to hold the names of
> active volumes.
>
> So unlike libdevmapper-based applications where a smaller allocation is
> used at first and only extended if needed, Android just assumes that
> 64KB is enough for everyone.
>
> So is your claim that:
>
> 1. This 64KB allocation for the brief duration of the ioctl to store the
> names of active device-mapper volumes leads to memory problems?
> [Mustn't the system *already* be in a bad state if this pushes it over
> the limit?]

It's a good question.
1) Usually, Android mobile runs for a long time. It's very command that
users don't turn off the phones for months. Users might start lots of
applications. memory is used up in the end. Kernel might recollect memory
over and over again.
2) We never blames this Out of memory issue fully to DM.
3) We want to improve the OOM issue.

>
> and
>
> 2. The systems on which this memory shortage occurs have so many volumes
> (with long names?) that a smaller allocation would not suffice?

64K is small, comparing with 2GB, even 4GB total memory. However, this 64K
by kmalloc has a strict criteria. It might be continuous physical memory
and align with 64K. If memory is used up, freed memory is very fragmented.
Such 64K criteria is a hard request.
Usually, driver can allocate such memory at booting initialization. After
that, it should allocate many sparse pages instead of continuous memory.
Here 64K allocation is after booting.

Thanks for the kind comments.

Yanmin

