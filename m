Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3GRGB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:01:58 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36762 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229Ab3GRGB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:01:57 -0400
Message-ID: <51E784CB.1040402@linux.vnet.ibm.com>
Date: Thu, 18 Jul 2013 14:01:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: markus@trippelsdorf.de, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
References: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130718053154.GY11772@redhat.com>
In-Reply-To: <20130718053154.GY11772@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071805-0260-0000-0000-00000354612B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 01:31 PM, Gleb Natapov wrote:
> On Thu, Jul 18, 2013 at 12:52:37PM +0800, Xiao Guangrong wrote:
>> Currently, fast page fault tries to fix mmio page fault when the
>> generation number is invalid (spte.gen != kvm.gen) and returns to
>> guest to retry the fault since it sees the last spte is nonpresent
>> which causes infinity loop
>>
>> It can be triggered only on AMD host since the mmio page fault is
>> recognized as ept-misconfig
>>
> We still call into regular page fault handler from ept-misconfig
> handler, but fake zero error_code we provide makes page_fault_can_be_fast()
> return false.

Yes.

> 
> Shouldn't shadow paging trigger this too? I haven't encountered this on
> Intel without ept.

Since currently fast page fault only works for direct mmu. :)

