Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3ECF4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:56:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35175 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760451Ab3ECF4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:56:04 -0400
Message-ID: <5183516A.80301@linux.vnet.ibm.com>
Date: Fri, 03 May 2013 13:55:54 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: mtosatti@redhat.com, gleb@redhat.com, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/6] KVM: x86: introduce memslot_set_lpage_disallowed
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1367032402-13729-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130503111031.344825656c22e2c58f759cf1@gmail.com>
In-Reply-To: <20130503111031.344825656c22e2c58f759cf1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050305-0260-0000-0000-000002E71A18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 10:10 AM, Takuya Yoshikawa wrote:
> On Sat, 27 Apr 2013 11:13:18 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> It is used to set disallowed large page on the specified level, can be
>> used in later patch
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/x86.c |   53 ++++++++++++++++++++++++++++++++++-----------------
>>  1 files changed, 35 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 91dd9f4..52b4e97 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6917,12 +6917,45 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
>>  	}
>>  }
>>  
>> +static void memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
>> +					 unsigned long npages,
>> +					 int lpage_size, int lpages)
> 
> What this function does is to disable large page support for this slot
> as can be seen in the comment below.
> 
> Since setting lpage_info to something ("disallowed" ?) is an implementation
> detail, we'd better hide such a thing from the function name.
> 
> Taking into account that we have "kvm_largepages_enabled()", something like
> disable_largepages_memslot() may be a candidate.
> 

No.

kvm_largepages_enabled effects on largepages_enabled, it is not related
with this function. Actually, I really do not care the different between
"disallowed" and "disabled".


