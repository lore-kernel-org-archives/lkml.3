Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3LMGYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:24:34 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:45147 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3LMGYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:24:30 -0500
Date: Fri, 13 Dec 2013 10:24:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, PaX Team <pageexec@freemail.hu>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] mm: fix use-after-free in sys_remap_file_pages
Message-ID: <20131213062427.GH8167@moon>
References: <20131212220757.GA14928@www.outflux.net>
 <20131212224118.17a951c2@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212224118.17a951c2@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:41:18PM -0500, Rik van Riel wrote:
> 
> If the vma has been freed by the time the code jumps to the
> out label (because it was freed by a function called from
> mmap_region), surely it will also already have been freed
> by the time this patch dereferences it?
> 
> Also, setting vma = NULL to avoid the if (vma) branch at
> the out: label is unnecessarily obfuscated. Lets make things
> clear by documenting what is going on, and having a label
> after that dereference.

This patch is a bit easier to read, at least for me. And if
I understand the code flow right, the issue is due to
remap_file_pages -> mmap_region -> find_vma_links -> do_munmap.
