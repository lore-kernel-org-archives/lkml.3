Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaCZFHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:07:35 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38101 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaCZFHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:07:34 -0400
Message-ID: <533260AC.1050001@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 13:07:56 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Hu Yaohui <loki2441@gmail.com>
CC: Gleb Natapov <gleb@kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] KVM: x86: flush tlb out of mmu-lock after write
 protection
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <CAHqbYQuOM4CmJGR7aT7_b6XCoYtUvqHmhxYKynF5_ABW10LDVQ@mail.gmail.com> <CAHqbYQskGiDtmj_OmRnYn-ueu9GAfkNZvh1VX68oV1rzBrv8wg@mail.gmail.com>
In-Reply-To: <CAHqbYQskGiDtmj_OmRnYn-ueu9GAfkNZvh1VX68oV1rzBrv8wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032605-5140-0000-0000-000004C81916
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 12:40 PM, Hu Yaohui wrote:
> Hi all,
> I hope you have a good day!
> I have debugged the code myself. I have called dump_stack() in
> function "__kvm_unsync_page"
> and function "invlpg".  Actually every time before invlpg is called,
> the page fault handled will call "__kvm_unsync_page" before invlpg to
> mark the specified sp as unsynced. (correct me if I am wrong). I am
> wondering why there is a page fault. AFAIK when calling flush_tlb_page
> in the guest os. it will issue invlpg instruction directly, I did not
> see any operation which could always cause the page fault.I would
> really appreciate if if someone could shed me some lights on it.
> Thanks for your time!

Page fault is used to map a page into guest and set the proper permission
on for it so this is the right place to make decision if the page need be
writable.

Tlb flush is used when guest wants to have a clean tlb so that host syncs the
unsync page tables when it is happing.

