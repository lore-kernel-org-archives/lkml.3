Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab3GZPdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:33:17 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:33750 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757340Ab3GZPdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:33:11 -0400
Date: Fri, 26 Jul 2013 08:33:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
Message-ID: <20130726083314.4e2e333f@jbarnes-desktop>
In-Reply-To: <51F1ED8F.40703@zytor.com>
References: <rddfy5e894xuv6d47gu7hbuh.1374804892449@email.android.com>
	<51F1ED8F.40703@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 20:31:27 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 07/25/2013 07:14 PM, Jesse Barnes wrote:
> > To clarify: it'll either be marked reserved or not listed at all in e820, which is why I did this early, before any other e820 stuff like the "RAM buffer" are allocated, and before we could use the iomem resource (or maybe we could even early per Linus? I'll check). 
> > 
> > Jesse
> 
> If it is marked reserved or not listed at all it is much less of an
> issue.  Reserved is in fact the correct thing; not listed at all really
> isn't very problematic in most cases.

Yeah the problems seem to fall into two categories:
  1) mmio space is allocated in this range:
     https://bugs.freedesktop.org/show_bug.cgi?id=66726
  2) range gets partially allocated to the "RAM buffer"
     https://bugs.freedesktop.org/show_bug.cgi?id=66844

Case (1) is the one that worries me.  I'm guessing it'll mainly be a
problem on machines where MMIO space is limited or somehow structured
such that PCI resources end up there when we allocate them.  Depending
on what gets put there and the decode priority, behavior may be poor.

Case (2) isn't harmful, but ends up causing our driver to skip stolen
memory initialization, because of the conflict.

Anyway I'll look at Linus's suggestion of reserving in the iomem
resource really early and roll in Chris's stuff if that doesn't work
out.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
