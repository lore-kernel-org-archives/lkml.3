Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346Ab3DRDPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:15:49 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49476 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965089Ab3DRDPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:15:47 -0400
Message-ID: <516F6559.1020309@linux.vnet.ibm.com>
Date: Thu, 18 Apr 2013 11:15:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce invalid rmap handlers
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1366093973-2617-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130417233810.GD31059@amt.cnet>
In-Reply-To: <20130417233810.GD31059@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041803-6102-0000-0000-00000356E274
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 07:38 AM, Marcelo Tosatti wrote:
> On Tue, Apr 16, 2013 at 02:32:45PM +0800, Xiao Guangrong wrote:
>> Invalid rmaps is the rmap of the invalid memslot which is being
>> deleted, especially, we can treat all rmaps are invalid when
>> kvm is being destroyed since all memslot will be deleted soon.
>> MMU should remove all sptes on these rmaps before the invalid
>> memslot fully deleted
>>
>> The reason why we separately handle invalid rmap is we want to
>> unmap invalid-rmap out of mmu-lock to achieve scale performance
>> on intensive memory and vcpu used guest
> 
> Better try to make the code simpler, and introduce complexity only 
> if necessary.

Marcelo,

This code is necessary to implement "unmap invalid rmap out of mmu-lock",
the reason why we need it is that ...

> 
> The idea to zap the roots is very elegant and apparently effective. What
> are its problems?

I mentioned it in 00/15:

* Challenges
Some page invalidation is requested when memslot is moved or deleted
and kvm is being destroy who call zap_all_pages to delete all sp using
their rmap and lpage-info, after call zap_all_pages, the rmap and lpage-info
will be freed. So, we should implement a fast way to delete sp from the rmap
and lpage-info.


