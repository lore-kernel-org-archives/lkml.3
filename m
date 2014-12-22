Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaLVQQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:16:55 -0500
Received: from sf2.bxl.stone.is ([5.134.1.239]:56786 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbaLVQQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:16:54 -0500
X-Greylist: delayed 2902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 11:16:53 EST
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <54983888.4030109@acm.org>
Date: Mon, 22 Dec 2014 16:28:08 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sabrina Dubroca <sd@queasysnail.net>,
        Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: e1000_netpoll(): disable_irq() triggers might_sleep() on linux-next
References: <20141029155620.GA4886@kria> <20141029180734.GQ12706@worktop.programming.kicks-ass.net> <alpine.DEB.2.11.1410291918060.5308@nanos> <20141029193603.GS12706@worktop.programming.kicks-ass.net> <20141202163530.GA19420@kria>
In-Reply-To: <20141202163530.GA19420@kria>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Filter-ID: s0sct1PQhAABKnZB5plbIYrcAt68paBzxGNV4bZScc8DDDH9IcRzs4ldqK5vEMwbuZt+PpRPW1h0
 yigPev+a+xPfldKzuJPXOtlQy6CerCucKeF7cnfEDaU4uWev4XxITtMxQ0r0fzIlxS2cy8YTUsFr
 pZdaq+BCu90GH4R8NZlq5nVSHx6HfgQ+mNfWMu0Xb4BcbCUUDkSDryyTxLFNrKWkIvD5dv0Ys3LQ
 YBKCmf23wL2Y4F0412ezGCyTUPanjX4dmbjHuB9XXavPbeVA0qbDNqfbnqFv/RRVV8+drYe2Z/+T
 EGTrNArD+yzRk5+QRS1SBS4NdDPZvgM0xf/+y4h3GtCkuzwckktRhAjm5EtxPmhbkLVdA524TTXf
 HKdzoJmRXV1dP/tOC4B0z0hUqa+Ln89F976wnGIs0GswJSnlgTl6fJxyntEfhZCKje4ZowN3TuKb
 dxely6NczQbrfOHXgQ9YVFCeKdQbUxRelTE37CgHhlCYKFAFYSG0HH07RdUb66pqYAGPsHnfde2g
 sQIUFW3nE6W+p6XUHoN9n2IRxcJV+m8q0YzC/hf5MMnnXIz52/8cMid9thISoDAJMOfnPadBpPx3
 4iZ7zgupsYUufA8kn04GPwlkALZGivcxme4bPsB8V7MXmgIm96hFx4TQGMbESva0q3Q4fBLCHBUD
 wx4T7HCAozCuhJa/y4NpS1gDIb/SxS3utuCf6KaitXtwiFqyNzRdU+uiDe6Y+N0suVaOsTohfZcZ
 Am3ZkGbkxAiP4a+8uTsHXBJe1gmXlWLvAuZiee2RvYPUH2waSBfV4KgKQZIRh6o7S04tDj2m9jih
 x+Za/cV70jOJzN2r4A==
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: IFrWXGses7OKB5S5G8/dJdIz5bb8V0ykx8BnFBnunHBA3cTUQ1R++keuE7RDJ8Kg3RbMLUalw1oC
 mj99/u+PoqoVy8a3lsStJtAvpObFX0Wok1JBYnOLzfRIhlEHQynLUpndEJ0YoaLytXXo8BMTaX2p
 Mk7LBarWD9Fj4R3eIu5cOy/3Wm9qfF/CZNvP/2Kowv61T+KDYyYtREgszdyFwv8IxCB3p/oCKvxr
 eyISh3JGb7OS5oVgiO+kDxZrVPLz3MmEGC2PrUKqLq5WmHK+Nw==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.02)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/14 17:35, Sabrina Dubroca wrote:
> Hello, sorry for the delay.
> 
> 2014-10-29, 20:36:03 +0100, Peter Zijlstra wrote:
>> On Wed, Oct 29, 2014 at 07:33:00PM +0100, Thomas Gleixner wrote:
>>> Yuck. No. You are just papering over the problem.
>>>
>>> What happens if you add 'threadirqs' to the kernel command line? Or if
>>> the interrupt line is shared with a real threaded interrupt user?
>>>
>>> The proper solution is to have a poll_lock for e1000 which serializes
>>> the hardware interrupt against netpoll instead of using
>>> disable/enable_irq().
>>>
>>> In fact that's less expensive than the disable/enable_irq() dance and
>>> the chance of contention is pretty low. If done right it will be a
>>> NOOP for the CONFIG_NET_POLL_CONTROLLER=n case.
>>>
>>
>> OK a little something like so then I suppose.. But I suspect most all
>> the network drivers will need this and maybe more, disable_irq() is a
>> popular little thing and we 'just' changed semantics on them.
>>
>> ---
>>  drivers/net/ethernet/intel/e1000/e1000.h      |  2 ++
>>  drivers/net/ethernet/intel/e1000/e1000_main.c | 22 +++++++++++++++++-----
>>  kernel/irq/manage.c                           |  2 +-
>>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> I've been running with variants of this patch, things seem ok.
> 
> As noted earlier, there are a lot of drivers doing this disable_irq +
> irq_handler + enable_irq sequence.  I found about 60.
> Many already take a lock in the interrupt handler, and look like we
> could just remove the call to disable_irq (example: cp_interrupt,
> drivers/net/ethernet/realtek/8139cp.c).
> 
> Here's how I modified your patch.  The locking compiles away if
> CONFIG_NET_POLL_CONTROLLER=n.
> 
> I can work on converting all the drivers from disable_irq to
> netpoll_irq_lock, if that's okay with you.
> 
> In igb there's also a synchronize_irq() called from the netpoll
> controller (in igb_irq_disable()), I think a similar locking scheme
> would work.
> I also saw a few disable_irq_nosync and disable_percpu_irq. These are
> okay?
> 
> [ ... ]

Hello,

Earlier today I ran into the bug mentioned at the start of this thread
with kernel 3.19-rc1 and the e1000e driver. Can anyone tell me what the
latest status is ?

Thanks,

Bart.
