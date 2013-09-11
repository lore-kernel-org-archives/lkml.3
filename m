Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3IKQzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:55:31 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:64461 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3IKQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130911165018.GJ11427@tassilo.jf.intel.com>
References: <20130911152222.GA28761@google.com>
	<20130911165018.GJ11427@tassilo.jf.intel.com>
Date: Wed, 11 Sep 2013 18:55:28 +0200
Message-ID: <CABPqkBS3HvEGENHF0dKpOwhbQx0GBz4sT_PNFrXjxo4hYtEFtw@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: add constraint for IVB CYCLE_ACTIVITY:CYCLES_LDM_PENDING
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 6:50 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Wed, Sep 11, 2013 at 08:22:22AM -0700, Stephane Eranian wrote:
>>
>> The IvyBridge event CYCLE_ACTIVITY:CYCLES_LDM_PENDING can only
>> be measured on counters 0-3 when HT is off. When HT is on, you
>> only have counters 0-3.
>>
>> If you program it on the eight counters for 1s on a 3GHz
>> IVB laptop running a noploop, you see:
>>
>>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>>
>> Clearly the last 4 values are bogus.
>
> Thanks looks good.
>
> Likely need it on Haswell too?
>
Will check on that one later this week.
But I think you are right.

> -Andi
