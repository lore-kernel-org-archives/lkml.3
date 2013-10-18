Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3JRJvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:51:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24300 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3JRJvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:51:22 -0400
X-AuditID: cbfee68e-b7f486d0000040b6-08-526104901434
Message-id: <52610493.1000909@samsung.com>
Date: Fri, 18 Oct 2013 18:51:15 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: James Hogan <james.hogan@imgtec.com>,
        Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Protect read-modify-write of INTMASK with
 a lock
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
 <1381876762-10892-3-git-send-email-dianders@chromium.org>
 <525E611A.6070708@imgtec.com>
 <CAD=FV=V4OPOjs=4cvXOomt1UnzUdw5VApkNAX2ERKZ46DC6_gg@mail.gmail.com>
 <CAAG0J98c6eA_c2McSvFcQUMUfPy-DgdHi7Te1tZqpT8XjjMQvw@mail.gmail.com>
In-reply-to: <CAAG0J98c6eA_c2McSvFcQUMUfPy-DgdHi7Te1tZqpT8XjjMQvw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWyRsSkSHcCS2KQwe97MhaP1yxmsngwbxub
	xbytR1kttr/eyGZxdtlBNotXR34wWbyb94LZ4vKuOWwWR/73M1qcuv6ZzeLJmZmMFh/uX2S2
	WLXrD6MDr8fshossHjtn3WX36Nl5htHj0JW1jB5XTjSxekxeeJHZo2/LKkaPz5vkAjiiuGxS
	UnMyy1KL9O0SuDL29VkXHJWqaJm9hbmBsV20i5GTQ0LAROLsz4NsELaYxIV764FsLg4hgaWM
	Emc/vmSDKdq/8RcrRGIRo8T1XyuYIZzXjBIH/r4Cq+IV0JJY9GcuI4jNIqAqsbOthQXEZhPQ
	kdj+7ThTFyMHh6hAiMS3CTkQ5YISPybfAysREfCXWPxlAdgCZoFTzBJvOg+xgySEBSIklh+b
	zA6xbD2TxKUd39hABnEKBEscOQI2iBlo/v7WaWwQtrzE5jVvmSGunskhcWupPcQ9AhLfJh9i
	AWmVEJCV2HQAqkRS4uCKGywTGMVmITlpFpKps5BMXcDIvIpRNLUguaA4Kb3ISK84Mbe4NC9d
	Lzk/dxMjMJ5P/3vWt4Px5gHrQ4zJQCsnMkuJJucD00FeSbyhsZmRhamJqbGRuaUZacJK4rxq
	LdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhg3BRSF9z7dvjgx5NG9rE3e07mtKiec3PdI
	iLGhwPLRglNiPb0CbTMmzP/cf7orT3+aeJpR1eLl3xgulnLN2mZzK2HZNJtpL3RYVrXK8uje
	8svW69zK0H5Q5ewrjuSo6IjHSYyXk0wswwT9CqaXLn/dKc/VmD7/5zJh1V/MGwpnV2wUXhDG
	K6nEUpyRaKjFXFScCABZO/iI/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd0JLIlBBi0fhCwer1nMZPFg3jY2
	i3lbj7JabH+9kc3i7LKDbBavjvxgsng37wWzxeVdc9gsjvzvZ7Q4df0zm8WTMzMZLT7cv8hs
	sWrXH0YHXo/ZDRdZPHbOusvu0bPzDKPHoStrGT2unGhi9Zi88CKzR9+WVYwenzfJBXBENTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdraRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2NdnXXBUqqJl9hbmBsZ20S5GTg4J
	AROJ/Rt/sULYYhIX7q1n62Lk4hASWMQocf3XCmYI5zWjxIG/r9hAqngFtCQW/ZnLCGKzCKhK
	7GxrYQGx2QR0JLZ/O87UxcjBISoQIvFtQg5EuaDEj8n3wEpEBPwlFn9ZwAoyk1ngFLPEm85D
	7CAJYYEIieXHJrNDLFvPJHFpxzc2kEGcAsESR46ADWIGmr+/dRobhC0vsXnNW+YJjAKzkOyY
	haRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC08Uz6R2MqxosDjEKcDAq8fAe
	+BYfJMSaWFZcmXuIUYKDWUmE9/nfhCAh3pTEyqrUovz4otKc1OJDjMnAEJjILCWanA9MZXkl
	8YbGJmZGlkbmhhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwKh99tbzMMkrN/ap
	SL6alhrRXCHFtSNM3+bSjoh3m2W8X3z6tD7py1Z/7Y3bO1gXhgg3+N7J/3IsZX9KkciB9XtS
	72a4X1h46BPLywvTGCQ7VzW6nNkakxzNlHDZ5UK0aKHS5WK5M/9+mTNevVmcd2DNEiHfM/eK
	F0zgT9x5Pezo68dfm4KVftcpsRRnJBpqMRcVJwIAbxaldVsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 05:23 AM, James Hogan wrote:
