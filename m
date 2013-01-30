Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3A3DXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:23:09 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41692 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3A3DXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:23:07 -0500
Message-ID: <51089210.2080705@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2013 11:22:56 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/12] KVM: MMU: simplify mmu_set_spte
References: <50FFB5A1.5090708@linux.vnet.ibm.com> <50FFB5E9.2010500@linux.vnet.ibm.com> <20130129002151.GB10814@amt.cnet> <51073A1C.1050600@linux.vnet.ibm.com> <20130129215345.GA27735@amt.cnet>
In-Reply-To: <20130129215345.GA27735@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013003-9574-0000-0000-00000664EE8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 05:53 AM, Marcelo Tosatti wrote:
> On Tue, Jan 29, 2013 at 10:55:24AM +0800, Xiao Guangrong wrote:
>> On 01/29/2013 08:21 AM, Marcelo Tosatti wrote:
>>> On Wed, Jan 23, 2013 at 06:05:29PM +0800, Xiao Guangrong wrote:
>>>> In order to detecting spte remapping, we can simply check whether the
>>>> spte has already been pointing to the pfn even if the spte is not the
>>>> last spte, for middle spte is pointing to the kernel pfn which can not
>>>> be mapped to userspace
>>>
>>> This check is detecting spte overwrite, when a large spte is replaced by 
>>> pointer to spte table.
>>>
>>> Can't see why check for different pfn is safe: only 'int level' can
>>> differ, and pfn be equivalent, for example.
>>
>> The 'u64 *sptep' must on the "int level" we want to set, that means:
>>  page_header(__pa(sptep)).role.level == "int level".
> 
> Right, then stick a comment there noting which cases that condition handles.
> Keep the current comment and add more.
> 

Okay.

>> We discussed this before :), the discussion can be found at:
>> http://marc.info/?l=kvm&m=135345057329427&w=2.
> 
> Note http://marc.info/?l=kvm&m=135345059929436&w=2, please take into
> account in the future.

Okay, i will make that patch more simpler in the next version.


