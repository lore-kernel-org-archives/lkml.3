Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaLOKIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:08:01 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48106 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaLOKH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:07:58 -0500
MIME-Version: 1.0
In-Reply-To: <1418221414-60110-2-git-send-email-dahi@linux.vnet.ibm.com>
References: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
	<1418221414-60110-2-git-send-email-dahi@linux.vnet.ibm.com>
Date: Mon, 15 Dec 2014 18:07:56 +0800
Message-ID: <CAFiDJ59Y9y4VrcVfyo8rrQV-NtM=1G=kQScBtEvnuC3MpXt0KA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] uaccess: add pagefault_count to thread_info
From: "LF.Tan" <lftan.linux@gmail.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, David.Laight@aculab.com,
        peterz@infradead.org, hughd@google.com, hocko@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:23 PM, David Hildenbrand
<dahi@linux.vnet.ibm.com> wrote:
> This patch adds the pagefault_count to the thread_info of all
> architectures. It will be used to count the pagefault_disable() levels
> on a per-thread basis.
>
> We are not reusing the preempt_count as this is per cpu on x86 and we want to
> demangle pagefault_disable() from preemption in the future.
>
> The new counter is added directly below the preempt_count, except for archs
> relying on a manual calculation of asm offsets - to minimize the changes.
>
Hi David

Is this patchset targeted for 3.19? If yes, then we need this for
arch/nios2 as well (new arch in 3.19).
