Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3KAJW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:22:27 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52355 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3KAJW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <20131101084329.GB19466@laptop.lan>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
	<20131101084329.GB19466@laptop.lan>
Date: Fri, 1 Nov 2013 02:22:25 -0700
Message-ID: <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 1:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> AFAICT this isn't correct at all. We used to protect the vma interval
> tree with the root lock, now we don't. All we've got left is the
> mmap_sem, but anon_vma chains can cross address-spaces and thus we're up
> some creek without no paddle.

Yes, that was my first thought as well (though I wanted to double
check at first).

I also want to point out that lately we've seen several changes sent
out that relax locking with no accompanying explanation of why the
relaxed locking would be safe. Please don't do that - having a lot of
performance data is worthless if you can't explain why the new locking
is safe. And I'm not asking to prove a negative ('lack of any possible
races') there, but at least in this case one could dig out why the
root anon vma locking was introduced and if they think that this
reason doesn't apply anymore, explain why...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
