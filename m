Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3KYULk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:11:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35127 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3KYULj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:11:39 -0500
Date: Mon, 25 Nov 2013 21:11:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Fix the hw_breakpoint range check
Message-ID: <20131125201134.GK6782@pd.tnic>
References: <1385289171-3411-1-git-send-email-fweisbec@gmail.com>
 <1385289171-3411-3-git-send-email-fweisbec@gmail.com>
 <20131124134057.GA4531@pd.tnic>
 <20131125195028.GA10127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131125195028.GA10127@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 08:50:28PM +0100, Oleg Nesterov wrote:
> This won't work if va + len overflows?

Oh, right,

> Perhaps we should makes this clear, and we can even check the overflow
> in the generic code (iirc Linus suggested to do this).

maybe something like

	((va + len - 1) >= TASK_SIZE) || ((va + len - 1) < va)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
