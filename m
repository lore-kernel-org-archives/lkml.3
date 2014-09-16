Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaIPWBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:01:11 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:40942 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIPWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:01:10 -0400
Message-ID: <1410904867.2447.9.camel@j-VirtualBox>
Subject: Re: [PATCH v2] locking/rwsem: Avoid double checking before try
 acquiring write lock
From: Jason Low <jason.low2@hp.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <dbueso@suse.de>, linux-kernel@vger.kernel.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, jason.low2@hp.com
Date: Tue, 16 Sep 2014 15:01:07 -0700
In-Reply-To: <541898C7.6070508@hurleysoftware.com>
References: <1410894118.2447.4.camel@j-VirtualBox>
	 <541898C7.6070508@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 16:08 -0400, Peter Hurley wrote:
> Hi Jason,
> 
> On 09/16/2014 03:01 PM, Jason Low wrote:
> > Commit 9b0fc9c09f1b checks for if there are known active lockers in
> > order to avoid write trylocking using expensive cmpxchg() when it
> > likely wouldn't get the lock.
> > 
> > However, a subsequent patch was added such that we directly check for
> > sem->count == RWSEM_WAITING_BIAS right before trying that cmpxchg().
> > Thus, commit 9b0fc9c09f1b now just adds extra overhead. This patch
> > deletes it.
> 
> It would be better to just not reload sem->count, and check the parameter
> count == RWSEM_WAITING_BIAS instead. The count parameter is a very recent
> load of sem->count (one of which is the latest exclusive read from an
> atomic operation), so likely to be just as accurate as a reload of
> sem->count without causing more cache line contention.

Hi Peter and Tim,

Yes, I also agree. I will send out a new patch with this update.

Thanks,
Jason

