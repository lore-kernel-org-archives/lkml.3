Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3EPS0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:26:22 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46111 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3EPS0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:26:21 -0400
Message-ID: <519524C4.5060102@linux.vnet.ibm.com>
Date: Fri, 17 May 2013 02:26:12 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/8] KVM: MMU: fast zap all shadow pages
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130516233619.c85d66583e26c6f5d1b409e5@gmail.com>
In-Reply-To: <20130516233619.c85d66583e26c6f5d1b409e5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051618-5816-0000-0000-000008030EFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 10:36 PM, Takuya Yoshikawa wrote:
> On Thu, 16 May 2013 20:17:45 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Bechmark result:
>> I have tested this patchset and the previous version that only zaps the
>> pages linked on invalid slot's rmap. The benchmark is written by myself
>> which has been attached, it writes large memory when do pci rom read.
>>
>> Host: Intel(R) Xeon(R) CPU X5690  @ 3.47GHz + 36G Memory
>> Guest: 12 VCPU + 32G Memory
>>
>> Current code:           This patchset         Previous Version 
>> 2405434959 ns           2323016424 ns         2368810003 ns
>>
>> The interesting thing is, the previous version is slower than this patch,
>> i guess the reason is that the former keeps lots of invalid pages in mmu
>> which cause shadow page to be reclaimed due to used-pages > request-pages
>> or host memory shrink.
> 
> This patch series looks very nice!

Thank you, Takuya!

> 
> Minor issues may still need to be improved, but I really hope to see this
> get merged during this cycle.
> 
> [for the future]  Do you think that postponing some zapping/freeing of
> obsolete(already invalidated) pages to make_mmu_pages_available() time
> can improve the situation more?  -- say, for big guests.

Yes, i think it can. :)

We have made many efforts on this but still lack a straight way to
achieve it.

> 
> If accounting kept correct, make_mmu_pages_available() only needs to free
> some obsolete pages instead of valid pages.
> 

Yes.


