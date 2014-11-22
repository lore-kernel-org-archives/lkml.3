Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaKVALQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:11:16 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:38457 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaKVALP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:11:15 -0500
Date: Fri, 21 Nov 2014 19:11:11 -0500
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141122001111.GA26007@htj.dyndns.org>
References: <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411210109460.6439@nanos>
 <20141121141332.GA8808@lerouge>
 <20141121162506.GA15461@htj.dyndns.org>
 <20141121214444.GB9198@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121214444.GB9198@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Fri, Nov 21, 2014 at 10:44:46PM +0100, Frederic Weisbecker wrote:
> I fear that enumerating and fix the existing issues won't be enough.
> We can't find all the code sites out there which rely on not being
> faulted.

Oh, sure but that can take some time so adding documentation in the
mean time probably isn't a bad idea.

> The best would be to fix that from the percpu allocator itself, or
> vmalloc.

I don't think there's much percpu allocator itself can do.  The
ability to grow dynamically comes from being able to allocate
relatively consistent layout among areas for different CPUs and pretty
much requires vmalloc area and it'd generally be a good idea to take
out the vmalloc fault anyway.

Thanks.

-- 
tejun
