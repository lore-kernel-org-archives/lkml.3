Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3E0CCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:02:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58780 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3E0CCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:02:42 -0400
Message-ID: <51A2BEB5.9030900@linux.vnet.ibm.com>
Date: Mon, 27 May 2013 10:02:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 03/11] KVM: MMU: fast invalidate all pages
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130524202307.GA4525@amt.cnet>
In-Reply-To: <20130524202307.GA4525@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052701-7014-0000-0000-000003134C7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

On 05/25/2013 04:23 AM, Marcelo Tosatti wrote:

>> +static void kvm_zap_obsolete_pages(struct kvm *kvm)
>> +{
>> +	struct kvm_mmu_page *sp, *node;
>> +	LIST_HEAD(invalid_list);
>> +
>> +restart:
>> +	list_for_each_entry_safe_reverse(sp, node,
>> +	      &kvm->arch.active_mmu_pages, link) {
>> +		/*
>> +		 * No obsolete page exists before new created page since
>> +		 * active_mmu_pages is the FIFO list.
>> +		 */
>> +		if (!is_obsolete_sp(kvm, sp))
>> +			break;
> 
> Can you add a comment to list_add(x, active_mmu_pages) callsites
> mentioning this case?
> 
> Because it'll break silently if people do list_add_tail().

Sure, I will do it in the next version.

And i totally agree with Gleb's points that reply your other questions
in this patch.

Thank you all!

