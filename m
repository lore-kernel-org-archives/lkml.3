Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab3BMQIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:08:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759820Ab3BMQIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:08:06 -0500
Date: Wed, 13 Feb 2013 17:06:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without
	removing them from a queue
Message-ID: <20130213160611.GA2649@redhat.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360768595-31943-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13, Andrey Vagin wrote:
>
> This patch adds a new ptrace request PTRACE_PEEKSIGINFO.
>
> This request is used to retrieve information about a signal with the
> specified sequence number. A siginfo_t structure is copied from the child
> to location data in the parent.
>
> The low 16 bits of addr contains a sequence number of signal in a queue.
> All other bits of addr is used for flags. Currently here is only one
> flag PTRACE_PEEK_SHARED for dumping signals from process-wide shared
> queue. If this flag is not set, a signal is read from a per-thread
> queue.  A result siginfo contains a kernel part of si_code which usually
> striped, but it's required for queuing the same siginfo back during
> restore of pending signals.
>
> If a signal with the specified sequence number doesn't exist, ptrace
> returns ENOENT.
>
> This functionality is required for checkpointing pending signals.

I thinks the patch is correct, and personally I like very much the fact
it is simple. Compared to misc signalfd hacks we discussed before.

Oleg.

