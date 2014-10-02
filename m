Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaJBQgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:36:15 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43182 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaJBQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <1412256558-9995-5-git-send-email-mgorman@suse.de>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
	<1412256558-9995-5-git-send-email-mgorman@suse.de>
Date: Thu, 2 Oct 2014 09:36:11 -0700
X-Google-Sender-Auth: rxKJJRjAVn6RFa0vYl6pbC7d9Kg
Message-ID: <CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 6:29 AM, Mel Gorman <mgorman@suse.de> wrote:
> This patch reverts 1ba6e0b50b ("mm: numa: split_huge_page: transfer the
> NUMA type from the pmd to the pte"). If a huge page is being split due
> a protection change and the tail will be in a PROT_NONE vma then NUMA
> hinting PTEs are temporarily created in the protected VMA.

So this is the particular bug I was worried about when tracing through the code.

Should I just apply this as-is? And mark it for stable, since this has
been around since 3.8 or so. It would seem to be a very safe change to
do, regardless of whether this is actually the issue that Dave and
maybe Sasha are seeing.

Sasha, I notice that you weren't on the cc for Mel's patches (probably
because you got added later to the other thread), but they were all
cc'd to lkml so you should see them there. Or I can forward them
separately.

            Linus
