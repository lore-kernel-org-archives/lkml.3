Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaCZEys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:54:48 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50799 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaCZEyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:54:17 -0400
Message-ID: <53325D90.80808@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 12:54:40 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Hu Yaohui <loki2441@gmail.com>
CC: Gleb Natapov <gleb@kernel.org>, avi.kivity@gmail.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] KVM: x86: flush tlb out of mmu-lock after write
 protection
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <CAHqbYQuOM4CmJGR7aT7_b6XCoYtUvqHmhxYKynF5_ABW10LDVQ@mail.gmail.com>
In-Reply-To: <CAHqbYQuOM4CmJGR7aT7_b6XCoYtUvqHmhxYKynF5_ABW10LDVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032604-6102-0000-0000-00000532E98D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A suggestion: please send a new mail to ask question, especially,
when your question is not related to the patches, so that others
will probably discover the topic and join the discussion.

On 03/26/2014 12:25 AM, Hu Yaohui wrote:
> Hi Guangrong,
> Since you have written in the kvm/mmu.txt.
> <quote>
> 
>   unsync:
>     If true, then the translations in this page may not match the guest's
>     translation.  This is equivalent to the state of the tlb when a pte is
>     changed but before the tlb entry is flushed.  Accordingly, unsync ptes
>     are synchronized when the guest executes invlpg or flushes its tlb by
>     other means.  Valid for leaf pages.
> 
> </quote>
> 
> This make sense to me, my question is when those unsync bits will be
> set? When the guest writes to the level 1 guest page tables, it will
> not cause a page fault. Those unsync bit is unlikely to be set when
> the entry is modified. (correct me if I am wrong).

The bit is set in mmu_need_write_protect() where the host makes decision
if the page need to be write-protected (!unsync) or to be unsynced.

