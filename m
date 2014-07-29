Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaG2K5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:57:17 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:38280 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841AbaG2K5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:57:15 -0400
X-IronPort-AV: E=Sophos;i="5.00,987,1396972800"; 
   d="scan'208";a="33911083"
Message-ID: <53D826B6.6010804@cn.fujitsu.com>
Date: Tue, 29 Jul 2014 18:56:54 -0400
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, <gleb@kernel.org>, <mtosatti@redhat.com>,
        <nadav.amit@gmail.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v3 6/6] kvm, mem-hotplug: Reload L1's apic access page
 if it is migrated when L2 is running.
References: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com> <1406144530-23002-7-git-send-email-tangchen@cn.fujitsu.com> <53D36A51.1050000@web.de>
In-Reply-To: <53D36A51.1050000@web.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/26/2014 04:44 AM, Jan Kiszka wrote:
> On 2014-07-23 21:42, Tang Chen wrote:
>> This patch only handle "L1 and L2 vm share one apic access page" situation.
>>
>> When L1 vm is running, if the shared apic access page is migrated, mmu_notifier will
>> request all vcpus to exit to L0, and reload apic access page physical address for
>> all the vcpus' vmcs (which is done by patch 5/6). And when it enters L2 vm, L2's vmcs
>> will be updated in prepare_vmcs02() called by nested_vm_run(). So we need to do
>> nothing.
>>
>> When L2 vm is running, if the shared apic access page is migrated, mmu_notifier will
>> request all vcpus to exit to L0, and reload apic access page physical address for
>> all L2 vmcs. And this patch requests apic access page reload in L2->L1 vmexit.
> Shouldn't this patch come before we allow apic access page migration?
Yes, it should come before patch 5.

Thanks.
