Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaLOQml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:42:41 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:47727 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaLOQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:42:32 -0500
Date: Mon, 15 Dec 2014 12:23:01 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "LF.Tan" <lftan.linux@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, David.Laight@aculab.com,
        peterz@infradead.org, hughd@google.com, hocko@suse.cz
Subject: Re: [PATCH v2 1/5] uaccess: add pagefault_count to thread_info
Message-ID: <20141215122301.0eac5f19@thinkpad-w530>
In-Reply-To: <CAFiDJ59Y9y4VrcVfyo8rrQV-NtM=1G=kQScBtEvnuC3MpXt0KA@mail.gmail.com>
References: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
	<1418221414-60110-2-git-send-email-dahi@linux.vnet.ibm.com>
	<CAFiDJ59Y9y4VrcVfyo8rrQV-NtM=1G=kQScBtEvnuC3MpXt0KA@mail.gmail.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121511-0021-0000-0000-00000222739B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Dec 10, 2014 at 10:23 PM, David Hildenbrand
> <dahi@linux.vnet.ibm.com> wrote:
> > This patch adds the pagefault_count to the thread_info of all
> > architectures. It will be used to count the pagefault_disable() levels
> > on a per-thread basis.
> >
> > We are not reusing the preempt_count as this is per cpu on x86 and we want to
> > demangle pagefault_disable() from preemption in the future.
> >
> > The new counter is added directly below the preempt_count, except for archs
> > relying on a manual calculation of asm offsets - to minimize the changes.
> >
> Hi David
> 
> Is this patchset targeted for 3.19? If yes, then we need this for
> arch/nios2 as well (new arch in 3.19).
> 

Hi,

Peter just showed my that there is some work ongoing on that
pagefault_disable() topic. So I am not sure if the arch-specific part of this
series is still relevant.

But thanks for the info!

David

