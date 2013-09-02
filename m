Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3IBJU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:20:28 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56353 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab3IBJU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:20:26 -0400
Message-ID: <5224584F.6010409@linux.vnet.ibm.com>
Date: Mon, 02 Sep 2013 17:20:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glin@suse.de,
        agraf@suse.de, brogers@suse.de, afaerber@suse.de, lnussel@suse.de,
        edk2-devel@lists.sf.net, stable@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090209-6102-0000-0000-0000041C44DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 08:41 PM, Paolo Bonzini wrote:
> Page tables in a read-only memory slot will currently cause a triple
> fault because the page walker uses gfn_to_hva and it fails on such a slot.
> 
> OVMF uses such a page table; however, real hardware seems to be fine with
> that as long as the accessed/dirty bits are set.  Save whether the slot
> is readonly, and later check it when updating the accessed and dirty bits.

Paolo, do you know why OVMF is using readonly memory like this?

AFAIK, The fault trigged by this kind of access can hardly be fixed by
userspace since the fault is trigged by pagetable walking not by the current
instruction. Do you have any idea to let uerspace emulate it properly?

