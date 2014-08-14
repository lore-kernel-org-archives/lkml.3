Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaHNGTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:19:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:48517 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaHNGTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:19:13 -0400
Message-ID: <1407997135.5490.58.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michaele@au1.ibm.com>
Date: Thu, 14 Aug 2014 16:18:55 +1000
In-Reply-To: <1407996977.5490.56.camel@pasglop>
References: <1407996977.5490.56.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-14 at 16:16 +1000, Benjamin Herrenschmidt wrote:
> Another interesting one in the "OMG" category is the series from Michael
> adding memory barriers to spin_is_locked(). That's also the result of many
> days of debugging to figure out why the semaphore code would occasionally
> crash in ways that made no sense. It ended up being some creative lock
> stacking that was defeated by the fact that our locks allow a load inside
> the locked section to be re-ordered with the load of the lock value itself
> (I'm still of two mind about whether to kill that once and for all by putting
> a heavier barrier back into our lock implementation...). The fixes come with
> a long explanation in the cset comments, feel free to read it if you feel
> like having a headache today.

Talking of which, I should have tagged that for stable... I'll forward them
separately when you've pulled.

Michael: If I miss this while I'm away next week, can you take care of it ?

Cheers,
Ben.


