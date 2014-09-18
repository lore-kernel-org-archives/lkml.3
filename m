Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaIRJ6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:58:21 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:38880 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaIRJ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:58:20 -0400
Date: Thu, 18 Sep 2014 11:58:13 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: minyard@acm.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] mips: Save all registers when saving the frame
Message-ID: <20140918095813.GA9804@linux-mips.org>
References: <1410903925-10744-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410903925-10744-1-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 04:45:25PM -0500, minyard@acm.org wrote:

> From: Corey Minyard <cminyard@mvista.com>
> 
> The MIPS frame save code was just saving a few registers, enough to
> do a backtrace if every function set up a frame.  However, this is
> not working if you are using DWARF unwinding, because most of the
> registers are wrong.  This was causing kdump backtraces to be short
> or bogus.
> 
> So save all the registers.

The stratey of partial and full stack frames was developed in '97 to bring
down the syscall overhead.  It certaily was very effective - it brought
down the syscall latency to the level of Alphas running at much higher
clock.

That certainly worked well back then for kernel 2.0 / 2.2.  But the syscall
code has become much more complex.  Since then support for 64 bit kernels,
two 32 bit ABIs running on a 64 bit kernels and numerous features that
changed the once simple syscall path have been implemented.  My gut feeling
is it might be worth to yank out the whole optimization to see how much
code complexity we get rid of in exchange for how much extra syscall
latency.

  Ralf
