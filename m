Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaDAQVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:21:44 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:34428 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaDAQVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:21:41 -0400
MIME-Version: 1.0
In-Reply-To: <533AE518.1090705@redhat.com>
References: <20140331113442.0d628362@annuminas.surriel.com>
	<CA+55aFzG=B3t_YaoCY_H1jmEgs+cYd--ZHz7XhGeforMRvNfEQ@mail.gmail.com>
	<533AE518.1090705@redhat.com>
Date: Tue, 1 Apr 2014 09:21:40 -0700
X-Google-Sender-Auth: 0UOdhNy4tEnf176QxdNJJdObM18
Message-ID: <CA+55aFx9KYTV_N3qjV6S9uu6iTiVZimXhZtUa9UYRkNR9P-7RQ@mail.gmail.com>
Subject: Re: [PATCH] x86,mm: delay TLB flush after clearing accessed bit
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, shli@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 9:11 AM, Rik van Riel <riel@redhat.com> wrote:
>
> Memory pressure is not necessarily caused by the same process
> whose accessed bit we just cleared. Memory pressure may not
> even be caused by any process's virtual memory at all, but it
> could be caused by the page cache.

If we have that much memory pressure on the page cache without having
any memory pressure on the actual VM space, then the swap-out activity
will never be an issue anyway.

IOW, I think all these scenarios are made-up. I'd much rather go for
simpler implementation, and make things more complex only in the
presence of numbers. Of which we have none.

              Linus
