Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab3KYTtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:49:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab3KYTtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:49:31 -0500
Date: Mon, 25 Nov 2013 20:50:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Fix the hw_breakpoint range check
Message-ID: <20131125195028.GA10127@redhat.com>
References: <1385289171-3411-1-git-send-email-fweisbec@gmail.com> <1385289171-3411-3-git-send-email-fweisbec@gmail.com> <20131124134057.GA4531@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131124134057.GA4531@pd.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic. Thanks for doing this ;)

On 11/24, Borislav Petkov wrote:
>
> On Sun, Nov 24, 2013 at 11:32:49AM +0100, Frederic Weisbecker wrote:
> >
> > -	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> > +	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
>
> Well, can't you simplify it even further?
>
> 	return (va + len - 1) >= TASK_SIZE;

This won't work if va + len overflows?

Perhaps we should makes this clear, and we can even check the overflow
in the generic code (iirc Linus suggested to do this).

But to me it would be better to add the generic helper, they all do
the same check. Even arch/powerpc/kernel/hw_breakpoint.c whch doesn't
look right. Or make it __weak, or turn it into
arch_check_bp_in_kernelspace(start, end).

Oleg.

