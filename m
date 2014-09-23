Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaIWU5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:57:32 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47065 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaIWU5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:57:13 -0400
Date: Tue, 23 Sep 2014 16:57:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20140923205710.GB17332@mtj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Sun, Sep 21, 2014 at 03:19:28PM +0200, Alexander Gordeev wrote:
> Split interrupt service routine into hardware context handler
> and threaded context handler. That allows to protect ports with
> individual locks rather than with a single host-wide lock and
> move port interrupts handling out of the hardware interrupt
> context.
> 
> Testing was done by transferring 8GB on two hard drives in
> parallel using command 'dd if=/dev/sd{a,b} of=/dev/null'. With
> lock_stat statistics I measured access times to ata_host::lock
> spinlock (since interrupt handler code is fully embraced with
> this lock). The average lock's holdtime decreased eight times
> while average waittime decreased two times.
> 
> Both before and after the change the transfer time is the same,
> while 'perf record -e cycles:k ...' shows 1%-4% CPU time spent
> in ahci_single_irq_intr() routine before the update and not even
> sampled/shown ahci_single_irq_intr() after the update.

Hmmm... how does it affect single device operation tho?  It does make
individual interrupt handling heavier, no?

Thanks.

-- 
tejun
