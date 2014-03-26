Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaCZFav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:30:51 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:34786 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaCZFat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:30:49 -0400
MIME-Version: 1.0
In-Reply-To: <533260AC.1050001@linux.vnet.ibm.com>
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<CAHqbYQuOM4CmJGR7aT7_b6XCoYtUvqHmhxYKynF5_ABW10LDVQ@mail.gmail.com>
	<CAHqbYQskGiDtmj_OmRnYn-ueu9GAfkNZvh1VX68oV1rzBrv8wg@mail.gmail.com>
	<533260AC.1050001@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 01:30:48 -0400
Message-ID: <CAHqbYQsRUmHhJMnPBa_5QhSvJ=89U0T0633R0jcxRwZy0ZNExg@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] KVM: x86: flush tlb out of mmu-lock after write protection
From: Hu Yaohui <loki2441@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guangrong,
Thanks a lot!
I will reopen a new discussion next time.
Does that means once the level 1 guest page table entry is modified,
the host should make a decision in page fault handler whether the page
sync or unsync?
My question is that since all level 1 guest page tables are writable,
when the entry in the page table is modified. there is no page fault
will happen, how can the mmu_need_write_protect to be called to make
whether sync or unsync decision?
Thanks for your time!

Best Wishes,
Yaohui

On Wed, Mar 26, 2014 at 1:07 AM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
> On 03/26/2014 12:40 PM, Hu Yaohui wrote:
>> Hi all,
>> I hope you have a good day!
>> I have debugged the code myself. I have called dump_stack() in
>> function "__kvm_unsync_page"
>> and function "invlpg".  Actually every time before invlpg is called,
>> the page fault handled will call "__kvm_unsync_page" before invlpg to
>> mark the specified sp as unsynced. (correct me if I am wrong). I am
>> wondering why there is a page fault. AFAIK when calling flush_tlb_page
>> in the guest os. it will issue invlpg instruction directly, I did not
>> see any operation which could always cause the page fault.I would
>> really appreciate if if someone could shed me some lights on it.
>> Thanks for your time!
>
> Page fault is used to map a page into guest and set the proper permission
> on for it so this is the right place to make decision if the page need be
> writable.
>
> Tlb flush is used when guest wants to have a clean tlb so that host syncs the
> unsync page tables when it is happing.
>
