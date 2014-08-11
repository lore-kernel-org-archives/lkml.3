Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaHKT6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:58:13 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:47592 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaHKT6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140811195659.GG3935@laptop>
References: <1407785233-32193-1-git-send-email-eranian@google.com>
	<20140811195659.GG3935@laptop>
Date: Mon, 11 Aug 2014 21:58:11 +0200
Message-ID: <CABPqkBTm=svpU+PJq93ku6JVk0kcCCMqh4jLw8bQKwe+Y5nneQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] perf/x86: simplify PEBS event constraint management
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 9:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Aug 11, 2014 at 09:27:09PM +0200, Stephane Eranian wrote:
>> This patchkit revamps the PEBS tables on most Intel CPUs, both simplifying
>> and fixing a couple of problems on Haswell processors:
>>  - All PEBS event supported
>>  - data address and data source is now reported correctly for all events
>>
>> We simplify the tables by using the fact that non-PEBS event when used
>> in PEBS mode do not generate any PEBS records , thus they are safe to use.
>> This helps simplify the PEBS event constraints because they do not need
>> to list all suported PEBS events anymore. They only need to list
>> the special PEBS events, such as precise store and load latency.
>> This avoid some issues where the kernel is missing some PEBS events.
>>
>> In V2, we cleanup some more the precise_datala() for store events.
>
> Ah, I just queued your v1, time to swap patches around I suppose :-)

Yeah, I cleanup some more based on more comments from Andi.
No more hardcoded event codes.
