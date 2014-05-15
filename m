Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaEOR3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:29:37 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55987 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaEOR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:29:35 -0400
Date: Thu, 15 May 2014 10:28:17 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org,
        dave.hansen@intel.com
Subject: Re: [PATCH V4 0/2] mm: FAULT_AROUND_ORDER patchset performance data
 for powerpc
In-Reply-To: <537479E7.90806@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.11.1405151026540.4664@eggly.anvils>
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com> <537479E7.90806@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Madhavan Srinivasan wrote:
> 
> Hi Ingo,
> 
> 	Do you have any comments for the latest version of the patchset. If
> not, kindly can you pick it up as is.
> 
> 
> With regards
> Maddy
> 
> > Kirill A. Shutemov with 8c6e50b029 commit introduced
> > vm_ops->map_pages() for mapping easy accessible pages around
> > fault address in hope to reduce number of minor page faults.
> > 
> > This patch creates infrastructure to modify the FAULT_AROUND_ORDER
> > value using mm/Kconfig. This will enable architecture maintainers
> > to decide on suitable FAULT_AROUND_ORDER value based on
> > performance data for that architecture. First patch also defaults
> > FAULT_AROUND_ORDER Kconfig element to 4. Second patch list
> > out the performance numbers for powerpc (platform pseries) and
> > initialize the fault around order variable for pseries platform of
> > powerpc.

Sorry for not commenting earlier - just reminded by this ping to Ingo.

I didn't study your numbers, but nowhere did I see what PAGE_SIZE you use.

arch/powerpc/Kconfig suggests that Power supports base page size of
4k, 16k, 64k or 256k.

I would expect your optimal fault_around_order to depend very much on
the base page size.

Perhaps fault_around_size would provide a more useful default?

Hugh
