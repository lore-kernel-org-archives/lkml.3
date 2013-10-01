Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3JAWka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:40:30 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40280 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3JAWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:40:28 -0400
Date: Tue, 1 Oct 2013 18:40:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Helge Deller <deller@gmx.de>
Cc: Libin <huawei.libin@huawei.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in
 print_worker_info() before use
Message-ID: <20131001224023.GA28618@mtj.dyndns.org>
References: <20131001203520.GA8248@p100.box>
 <20131001204352.GA27149@mtj.dyndns.org>
 <524B364B.3010405@gmx.de>
 <20131001210348.GB27149@mtj.dyndns.org>
 <20131001210735.GA27867@mtj.dyndns.org>
 <524B4E0D.9050107@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524B4E0D.9050107@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 02, 2013 at 12:34:53AM +0200, Helge Deller wrote:
> Sure, probe_kernel_read() takes care that no segfaults will happen.
> Nevertheless, if we know that "pwq" might become NULL, why access pwq->wq at all?
>   struct pool_workqueue *pwq = NULL;
>   probe_kernel_read(&wq, &pwq>wq, sizeof(wq));
> 
> If you wouldn't have used probe_kernel_read() you would never code it 
> like that. That's what I meant when I wrote "clean coding" (aka "similar
> to what you would have done without probe_kernel_read()").

Because it is using probe_kernel_read() and such test wouldn't mean
anything?  It may be NULL, it may be 1 or full Fs.  NULL is just one
of many illegal pointers which may happen.  Why add code which doesn't
achieve anything when you're explicitly trying to access pointers
which you know could be invalid?  Why is that "clean"?  Is "if (p)
kfree(p)" cleaner than "kfree(p)"?

Thanks.

-- 
tejun
