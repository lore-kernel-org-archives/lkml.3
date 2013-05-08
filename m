Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3EHN4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:56:10 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:57331 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab3EHN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:56:08 -0400
Date: Wed, 8 May 2013 13:56:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tony Lindgren <tony@atomide.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] SLAB changes for v3.10
In-Reply-To: <20130508042422.GU28721@atomide.com>
Message-ID: <0000013e846d76c8-d376963d-e953-4eff-92ea-742ba09cdb98-000000@email.amazonses.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org> <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.08-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013, Tony Lindgren wrote:

> OK got it narrowed down to CONFIG_DEBUG_SPINLOCK=y causing the problem
> with commit 8a965b3b. Ain't nothing like bisecting and booting and then
> diffing .config files on top of that.
>
> > Without reverting 8a965b3b I'm getting:

The patch (commit 8a965b3baa89ffedc73c0fbc750006c631012ced) merely changed the sequence of
slab creation to address an issue in SLAB.

Hmmm.. But if KMALLOC_SHIFT_LOW is higher than 6 or 7 then the creation of
the non-power of two slab could be skipped as a result of the patch. But
we should not need them in those cases.

Can I see the kernel config?

What is the value of KMALLOC_SHIFT_LOW?

Can you figure out which kernel slab the function is trying to access?


