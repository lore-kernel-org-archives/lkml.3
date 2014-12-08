Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaLHNZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:25:04 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:39496 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLHNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:25:02 -0500
Date: Mon, 8 Dec 2014 14:24:51 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: Re: [PATCH v1 1/5] uaccess: add pagefault_count to thread_info
Message-ID: <20141208142451.2d9c6cb9@thinkpad-w530>
In-Reply-To: <5485A3D2.3020404@de.ibm.com>
References: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
	<1417778289-51567-2-git-send-email-dahi@linux.vnet.ibm.com>
	<5485A3D2.3020404@de.ibm.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120813-0013-0000-0000-000002222FD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am 05.12.2014 um 12:18 schrieb David Hildenbrand:
> > This patch adds the pagefault_count to the thread_info of all
> > architectures. It will be used to count the pagefault_disable() levels
> > on a per-thread basis.
> > 
> > We are not reusing the preempt_count as this is per cpu on x86 and we want to
> > demangle pagefault_disable() from preemption in the future.
> > 
> > Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > ---
> >  arch/alpha/include/asm/thread_info.h      |  1 +
> >  arch/arc/include/asm/thread_info.h        |  1 +
> >  arch/arm/include/asm/thread_info.h        |  1 +
> >  arch/arm64/include/asm/thread_info.h      |  1 +
> >  arch/avr32/include/asm/thread_info.h      |  1 +
> >  arch/blackfin/include/asm/thread_info.h   |  1 +
> >  arch/c6x/include/asm/thread_info.h        |  1 +
> >  arch/cris/include/asm/thread_info.h       |  1 +
> >  arch/frv/include/asm/thread_info.h        |  1 +
> >  arch/hexagon/include/asm/thread_info.h    |  1 +
> >  arch/ia64/include/asm/thread_info.h       |  1 +
> >  arch/m32r/include/asm/thread_info.h       |  5 +++--
> >  arch/m68k/include/asm/thread_info.h       |  1 +
> >  arch/metag/include/asm/thread_info.h      |  1 +
> >  arch/microblaze/include/asm/thread_info.h |  1 +
> >  arch/mips/include/asm/thread_info.h       |  1 +
> >  arch/mn10300/include/asm/thread_info.h    |  1 +
> >  arch/openrisc/include/asm/thread_info.h   |  1 +
> >  arch/parisc/include/asm/thread_info.h     |  1 +
> >  arch/powerpc/include/asm/thread_info.h    |  1 +
> >  arch/s390/include/asm/thread_info.h       |  1 +
> >  arch/score/include/asm/thread_info.h      |  1 +
> >  arch/sh/include/asm/thread_info.h         |  1 +
> >  arch/sparc/include/asm/thread_info_32.h   | 20 +++++++++++---------
> >  arch/sparc/include/asm/thread_info_64.h   | 17 +++++++++--------
> 
> Maybe its easier to put the pagefault count at the end of the thread_info struct to make the patch smaller and easier to review for thoses architectures that have hand-maintained asm offsets? 

Jap, that's also what I asked for in my cover letter.

Right now I wanted to keep the new count close to the preempt_count and similar
on all archs.

So move it only on the "hand-maintained asm offset" archs or on all archs?

David

