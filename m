Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaKLR1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:27:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58012 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbaKLR1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:27:46 -0500
Date: Wed, 12 Nov 2014 18:27:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
 memory errors
Message-ID: <20141112172739.GH16807@pd.tnic>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
 <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
 <20141111114248.GD31490@pd.tnic>
 <20141112172057.GA8303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141112172057.GA8303@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 06:20:58PM +0100, Oleg Nesterov wrote:
> Sorry, I am a bit confused...
> 
> On 11/11, Borislav Petkov wrote:
> >
> > Roughly speaking, we want to be able to mark a task with the sign of
> > death and to kill it, if needed.
> 
> "it" is current, yes?

Yes.

> So I agree with Andy, task_work_add() can work and you can also pass
> paddr/restartable to the handler.

Yes, and it is much simpler than changing the entry.S glue to switch to
the kernel stack for our purposes.

> But,
> 
> > The important part is *before* it
> > gets to run again.
> 
> But it is already running? Perhaps you meant "before it returns to
> user-mode" ?

Right, it runs, while it does so, it triggers an MCE because it touches
some corrupted memory, we jump to the #MC handler and before we return
to user space, we kill that process.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
