Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab3CYVvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:51:21 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38329 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab3CYVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:51:19 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
	<20130325163844.042a45ba@annuminas.surriel.com>
	<CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
Date: Mon, 25 Mar 2013 14:51:19 -0700
Message-ID: <CANN689G5dGv2Hn2epbG8Pi8=bH=Lmz0hHxCS405FbPBvwDJ=gg@mail.gmail.com>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 2:42 PM, Michel Lespinasse <walken@google.com> wrote:
> I'll be surprised if it does, because we don't actually have single
> depth nesting here...
> Adding Peter & Ingo for advice about how to proceed
> (the one solution I know would involve using arch_spin_lock() directly
> to bypass the lockdep checks, but there's got to be a better way...)

Maybe spin_lock_nest_lock() can help too. I'm not sure, the feature is
undocumented.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
