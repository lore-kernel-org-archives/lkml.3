Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbaKTTyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:54:09 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50893 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaKTTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:54:07 -0500
MIME-Version: 1.0
In-Reply-To: <1416478790-27522-3-git-send-email-mgorman@suse.de>
References: <1416478790-27522-1-git-send-email-mgorman@suse.de>
	<1416478790-27522-3-git-send-email-mgorman@suse.de>
Date: Thu, 20 Nov 2014 11:54:06 -0800
X-Google-Sender-Auth: nSHvSs04_oyxov732_5jCdXsEhs
Message-ID: <CA+55aFwV80r66w4RmtY-MAUGkwmfBJe+C5KFD3ZnNgYb_KbBpQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] mm: Add p[te|md] protnone helpers for use by NUMA balancing
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 2:19 AM, Mel Gorman <mgorman@suse.de> wrote:
> This is a preparatory patch that introduces protnone helpers for automatic
> NUMA balancing.

Oh, I hadn't noticed that you had renamed these things. It was
probably already true in your V1 version.

I do *not* think that "pte_protnone_numa()" makes sense as a name. It
only confuses people to think that there is still/again something
NUMA-special about the PTE. The whole point of the protnone changes
was to make it really very very clear that from a hardware standpoint,
this is *exactly* about protnone, and nothing else.

The fact that we then use protnone PTE's for numa faults is a VM
internal issue, it should *not* show up in the architecture page table
helpers.

I'm not NAK'ing this name, but I really think it's a very important
part of the whole patch series - to stop the stupid confusion about
NUMA entries. As far as the page tables are concerned, this has
absolutely _zero_ to do with NUMA.

We made that mistake once. We're fixing it. Let the naming *show* that
it's fixed, and this is "pte_protnone()".

The places that use this for NUMA handling might have a comment or
something. But they'll be in the VM where this matters, not in the
architecture page table description files. The comment would be
something like "if the vma is accessible, but the PTE is marked
protnone, this is a autonuma entry".

                    Linus
