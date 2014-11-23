Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKWQdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:33:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60554 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbaKWQdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:33:02 -0500
Date: Sun, 23 Nov 2014 17:32:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Mason <clm@fb.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: New crashes walking proc with Saturday's git
Message-ID: <20141123163258.GB6436@pd.tnic>
References: <20141123010239.GA12691@ret.masoncoding.com>
 <1416758187.24312.12@mail.thefacebook.com>
 <20141123161120.GB7070@pd.tnic>
 <1416759411.24312.13@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416759411.24312.13@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 11:16:51AM -0500, Chris Mason wrote:
> It must be:
> 
> commit 6e998916dfe327e785e7c2447959b2c1a3ea4930
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Wed Nov 12 16:58:44 2014 +0100
> 
>    sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency
> 
> I'll do two runs to confirm, but it's the only related patch between rc5 and
> now.

Cool, let me know and I'll revert here too to verify. It might take a
while to confirm as it happens only during resume but I could try the
fork bomb if I must.

>From looking at it I'm not getting any smarter. We iterate over the
threads under a rcu_read_lock() so we should be protected. Unless the
sched changes have somehow effect on RCU grace periods but WTH do I
know... This is crazy code.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
