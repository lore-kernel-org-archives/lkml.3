Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaJBQl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:41:57 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:43811 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaJBQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <1412256558-9995-3-git-send-email-mgorman@suse.de>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
	<1412256558-9995-3-git-send-email-mgorman@suse.de>
Date: Thu, 2 Oct 2014 09:41:54 -0700
X-Google-Sender-Auth: XEworQ235lWpzhpJwyvIOl6IpxM
Message-ID: <CA+55aFy9mYJOFgxZu2G=qUHJt8EWR5eLFTnXECNPvvLYTtpzNQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm: migrate: Close race between migration completion
 and mprotect
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
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
> +
> +       /* Recheck VMA as permissions can change during migration started  */
> +       if (is_write_migration_entry(entry) && (vma->vm_flags & (VM_WRITE)))
>                 pte = pte_mkwrite(pte);

Side note: we have a "maybe_mkwrite()" helper for the VM_WRITE testing
case. So I'd almost do this as

        if (is_write_migration_entry(entry))
                pte = maybe_mkwrite(pte, vma);

instead.

              Linus
