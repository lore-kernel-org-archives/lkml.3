Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaHLGEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:04:00 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:62001 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaHLGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140812055626.GJ9918@twins.programming.kicks-ass.net>
References: <1407802290-619-1-git-send-email-andi@firstfloor.org>
	<20140812055626.GJ9918@twins.programming.kicks-ass.net>
Date: Tue, 12 Aug 2014 08:03:58 +0200
Message-ID: <CABPqkBT++yth87P=pGcKZ_HHcd9GUxBmDinBCsV21RfFnQeVHA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Use extended offcore mask on Haswell
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 7:56 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Aug 11, 2014 at 05:11:30PM -0700, Andi Kleen wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> HSW-EP has a larger offcore mask than the client Haswell CPUs.
>> It is the same mask as on Sandy/IvyBridge-EP. All of
>> Haswell was using the client mask, so some bits were missing.
>>
>> On the client parts some bits were also missing compared
>> to Sandy/IvyBridge, in particular the bits to match on a L4
>> cache hit.
>>
>> The Haswell core in both client and server incarnations
>> accepts the same bits (but some are nops), so we can use
>> the same mask.
>>
>> So use the snbep extended mask, which is a superset of the
>> client and the server, for all of Haswell.
>>
>> This allows specifying a number of extra offcore events, like
>> for example for HSW-EP.
>>
>> % perf stat -e cpu/event=0xb7,umask=0x1,offcore_rsp=0x3fffc00100,name=offcore_response_pf_l3_rfo_l3_miss_any_response/ true
>>
>> which were <not supported> before.
>>
>> v2: Post correct patch.
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> I seem to have this patch; so that means this is a repost right?
>
Think Andi said, it was a rebase. Just found time today to test it.
