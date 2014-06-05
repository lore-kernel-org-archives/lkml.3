Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaFENga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:36:30 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:57788 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaFENg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140605080418.GH3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-5-git-send-email-eranian@google.com>
	<20140605080418.GH3213@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 16:36:28 +0300
Message-ID: <CAHzUATgam8qrma+B-d=9jOHpmmiwNwk-717roNY=ndbJAZefjw@mail.gmail.com>
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion infrastructure
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to indicate that the PMU needs to setup the
shared state struct which is called excl_cntrs.
That struct is allocated for all CPUs at first, and
then half of them are destroyed and their CPUs
made to point to their siblings struct.

So yes. EXCL is really related to HT.
It could be called HT_EXCL.

Will fix in V2.

On Thu, Jun 5, 2014 at 11:04 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 11:34:13PM +0200, Stephane Eranian wrote:
>> @@ -499,6 +530,7 @@ do {                                                                      \
>>   */
>>  #define PMU_FL_NO_HT_SHARING 0x1 /* no hyper-threading resource sharing */
>>  #define PMU_FL_HAS_RSP_1     0x2 /* has 2 equivalent offcore_rsp regs   */
>> +#define PMU_FL_EXCL_CNTRS    0x4 /* has exclusive counter requirements  */
>
> the EXLC thing is HT specific too, right? How about HT_EXCL or so?
>
>
