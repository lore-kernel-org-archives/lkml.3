Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaCDD0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:26:19 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:33067 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaCDD0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:26:17 -0500
MIME-Version: 1.0
In-Reply-To: <1393902810.30648.36.camel@buesod1.americas.hpqcorp.net>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
	<20140303164002.02df915e12d05bb98762407f@linux-foundation.org>
	<1393894778.30648.29.camel@buesod1.americas.hpqcorp.net>
	<20140303172348.3f00c9df.akpm@linux-foundation.org>
	<1393900953.30648.32.camel@buesod1.americas.hpqcorp.net>
	<20140303191224.96f93142.akpm@linux-foundation.org>
	<1393902810.30648.36.camel@buesod1.americas.hpqcorp.net>
Date: Mon, 3 Mar 2014 19:26:16 -0800
X-Google-Sender-Auth: NLDaPXAR4pPEGEU7JqcWcgkXuso
Message-ID: <CA+55aFwsjHPe4CF009p_L6PyYdP=F2bzi9-Wm5T+O6XPOCS6fg@mail.gmail.com>
Subject: Re: [PATCH v4] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 7:13 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Yes, I shortly realized that was silly... but I can say for sure it can
> happen and a quick qemu run confirms it. So I see your point as to
> asking why we need it, so now I'm looking for an explanation in the
> code.

We definitely *do* have users.

One example would be ptrace -> access_process_vm -> __access_remote_vm
-> get_user_pages() -> find_extend_vma() -> find_vma_prev -> find_vma.

                    Linus
