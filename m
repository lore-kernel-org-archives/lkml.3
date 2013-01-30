Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3A3DyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:54:00 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53667 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3A3Dx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:53:59 -0500
Message-ID: <5108994E.6060506@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2013 11:53:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 06/12] KVM: MMU: introduce a static table to map guest
 access to spte access
References: <50FFB5A1.5090708@linux.vnet.ibm.com> <50FFB658.6040205@linux.vnet.ibm.com> <20130125001550.GB22875@amt.cnet> <5101F207.6040603@linux.vnet.ibm.com> <20130129000715.GA10814@amt.cnet> <20130129010758.GA12132@amt.cnet>
In-Reply-To: <20130129010758.GA12132@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013003-1618-0000-0000-000003439B24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 09:07 AM, Marcelo Tosatti wrote:
> On Mon, Jan 28, 2013 at 10:07:15PM -0200, Marcelo Tosatti wrote:
>> On Fri, Jan 25, 2013 at 10:46:31AM +0800, Xiao Guangrong wrote:
>>> On 01/25/2013 08:15 AM, Marcelo Tosatti wrote:
>>>> On Wed, Jan 23, 2013 at 06:07:20PM +0800, Xiao Guangrong wrote:
>>>>> It makes set_spte more clean and reduces branch prediction
>>>>>
>>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>>> ---
>>>>>  arch/x86/kvm/mmu.c |   37 ++++++++++++++++++++++++++-----------
>>>>>  1 files changed, 26 insertions(+), 11 deletions(-)
>>>>
>>>> Don't see set_spte as being a performance problem?
>>>> IMO the current code is quite simple.
>>>
>>> Yes, this is not a performance problem.
>>>
>>> I just dislike this many continuous "if"-s in the function:
>>>
>>> if (xxx)
>>> 	xxx
>>> if (xxx)
>>> 	xxx
>>> ....
>>>
>>> Totally, it has 7 "if"-s before this patch.
>>>
>>> Okay, if you think this is unnecessary, i will drop this patch. :)
>>
>> Yes, please (unless you can show set_spte is a performance problem).
> 
> Same thing for spte fast drop: is it a performance problem? 

It does not fix a performance problem. The patch does optimization on the
noncrucial path and cleanup for the previous patch.

> 
> Please try to group changes into smaller, less controversial sets with 
> a clear goal:

Ah. I thought they are simple and most of them have been reviewed, so i putted
them into one group, now i know i made a mistake. ;)

> 
> - Debated performance improvement.
> - Cleanups (eg mmu_set_spte argument removal).
> - Bug fixes.
> - Performance improvements.

Okay. I will split the long series into these set:

Set 1 for improvement:
[PATCH v2 01/12] KVM: MMU: lazily drop large spte

Set 2 for cleanups:
[PATCH v2 02/12] KVM: MMU: cleanup mapping-level
[PATCH v2 07/12] KVM: MMU: remove pt_access in mmu_set_spte
[PATCH v2 08/12] KVM: MMU: cleanup __direct_map

Set 3 for simplifying set spte path:
[PATCH v2 03/12] KVM: MMU: simplify mmu_set_spte
[PATCH v2 04/12] KVM: MMU: simplify set_spte
[PATCH v2 05/12] KVM: MMU: introduce vcpu_adjust_access

Set 4 for fixing and unifying rmap walking
[PATCH v2 11/12] KVM: MMU: fix spte assertion
[PATCH v2 09/12] KVM: MMU: introduce mmu_spte_establish
[PATCH v2 10/12] KVM: MMU: unify the code of walking pte list
[PATCH v2 12/12] KVM: MMU: fast drop all spte on the pte_list

Thanks!

