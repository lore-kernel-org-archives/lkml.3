Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaKTKr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:47:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaKTKr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:47:28 -0500
Date: Thu, 20 Nov 2014 10:47:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to
 p[te|md]_protnone_numa
Message-ID: <20141120104722.GL2725@suse.de>
References: <1416478790-27522-1-git-send-email-mgorman@suse.de>
 <1416478790-27522-4-git-send-email-mgorman@suse.de>
 <063D6719AE5E284EB5DD2968C1650D6D1C9F48CB@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9F48CB@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:38:56AM +0000, David Laight wrote:
> From:  Mel Gorman
> > Convert existing users of pte_numa and friends to the new helper. Note
> > that the kernel is broken after this patch is applied until the other
> > page table modifiers are also altered. This patch layout is to make
> > review easier.
> 
> Doesn't that break bisection?
> 

Yes, for automatic NUMA balancing at least. The patch structure is to
to make reviewers job easier and besides, bisecting within patches 2-6
is pointless. If desired, I can collapse patches 2-6 together for the
final submission.

-- 
Mel Gorman
SUSE Labs
