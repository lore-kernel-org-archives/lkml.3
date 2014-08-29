Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaH2NnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:43:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:60840 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbaH2NnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:43:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,424,1406592000"; 
   d="scan'208";a="166397410"
Message-ID: <5400836F.1090508@citrix.com>
Date: Fri, 29 Aug 2014 14:43:11 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/xen/evtchn.c: Check failure for evtchn_make_refcounted()
References: <53FF4702.9020509@gmail.com> <53FF4FA5.4050105@citrix.com> <5400817E.6060500@gmail.com>
In-Reply-To: <5400817E.6060500@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 14:34, Chen Gang wrote:
> 
> 
> On 8/28/14 23:49, David Vrabel wrote:
>> On 28/08/14 16:13, Chen Gang wrote:
>>> evtchn_make_refcounted() may return failure, so need process the failure
>>> case. In failure case, it need call unbind_from_irqhandler() just like
>>> evtchn_unbind_from_user() has done.
>>>
>>> irq_from_evtchn() must be OK when bind_evtchn_to_irqhandler() succeed,
>>> so need not check it again.
>>>
>>> Also still need remain the closing port code, because when the failure
>>> occurs, unbind_from_irqhandler() will not close port internally.
>>
>> None of the evtchn_make_refcounted() failures can occur since we know we
>> have a valid irq and info at the single call site.
>>
> 
> OK, thanks. I guess what you said is correct.
> 
> But only according to the code, for me, I am not quite sure about 'info'
> must be always valid. If bind_evtchn_to_irqhandler() succeeds, I can not
> find any related code to prove 'info' must be valid.
> 
>  - for a new irq, it will allocate 'info' for it.
> 
>  - but for an existing irq, the code assumes it may has no 'info'.
>    (so several areas check 'info' whether valid, although irq is OK).
> 
> So could you give some additional related proofs for it? And if 'info'
> must be always OK, can we remove all the related check about 'info'?

I'm not sure what you mean by an existing irq.  If it's an irq for an
event channel it will have had info set when it was allocated.  the
irq_mapping_update_lock protects against seeing partially setup irqs.

So, the checks for !info can be removed, yes.

David


