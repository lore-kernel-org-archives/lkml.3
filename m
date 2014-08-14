Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaHNFly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:41:54 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46197 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaHNFlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:41:52 -0400
Message-ID: <53EC4C17.4070806@linux.vnet.ibm.com>
Date: Thu, 14 Aug 2014 13:41:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Matlack <dmatlack@google.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
References: <1407819721-27833-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <CALzav=eZyM4_Y6yVoDnTZZUEbbF+T8WR_mSZa3h51FHs1uGBWQ@mail.gmail.com>
In-Reply-To: <CALzav=eZyM4_Y6yVoDnTZZUEbbF+T8WR_mSZa3h51FHs1uGBWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081405-5490-0000-0000-0000008E9D06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 05:18 AM, David Matlack wrote:
> On Mon, Aug 11, 2014 at 10:02 PM, Xiao Guangrong
> <xiaoguangrong@linux.vnet.ibm.com> wrote:
>> @@ -722,9 +719,10 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>>  {
>>         struct kvm_memslots *old_memslots = kvm->memslots;
>>
> 
> I think you want
> 
>   slots->generation = old_memslots->generation;
> 
> here.
> 
> On the KVM_MR_DELETE path, install_new_memslots is called twice so this
> patch introduces a short window of time where the generation number
> actually decreases.

Yes, indeed. Thank you for pointing it out, will update.

