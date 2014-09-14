Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaINOGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:06:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:12922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbaINOGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="385910171"
Date: Sun, 14 Sep 2014 07:06:39 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86_64: per-cpu memory for user-space
Message-ID: <20140914140639.GO5387@tassilo.jf.intel.com>
References: <20140913143534.16912.9015.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140913143534.16912.9015.stgit@zurg>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 06:35:34PM +0400, Konstantin Khlebnikov wrote:
> This patch implements user-space per-cpu memory in the same manner as in
> kernel-space: each cpu has its own %gs base address. On x86_64 %fs is used
> for thread local storage, %gs usually is free.
> 
> User-space application cannot prevent preemption but x86 read-modify-write
> operations are atomic against interrupts and context switches. Thus percpu
> counters, ring-buffer cursors, per-cpu locks and other cool things might
> be implemented in a very efficient way.

Do you have some concrete examples for the more complex operations?

It seems to me the limitation to a simple instruction will be very limiting
for anything more complicated than a counter. Also it's not even
clear how someone would implement retry (short of something like kuchannel)

Of course it wouldn't be a problem with TSX transactions, but it's not
clear they need it.

The other problem with the approach is, how would cpu hotplug
be handled?

> By the way, newer Intel cpus have even faster instructions for
> changing %fs/%gs, but they are still not supported by the kernel.

Patch kits are pending.

-Andi
