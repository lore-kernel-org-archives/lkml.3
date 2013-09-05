Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3IENYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:24:07 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41387 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3IENYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:24:05 -0400
Message-ID: <522885DB.2090204@linux.vnet.ibm.com>
Date: Thu, 05 Sep 2013 21:23:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v2] KVM: mmu: allow page tables to be in read-only slots
References: <1378383714-9723-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1378383714-9723-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090513-0260-0000-0000-0000039394D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 08:21 PM, Paolo Bonzini wrote:
> Page tables in a read-only memory slot will currently cause a triple
> fault when running with shadow paging, because the page walker uses
> gfn_to_hva and it fails on such a slot.
> 
> TianoCore uses such a page table.  The idea is that, on real hardware,
> the firmware can already run in 64-bit flat mode when setting up the
> memory controller.  Real hardware seems to be fine with that as long as
> the accessed/dirty bits are set.  Thus, this patch saves whether the
> slot is readonly, and later checks it when updating the accessed and
> dirty bits.
> 
> Note that this scenario is not supported by NPT at all, as explained by
> comments in the code.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

