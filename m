Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaLCRUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:20:42 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44184 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaLCRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:20:40 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to p[te|md]_protnone_numa
In-Reply-To: <20141203155242.GE6043@suse.de>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de> <1416578268-19597-4-git-send-email-mgorman@suse.de> <1417473762.7182.8.camel@kernel.crashing.org> <87k32ah5q3.fsf@linux.vnet.ibm.com> <1417551115.27448.7.camel@kernel.crashing.org> <87lhmobvuu.fsf@linux.vnet.ibm.com> <20141203155242.GE6043@suse.de>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Dec 2014 22:50:35 +0530
Message-ID: <87d280bqfw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120317-4790-0000-0000-0000055C7436
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> On Wed, Dec 03, 2014 at 08:53:37PM +0530, Aneesh Kumar K.V wrote:
>> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
>> 
>> > On Tue, 2014-12-02 at 12:57 +0530, Aneesh Kumar K.V wrote:
>> >> Now, hash_preload can possibly insert an hpte in hash page table even if
>> >> the access is not allowed by the pte permissions. But i guess even that
>> >> is ok. because we will fault again, end-up calling hash_page_mm where we
>> >> handle that part correctly.
>> >
>> > I think we need a test case...
>> >
>> 
>> I ran the subpageprot test that Paul had written. I modified it to ran
>> with selftest. 
>> 
>
> It's implied but can I assume it passed? 

Yes.

-bash-4.2# ./subpage_prot 
test: subpage_prot
tags: git_version:v3.17-rc3-13511-g0cd3756
allocated malloc block of 0x4000000 bytes at 0x0x3fffb0d10000
testing malloc block...
OK
success: subpage_prot
-bash-4.2# 