> Hi Doug,
> 
> On 16 October 2013 17:43, Doug Anderson <dianders@chromium.org> wrote:
>> On Wed, Oct 16, 2013 at 2:49 AM, James Hogan <james.hogan@imgtec.com> wrote:
>>>> We can't just use the standard host->lock since that lock is not irq
>>>> safe and mmc_signal_sdio_irq() (called from interrupt context) calls
>>>> dw_mci_enable_sdio_irq().  Add a new irq-safe lock to protect INTMASK.
>>>>
>>>> An alternate solution to this is to punt mmc_signal_sdio_irq() to the
>>>> tasklet and then protect INTMASK modifications by the standard host
>>>> lock.  This seemed like a bit more of a high-latency change.
>>>
>>> A probably lighter-weight alternative to that alternative is to just
>>> make the existing lock irq safe. Has this been considered?
>>>
>>> I'm not entirely convinced it's worth having a separate lock rather than
>>> changing the existing one, but the patch still appears to be correct, so:
>>> Reviewed-by: James Hogan <james.hogan@imgtec.com>
>>
>> I did look at that alternate solution and rejected it, but am happy to
>> send that up if people think it's better.  Here's why I rejected it:
>>
>> 1. It looks like someone has gone through quite a bit of work to _not_
>> grab the existing lock in the IRQ handler.  The IRQ handler always
>> pushes all real work over to the tasklet.  I can only assume that they
>> did this for some good reason and I'd hate to switch it without
>> knowing for sure why.
>>
>> 2. We might have performance problems if we blindly changed the
>> existing code to an IRQ-safe spinlock.  We hold the existing
>> "host->lock" spinlock for the entire duration of
>> dw_mci_tasklet_func().  That's a pretty intense chunk of code, full of
>> nested loops (some with 500ms timeouts!), mdelay(20) calls to handle
>> some errors, etc.  I say "might" because I think that the expected
>> case is that code runs pretty quickly.  I ran some brief tests on one
>> system and saw a worst case time of 170us and an common case time of
>> ~10us.  Are we OK with having interrupts disabled for that long?  Are
>> we OK with having the dw_mci interrupt handler potentially spin on a
>> spinlock for that long?
>>
> 
> Fair enough, I'm convinced now. That code did look pretty heavy when I
> looked at it too.
> 
>>
>> I don't think it would be terrible to look at reworking the way that
>> dw_mmc handles interrupts, but that seems pretty major.
Yes, Reworking is pretty major.
but if we need to rework, i think we can rework it in future.
> 
> Yeh, I suppose at least the potentially large delays are all for
> exceptional cases, so it's not a critical problem.
> 
>> BTW: is the cost of an extra lock actually that high?
> 
> I don't know tbh. In this case the spinlock usage doesn't appear to
> actually overlap.
> 
>> ...or are you talking the cost in terms of code complexity?
> 
> In this case it'd only be a space and code complexity thing I think. I
> suppose in some cases the benefit of finer-grained locking is probably
> pretty marginal, but there's a good case for it here. It might be
> worth renaming the lock to irq_lock or something like that so it's
> clear it doesn't have to protect only for INTMASK in the future - up
> to you.
It seems good that use the irq_lock than intmask_lock. (It's just naming)
> 
> Cheers
> James
> 

