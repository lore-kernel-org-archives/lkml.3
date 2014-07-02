Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaGBPoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:44:09 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43942 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaGBPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140702153300.GM19781@tassilo.jf.intel.com>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
	<1403910612-8754-2-git-send-email-andi@firstfloor.org>
	<CABPqkBT1XC=mG-ZhjAcMOksdCgP-p3TSSAefi7XBOajMugBYZQ@mail.gmail.com>
	<20140702153300.GM19781@tassilo.jf.intel.com>
Date: Wed, 2 Jul 2014 17:44:05 +0200
Message-ID: <CABPqkBQvSGA2k4eSHg54k3i8cTotviuvY71RuSc=Rh0iuxaPxg@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 5:33 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> No, still needs to be INTEL_ALL_EVENT_CONSTRAINT(0x0, 0x1)
>> otherwise the get_event_constraint() test I mentioned previously will
>> fail, event with your ALL_FILTER mask.
>
> What events should fail? I verified all PEBS events and they work as expected.
>
Random events should not fail, they should go with precise and not generate
any samples. That's the whole point of the exercise.

perf record -a -e r6099:p sleep 1

>> > -       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
>> > -       INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
>> > -       INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
>> > -       INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
>> > -       INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
>> > -       INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
>> > -       INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
>> > -       INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
>> > -       INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
>> > +       INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
>> > +       INTEL_PST_CONSTRAINT(0x02cd, 0xf),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
>>
>> No, precise stores only work on counter 3, keep 0x8 here
>
> Good point.
>
>
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only
