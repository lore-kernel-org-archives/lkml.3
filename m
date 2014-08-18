Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaHRVdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:33:35 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48413 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaHRVdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:33:33 -0400
MIME-Version: 1.0
In-Reply-To: <53F26F0B.503@redhat.com>
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com>
 <53F24A49.2010807@redhat.com> <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com>
 <CALzav=fNoXeStA6ETDW0tNqyXBxWN0i8N5P-Ht7jtwgS_r7qmw@mail.gmail.com> <53F26F0B.503@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 18 Aug 2014 14:33:12 -0700
Message-ID: <CALzav=f22dDr2HgGeWZeVgBYXBX+mNBwQT0ZdiRfc7tNRTYCqg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Gleb Natapov <gleb@kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 2:24 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 18/08/2014 23:15, David Matlack ha scritto:
>> I just realized how simple Paolo's idea is. I think it can be a one line
>> patch (without comments):
>>
>> [...]
>>         update_memslots(slots, new, kvm->memslots->generation);
>>         rcu_assign_pointer(kvm->memslots, slots);
>>         synchronize_srcu_expedited(&kvm->srcu);
>> +       slots->generation++;
>>
>>         kvm_arch_memslots_updated(kvm);
>> [...]
>
> Yeah, you're right.  I think at this point it makes sense to put all
> generation handling in install_new_memslots, but with proper comments
> the above can do as well.
>
> Would you like to send it?  Patch 2 still applies on top.

Sure, I like doing everything in install_new_memslots() as well so I'll fix
that.
