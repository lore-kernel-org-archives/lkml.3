Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3CVKEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:04:12 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47750 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3CVKEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:04:10 -0400
Message-ID: <514C2C11.1060004@linux.vnet.ibm.com>
Date: Fri, 22 Mar 2013 18:01:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130321222151.GA19821@amt.cnet> <514BBDC5.6090104@linux.vnet.ibm.com>
In-Reply-To: <514BBDC5.6090104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032209-5816-0000-0000-0000073A8F47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 10:11 AM, Xiao Guangrong wrote:

>> The modifications should be contained to kvm_mmu_get_page() mostly,
>> correct? (would also have to keep counters to increase SLAB freeing 
>> ratio, relative to number of outdated shadow pages).
> 
> Yes.
> 
>>
>> And then have codepaths that nuke shadow pages break from the spinlock,
> 
> I think this is not needed any more. We can let mmu_notify use the generation
> number to invalid all shadow pages, then we only need to free them after
> all vcpus down and mmu_notify unregistered - at this point, no lock contention,
> we can directly free them.

Sorry. This is wrong since after call ->release(), the memory will be
freed. zap-all-sp can not be delayed. Will think out a good way to handle this...


