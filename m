Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3BGCcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 21:32:03 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60310 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3BGCb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 21:31:59 -0500
X-AuditID: 9c93016f-b7b1fae000006419-24-5113121d33e5
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 0/2] perf stat: add per processor socket count aggregation
References: <1360161962-9675-1-git-send-email-eranian@google.com>
Date: Thu, 07 Feb 2013 11:31:57 +0900
In-Reply-To: <1360161962-9675-1-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Wed, 6 Feb 2013 15:46:00 +0100")
Message-ID: <87fw18svky.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Wed,  6 Feb 2013 15:46:00 +0100, Stephane Eranian wrote:
> This patch adds per-processor socket count aggregation
> for system-wide mode measurements. This is a useful
> mode to detect imbalance between sockets for uniform
> workloads.
>
> To enable this mode, use --aggr-socket in addition
> to -a. (system-wide). This mode can be combined with
> interval printing.
>
> The output includes the socket number and the number
> of online processors on that socket. This is useful
> to gauge the amount of aggregation.
>
>  # ./perf stat -I 1000 -a --aggr-socket -e cycles sleep 2
>  #           time socket cpus             counts events
>       1.000097680 S0        4          5,788,785 cycles
>       2.000379943 S0        4         27,361,546 cycles
>       2.001167808 S0        4            818,275 cycles

Can it be genericized to support arbitrary cpu topology like per-core,
per-numa-node or something?

Thanks,
Namhyung
