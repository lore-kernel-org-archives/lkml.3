Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaCRMFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:05:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:2580 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaCRMFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:05:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,677,1389744000"; 
   d="scan'208";a="112433441"
Message-ID: <53283671.1030509@citrix.com>
Date: Tue, 18 Mar 2014 12:05:05 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>, <linux-kernel@vger.kernel.org>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: zram: zsmalloc calls sleeping function from atomic context
References: <20140317144358.GA374@swordfish.minsk.epam.com> <20140317160117.9bfbfdd5128d45a80f58070c@linux-foundation.org>
In-Reply-To: <20140317160117.9bfbfdd5128d45a80f58070c@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/14 23:01, Andrew Morton wrote:
> 
> OK, thanks.  David, there's our atomic unmap and there are probably
> others.  Converting a previously-atomic utility function into one which
> can sleep is going to be difficult.

I think we should drop these patches.  I think Fujitsu were doing
something particularly odd with an out-of-tree driver.

> Or can this code which vmaps 50GB be changed to unmap it in 16MB chunks
> via unmap_kernel_range(), with a cond_resched() in the loop?

This sounds like something the people from Fujitsu can explore.

David
