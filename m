Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaH2N35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:29:57 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37480 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaH2N3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:29:55 -0400
Message-ID: <5400817E.6060500@gmail.com>
Date: Fri, 29 Aug 2014 21:34:54 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/xen/evtchn.c: Check failure for evtchn_make_refcounted()
References: <53FF4702.9020509@gmail.com> <53FF4FA5.4050105@citrix.com>
In-Reply-To: <53FF4FA5.4050105@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/28/14 23:49, David Vrabel wrote:
> On 28/08/14 16:13, Chen Gang wrote:
>> evtchn_make_refcounted() may return failure, so need process the failure
>> case. In failure case, it need call unbind_from_irqhandler() just like
>> evtchn_unbind_from_user() has done.
>>
>> irq_from_evtchn() must be OK when bind_evtchn_to_irqhandler() succeed,
>> so need not check it again.
>>
>> Also still need remain the closing port code, because when the failure
>> occurs, unbind_from_irqhandler() will not close port internally.
> 
> None of the evtchn_make_refcounted() failures can occur since we know we
> have a valid irq and info at the single call site.
> 

OK, thanks. I guess what you said is correct.

But only according to the code, for me, I am not quite sure about 'info'
must be always valid. If bind_evtchn_to_irqhandler() succeeds, I can not
find any related code to prove 'info' must be valid.

 - for a new irq, it will allocate 'info' for it.

 - but for an existing irq, the code assumes it may has no 'info'.
   (so several areas check 'info' whether valid, although irq is OK).

So could you give some additional related proofs for it? And if 'info'
must be always OK, can we remove all the related check about 'info'?


> I would like to see this fixed by refactoring the code to remove
> evtchn_make_refcounted() by making all irqs for event channels reference
> counted.  These no need for this refcounting to be optional.
> 

If 'info' really must always be valid, what you said sounds reasonable
to me.


Thanks
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
