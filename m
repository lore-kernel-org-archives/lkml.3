Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3EXFx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:53:56 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50019 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3EXFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:53:54 -0400
Message-ID: <519F0068.5090403@linux.vnet.ibm.com>
Date: Fri, 24 May 2013 13:53:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] KVM: MMU: introduce kvm_mmu_prepare_zap_obsolete_page
References: <20130523055725.GA26157@redhat.com> <519DB372.3080803@linux.vnet.ibm.com> <20130523061818.GC26157@redhat.com> <519DB7D3.7030101@linux.vnet.ibm.com> <20130523073708.GE26157@redhat.com> <519DCA38.30200@linux.vnet.ibm.com> <20130523080922.GG26157@redhat.com> <519DF9F6.1060902@linux.vnet.ibm.com> <20130523123947.GO4725@redhat.com> <519E13B6.7060807@linux.vnet.ibm.com> <20130523155722.GJ26157@redhat.com> <519EFD15.2080109@linux.vnet.ibm.com>
In-Reply-To: <519EFD15.2080109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052405-5816-0000-0000-0000081CDC8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 01:39 PM, Xiao Guangrong wrote:

>>> if (kvm_mmu_prepare_zap_page(sp, list))
>>> 	hlist_del(sp->hlist);
>>>
>>> Or, i missed your suggestion?
>> My assumption is that we can leave obsolete shadow pages on hashtable
>> till commit_zap time.
> 
> Ah, i see.
> 
> Yes, i agree with your idea. I think we can only skip the obsolete-and-invalid
> page since the obsolete-but-unzapped page still affects the mmu's behaviour,
> for example, it can cause page write-protect, kvm_mmu_unprotect_page()
> can not work by skipping unzapped-obsolete pages.

kvm_mmu_unprotect_page() can work, we can skip obsolete pages too when detect
whether need to write-protect a page, it is easier to make the page become
writable when zapping obsolete pages.

Will update it following your idea, sorry for my noise.

