Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3JAUoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:44:10 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:56724 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3JAUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:44:07 -0400
Date: Tue, 1 Oct 2013 16:43:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Helge Deller <deller@gmx.de>
Cc: Libin <huawei.libin@huawei.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in
 print_worker_info() before use
Message-ID: <20131001204352.GA27149@mtj.dyndns.org>
References: <20131001203520.GA8248@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001203520.GA8248@p100.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 01, 2013 at 10:35:20PM +0200, Helge Deller wrote:
> print_worker_info() includes no validity check on the pwq and wq
> pointers before handing them over to the probe_kernel_read() functions.
> 
> It seems that most architectures don't care about that, but at least on
> the parisc architecture this leads to a kernel crash since accesses to
> page zero are protected by the kernel for security reasons.
> 
> Fix this problem by verifying the contents of pwq and wq before usage.
> Even if probe_kernel_read() usually prevents such crashes by disabling
> page faults, clean code should always include such checks. 
> 
> Without this fix issuing "echo t > /proc/sysrq-trigger" will immediately
> crash the Linux kernel on the parisc architecture.

Hmm... um had similar problem but the root cause here is that the arch
isn't implementing probe_kernel_read() properly.  We really have no
idea what the pointer value may be at the dump point and that's why we
use probe_kernel_read().  If something like the above is necessary for
the time being, the correct place would be the arch
probe_kernel_read() implementation.  James, would it be difficult
implement proper probe_kernel_read() on parisc?

Thanks.

-- 
tejun
