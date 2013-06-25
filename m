Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab3FYMlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:41:00 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:42845 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3FYMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:40:59 -0400
MIME-Version: 1.0
In-Reply-To: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
Date: Tue, 25 Jun 2013 14:40:58 +0200
Message-ID: <CABPqkBRkE8z54a1gY00tmYkJ-4KHVv5XyLhvTCOUsDKVcQfP5w@mail.gmail.com>
Subject: Re: [PATCH 0/7] perf, x86: Haswell LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:47 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> Haswell has a new feature that utilizes the existing Last Branch Record
> facility to record call chains. When the feature is enabled, function
> call will be collected as normal, but as return instructions are executed
> the last captured branch record is popped from the on-chip LBR registers.
> The LBR call stack facility can help perf to get call chains of progam
> without frame pointer. When perf tool requests PERF_SAMPLE_CALLCHAIN +
> PERF_SAMPLE_BRANCH_USER, this feature is dynamically enabled by default.
> This feature can be disabled/enabled through an attribute file in the cpu
> pmu sysfs directory.
>
> The LBR call stack has following known limitations
>  1. Zero length calls are not filtered out by hardware
>  2. Exception handing such as setjmp/longjmp will have calls/returns not
>     match
>  3. Pushing different return address onto the stack will have calls/returns
>     not match
>
I would also add that it does not work with leaf call optimizations:
A calls B, B calls C, C returns to A

and that can be fairly common with small functions.
