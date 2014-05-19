Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaESSQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:16:50 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56194 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaESSQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:16:47 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave@sr71.net,
        riel@redhat.com, mgorman@suse.de, aarcange@redhat.com
Subject: Re: [RFC, PATCH] mm: unified interface to handle page table entries on different levels?
In-Reply-To: <20140519002543.GA3899@node.dhcp.inet.fi>
References: <1400286785-26639-1-git-send-email-kirill.shutemov@linux.intel.com> <20140518234559.GG6121@linux.intel.com> <20140519002543.GA3899@node.dhcp.inet.fi>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 May 2014 23:46:32 +0530
Message-ID: <87fvk5k51b.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051918-6102-0000-0000-0000059C7A0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> On Sun, May 18, 2014 at 07:45:59PM -0400, Matthew Wilcox wrote:
>> On Sat, May 17, 2014 at 03:33:05AM +0300, Kirill A. Shutemov wrote:
>> > Below is my attempt to play with the problem. I've took one function --
>> > page_referenced_one() -- which looks ugly because of different APIs for
>> > PTE/PMD and convert it to use vpte_t. vpte_t is union for pte_t, pmd_t
>> > and pud_t.
>> > 
>> > Basically, the idea is instead of having different helpers to handle
>> > PTE/PMD/PUD, we have one, which take pair of vpte_t + pglevel.
>> 
>> I can't find my original attempt at this now (I am lost in a maze of
>> twisted git trees, all subtly different), but I called it a vpe (Virtual
>> Page Entry).
>> 
>> Rather than using a pair of vpte_t and pglevel, the vpe_t contained
>> enough information to discern what level it was; that's only two bits
>> and I think all the architectures have enough space to squeeze in two
>> more bits to the PTE (the PMD and PUD obviously have plenty of space).
>
> I'm not sure if it's possible to find a single free bit on all
> architectures. Two is near impossible.

On ppc64 we don't have any free bits.

>
> And what about 5-level page tables in future? Will we need 3 bits there?
> No way.

-aneesh

