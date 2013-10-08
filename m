Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3JHS7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3JHS7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:59:10 -0400
Date: Tue, 8 Oct 2013 20:51:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Richard Henderson <rth@twiddle.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131008185154.GA8258@redhat.com>
References: <20131005234430.GA22485@localhost> <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com> <20131008075151.GA15689@localhost> <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Linus Torvalds wrote:
>
> (not yet merged), see:
>
>     http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=0c44c2d0f459cd7e275242b72f500137c4fa834d

I do not really understand inline assembly constraints, but I'll ask
anyway.

	+#define __GEN_RMWcc(fullop, var, cc, ...) \
	+do { \
	+ asm volatile goto (fullop "; j" cc " %l[cc_label]" \
	+ : : "m" (var), ## __VA_ARGS__ \
	      ^^^^^^^^^

don't we need

	"+m" (var)

here?

Oleg.

