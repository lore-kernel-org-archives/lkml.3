Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbaFLNmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:42:00 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:49144 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaFLNlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:41:55 -0400
Date: Thu, 12 Jun 2014 15:41:49 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: fs/stat: Reduce memory requirements for stat_open
Message-ID: <20140612134149.GC4296@osiris>
References: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061213-3548-0000-0000-00000019572C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:00:17PM +0200, Stefan Bader wrote:
> When reading from /proc/stat we allocate a large buffer to maximise
> the chances of the results being from a single run and thus internally
> consistent.  This currently is sized at 128 * num_possible_cpus() which,
> in the face of kernels sized to handle large configurations (256 cpus
> plus), results in the buffer being an order-4 allocation or more.
> When system memory becomes fragmented these cannot be guarenteed, leading
> to read failures due to allocation failures.
> 
> There seem to be two issues in play here.  Firstly the allocation is
> going to be vastly over sized in the common case, as we only consume the
> buffer based on the num_online_cpus().  Secondly, regardless of size we
> should not be requiring allocations greater than PAGE_ALLOC_COSTLY_ORDER
> as allocations above this order are significantly more likely to fail.
> 
> The following patch addesses both of these issues.  Does that make sense
> generally? It seemed to stop top complaining wildly for the reporter
> at least.

Hi Stefan,

see also https://lkml.org/lkml/2014/5/21/341

and one possible solution:

https://lkml.org/lkml/2014/5/30/191

and the other one:

https://lkml.org/lkml/2014/6/12/92
https://lkml.org/lkml/2014/6/12/107

Thanks,
Heiko

