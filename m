Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaKLJ35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:29:57 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:53522 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaKLJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:28:31 -0500
Date: Wed, 12 Nov 2014 10:28:24 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: compiler bug gcc4.6/4.7 with ACCESS_ONCE and workarounds
Message-ID: <20141112102824.55a4c178@mschwide>
In-Reply-To: <CA+55aFw+cLJ6xW0Wk6nMbK+e1yr2KGCWN+-v2a7xK1u8zTtDtA@mail.gmail.com>
References: <1415360716-9670-2-git-send-email-borntraeger@de.ibm.com>
	<54611D86.4040306@de.ibm.com>
	<CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
	<54627CBF.2000704@de.ibm.com>
	<CA+55aFz1oxCgZiY4oWu41fFUbKft9g5_gQXXzAKuW8+pnR72Vw@mail.gmail.com>
	<CA+55aFw+cLJ6xW0Wk6nMbK+e1yr2KGCWN+-v2a7xK1u8zTtDtA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111209-0005-0000-0000-0000020C3617
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014 16:36:06 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Nov 11, 2014 at 4:33 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I guess as a workaround it is fine, as long as we don't lose sight of
> > trying to eventually do a better job.
> 
> Oh, and when it comes to the actual gcc bug - do you have any reason
> to believe that it's somehow triggered more easily by something
> particular in the arch/s390/kvm/gaccess.c code?
> 
> IOW, why does this problem not hit the x86 spinlocks that also use
> volatile pointers to aggregate types? Or does it?

This looks similiar to what we had on s390:

	old.tickets = ACCESS_ONCE(lock->tickets)

In theory x86 should be affected as well. On s390 we have lots of
instruction that operate on memory and the cost model of gcc makes
the compiler more inclined to access memory multiple times. My
guess would be that once the value is cached in a register the
cost model for x86 will usually make sure that the value is not
read a second time. But this is no guarantee.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

