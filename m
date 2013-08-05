Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3HERjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:39:17 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:37075 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3HERjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130805132948.GA14942@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130805132948.GA14942@redhat.com>
Date: Mon, 5 Aug 2013 10:39:15 -0700
X-Google-Sender-Auth: qJX02TvNBDFtSbvSe1jP06AQWns
Message-ID: <CA+55aFy61PbNZda8f+42T9e7TioWd+W1s70UA6h+xnARjX3usA@mail.gmail.com>
Subject: Re: Linux 3.11-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 6:29 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I never used wine, but I am puzzled anyway. This patch really looks
> like a simple and minor bugfix.

The patch is indeed trivial, but.. What's the locking here?

Afaik, ptrace_detach() by the parent can race with do_exit() by the
child, and they now _both_ do flush_ptrace_hw_breakpoint(). Or am I
wrong? We have that whole "get tasklist_lock for writing and then
check child->ptrace" logic there exactly due to that race, no?

That said, Felipe, can you double-check that it's not timing-related
in some subtle way, and test multiple times with just that commit
reverted (and not reverted) to make sure that it's 100% that one
single line by that particular commit? Because it does seem very
benign..

               Linus
