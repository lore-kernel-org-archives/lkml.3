Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaIXKd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbaIXKdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:33:22 -0400
Date: Wed, 24 Sep 2014 11:42:15 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20140924104213.GA2695@agordeev.usersys.redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923205710.GB17332@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:57:10PM -0400, Tejun Heo wrote:
> Hmmm... how does it affect single device operation tho?  It does make
> individual interrupt handling heavier, no?

I think it is difficult to assess "individual interrupt handling", since
it depends from both the hardware and device access pattern. On the system
I use the results are rather counter-intuitive: ahci_thread_fn() does not
show up in perf report at all, nor ahci_single_irq_intr(). While before
the change ahci_single_irq_intr() reported 0.00%.

But since the handling is split in two parts it is rather incorrect to
apply the same metric to the threaded context. Obviously, the threaded
handler is expected slowed down by other interrupts handlers, but the
whole system should benefit from it, which is exactly the aim of this
change.

> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
