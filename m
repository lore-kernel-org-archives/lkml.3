Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3JHRb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:31:59 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:35722 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3JHRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131008171522.GA29277@localhost>
References: <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
	<20131008171522.GA29277@localhost>
Date: Tue, 8 Oct 2013 10:31:57 -0700
X-Google-Sender-Auth: mjX4diNXkRtoo_cZMARPrtxMWFs
Message-ID: <CA+55aFzQC=W010GTxjXjBnsKO0CycXe7VZB+LTiNNtuBug_rbw@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel NULL pointer dereference at (null)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>, Jakub Jelinek <jakub@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 10:15 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> [   27.865982] Kernel BUG at c10563af [verbose debug info unavailable]

Ugh, you've turned off DEBUG_BUGVERBOSE.

We probably shouldn't even allow that. The space savings aren't worth the pain.

I'm not seeing the pattern in your oopses, there's at least three
different cases. At a guess, it's some lock - or a memory allocator -
that is broken by the bitop breakage, and then the oopses are just
fallout from that..

            Linus
