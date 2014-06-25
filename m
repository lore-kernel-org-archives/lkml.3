Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaFYCVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:21:16 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:58604 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaFYCVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVifbWCohymLyCc6cxG7t9WCDLTbCWRZx8xyG3DOMFqKqg@mail.gmail.com>
References: <1401847955-3345-1-git-send-email-johunt@akamai.com>
	<20140623151121.44f17779004e94ab620b837c@linux-foundation.org>
	<53A8ADEC.6070406@akamai.com>
	<20140623155118.e2446a6110a9889454db2386@linux-foundation.org>
	<53A9899C.9040005@akamai.com>
	<alpine.DEB.2.02.1406241740330.22030@chino.kir.corp.google.com>
	<CAPDOMVifbWCohymLyCc6cxG7t9WCDLTbCWRZx8xyG3DOMFqKqg@mail.gmail.com>
Date: Tue, 24 Jun 2014 22:21:14 -0400
Message-ID: <CAPDOMVjn6SekFU-mGG+WUW=ESafZaKdDaGRNtJMOd8FTmfx-DA@mail.gmail.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
From: Nick Krause <xerofoify@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Josh Hunt <johunt@akamai.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I second David, there  is no reason for this if there is a bug due to
page allocation
failure it will be probably at the point of kernel panic or in the
trace statements
at panic.
Cheers Nick

On Tue, Jun 24, 2014 at 10:19 PM, Nick Krause <xerofoify@gmail.com> wrote:
>  I second David, this is no reason for this if there is a bug due to page
> allocation
> failure it will be probably at the point of kernel panic or in the trace
> statements
> at panic.
> Cheers Nick
>
>
> On Tue, Jun 24, 2014 at 8:45 PM, David Rientjes <rientjes@google.com> wrote:
>>
>> On Tue, 24 Jun 2014, Josh Hunt wrote:
>>
>> > Anyone you'd suggest adding to this thread to get other feedback about
>> > tracking page allocation failures? I could also spin up a patch and cc
>> > them.
>> >
>>
>> Page allocation failures happen all the time, mostly because of
>> large-order allocations (more than PAGE_ALLOC_COSTLY_ORDER) or allocations
>> done with GFP_ATOMIC where it's impossible to reclaim or compact memory to
>> allocate.  Because of this, they are fairly easy to trigger from userspace
>> without having to do much.
>>
>> Why would this qualify for a taint?  I have never debugged a kernel crash
>> that I traced back to an earlier page allocation failure and said "oh, if
>> I had only known about that page allocation failure earlier!".  If one of
>> them is going to cause an issue, it probably is at the point of the crash
>> and you shouldn't have to "investigate" much.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
