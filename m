Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaKQLYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:24:55 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59176 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaKQLYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:24:54 -0500
Date: Mon, 17 Nov 2014 11:24:47 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] arm: perf: add support for heterogeneous PMUs
Message-ID: <20141117112447.GG18061@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:25:25PM +0000, Mark Rutland wrote:
> In systems with heterogeneous CPUs (e.g. big.LITTLE) the associated PMUs
> also differ in terms of the supported set of events, the precise
> behaviour of each of those events, and the number of event counters.
> Thus it is not possible to expose these PMUs as a single logical PMU.
> 
> Instead a logical PMU is created per CPU microarchitecture, which events
> can target directly:
> 
> $ perf stat \
>   -e armv7_cortex_a7/config=0x11/ \
>   -e armv7_cortex_a15/config=0x11/ \
>   ./test
> 
>  Performance counter stats for './test':
> 
>            7980455      armv7_cortex_a7/config=0x11/                                    [27.29%]
>            9947934      armv7_cortex_a15/config=0x11/                                    [72.66%]
> 
>        0.016734833 seconds time elapsed
> 
> This series is based atop of my recent preparatory rework [1,2].

Modulo the patches I commented on, the ARM perf bits look fine to me. For
those:

  Acked-by: Will Deacon <will.deacon@arm.com>

However, you need to get the event_filter_match change into the core code
before I can queue anything.

Will
