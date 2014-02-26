Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaBZQzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:55:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaBZQzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:55:16 -0500
Date: Wed, 26 Feb 2014 17:55:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wait: WSTOPPED & ptrace fixes
Message-ID: <20140226165504.GA22677@redhat.com>
References: <20140220173838.GA21825@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220173838.GA21825@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Oleg Nesterov wrote:
>
> Tejun, unless I missed something WSTOPPED logic is broken if a process
> has a zombie/ptraced leader, "A zombie ptracee is only visible to its
> ptracer" is wrong in this case. Plus perhaps some cleanups make sense.

In fact it is broken even if it the child/tracee is single-threaded.

And I failed to find a simple fix which is not visible to user-space.
It would be nice if you can ack/nack at least the changelog in 1/2,
I mean the note about SIGNAL_STOP_CONTINUED.

And unless I missed something WEXITED is broken too, so I'll probably
send more changes.

Oleg.

