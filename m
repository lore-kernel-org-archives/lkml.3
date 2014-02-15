Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaBOOrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 09:47:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbaBOOrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 09:47:00 -0500
Date: Sat, 15 Feb 2014 15:46:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215144635.GA16759@redhat.com>
References: <20140212042215.GN18016@ZenIV.linux.org.uk> <20140212054043.GB13997@dastard> <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com> <20140212113928.GO18016@ZenIV.linux.org.uk> <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com> <20140212211421.GP18016@ZenIV.linux.org.uk> <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com> <20140214161302.GA16416@infradead.org> <20140214161623.GU18016@ZenIV.linux.org.uk> <20140214161912.GB20909@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214161912.GB20909@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Christoph Hellwig wrote:
>
> Might aswell stick the discmiss into what was dequeue_signal_lock().
> Which at that point should get a saner name (maybe thread_dequeue_signal ?)
> and lose all argument except maybe task_struct

No, task_struct argument should die, I think. It is misleading.

spin_lock(tsk->sighand->siglock) is simply wrong unless tsk == current.

And dequeue_signal() assumes that tsk == current too, otherwise
recalc_sigpending() is wrong.

Oleg.

