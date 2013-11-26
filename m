Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab3KZSIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:08:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab3KZSIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:08:42 -0500
Date: Tue, 26 Nov 2013 19:09:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Fix the hw_breakpoint range check
Message-ID: <20131126180941.GA18542@redhat.com>
References: <1385289171-3411-1-git-send-email-fweisbec@gmail.com> <1385289171-3411-3-git-send-email-fweisbec@gmail.com> <20131124134057.GA4531@pd.tnic> <20131125195028.GA10127@redhat.com> <20131125201134.GK6782@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125201134.GK6782@pd.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Borislav Petkov wrote:
>
> On Mon, Nov 25, 2013 at 08:50:28PM +0100, Oleg Nesterov wrote:
> > This won't work if va + len overflows?
>
> Oh, right,
>
> > Perhaps we should makes this clear, and we can even check the overflow
> > in the generic code (iirc Linus suggested to do this).
>
> maybe something like
>
> 	((va + len - 1) >= TASK_SIZE) || ((va + len - 1) < va)

Yes. But again, it makes sense to do this in the caller. And kill
the stupid get_hbp_len(). And other cleanups.

But this patch just tries to fix the typo in the security check.

Oleg.

