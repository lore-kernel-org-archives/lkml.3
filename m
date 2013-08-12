Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3HLPi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:38:28 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39272 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3HLPi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:38:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130812152957.GF23412@tassilo.jf.intel.com>
References: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
	<1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
	<20130812151632.GM27162@twins.programming.kicks-ass.net>
	<20130812152957.GF23412@tassilo.jf.intel.com>
Date: Mon, 12 Aug 2013 17:38:26 +0200
Message-ID: <CABPqkBSsuvfcPqZG4-sJMLDkv-FWUZ4YxT=2kWK+dkQgsaD2aA@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How about:

This patch adds support for the SNB-EP PCU uncore PMU extra_sel_bit
(bit 21) which is
missing from the documentation in Table-2.75 of Intel® Xeon® Processor
E5-2600 Product Family
Uncore Performance Monitoring Guide. It is referred to later in
Table-2.81. Without this
selection bit explicitly enabled by the kernel, some events such as
COREx_TRANSITION_CYCLES do not count correctly.



On Mon, Aug 12, 2013 at 5:29 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Mon, Aug 12, 2013 at 05:16:32PM +0200, Peter Zijlstra wrote:
>> On Wed, Aug 07, 2013 at 02:17:25PM +0800, Yan, Zheng wrote:
>> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
>> >
>> > PCU uncore event control register has a undocumented ev_sel_ext bit.
>> > The bit is needed by Andi's pmu-tools.
>>
>> Please provide documentation. Andi needing it isn't a good changelog (or
>> even reason).
>
> The bit is in the uncore guide, just not in the register documentation,
> but in the event descriptions.
>
> e.g. the PCU part calls it "Extra Select Bit"
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
