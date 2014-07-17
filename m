Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbaGQNd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:33:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29120 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932893AbaGQNdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:33:24 -0400
X-IronPort-AV: E=Sophos;i="5.00,909,1396972800"; 
   d="scan'208";a="33410859"
Message-ID: <53C7D0DC.1020001@cn.fujitsu.com>
Date: Thu, 17 Jul 2014 21:34:20 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@minantech.com>
CC: Jan Kiszka <jan.kiszka@web.de>, <mtosatti@redhat.com>,
        <nadav.amit@gmail.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page
 in memory.
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com> <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com> <20140712080442.GH4399@minantech.com> <53C38D55.2040307@cn.fujitsu.com> <20140714145822.GK4399@minantech.com> <53C51608.4080109@web.de> <20140715120921.GT18167@minantech.com> <53C51E66.7030208@cn.fujitsu.com> <20140715124048.GU18167@minantech.com>
In-Reply-To: <20140715124048.GU18167@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On 07/15/2014 08:40 PM, Gleb Natapov wrote:
......
>>
>> And yes, we have the problem you said here. We can migrate the page while L2
>> vm is running.
>> So I think we should enforce L2 vm to exit to L1. Right ?
>>
> We can request APIC_ACCESS_ADDR reload during L2->L1 vmexit emulation, so
> if APIC_ACCESS_ADDR changes while L2 is running it will be reloaded for L1 too.
>

Sorry, I think I don't quite understand the procedure you are talking 
about here.

Referring to the code, I think we have three machines: L0(host), L1 and L2.
And we have two types of vmexit: L2->L1 and L2->L0.  Right ?

We are now talking about this case: L2 and L1 shares the apic page.

Using patch 5/5, when apic page is migrated on L0, mmu_notifier will 
notify L1,
and update L1's VMCS. At this time, we are in L0, not L2. Why cannot we 
update
the L2's VMCS at the same time ?  Is it because we don't know how many 
L2 vms
there are in L1 ?

And, when will L2->L1 vmexit happen ?  When we enforce L1 to exit to L0 by
calling make_all_cpus_request(), is L2->L1 vmexit triggered automatically ?

Thanks.
