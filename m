Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaBNQJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:09:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaBNQJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:09:42 -0500
Date: Fri, 14 Feb 2014 17:08:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>
Cc: Richard Weinberger <richard@nod.at>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214160854.GA21011@redhat.com>
References: <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com> <20140212113928.GO18016@ZenIV.linux.org.uk> <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com> <20140212211421.GP18016@ZenIV.linux.org.uk> <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com> <20140212214411.GQ18016@ZenIV.linux.org.uk> <20140213205146.GS18016@ZenIV.linux.org.uk> <20140214132503.GA23265@infradead.org> <52FE1A3A.9090301@nod.at> <20140214152028.GT18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214152028.GT18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Al Viro wrote:
>
> BTW, Oleg, could you explain why does PTRACE_PEEK_SIGINFO copy ->si_code
> separately?  IOW, why do we want the upper 16 bits of ->si_code exposed?
> It used to be a strictly internal thing IIRC (it's been what, 2.3.late?)

Yes, but checkpoint/restart tools want to dump/restore the internal part
of ->si_code too.

See also the "task_pid_vnr(current) == pid" hack in do_rt_sigqueueinfo(),
this allows to queue a SI_FROMKERNEL() siginfo.

Oleg.

