Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3EIIp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:45:58 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58435 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3EIIp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:45:56 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-a1-518b6241b92c
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, jolsa@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
	<1368073909-8825-11-git-send-email-dsahern@gmail.com>
Date: Thu, 09 May 2013 17:45:53 +0900
In-Reply-To: <1368073909-8825-11-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Wed, 8 May 2013 22:31:46 -0600")
Message-ID: <87obck7d8e.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 May 2013 22:31:46 -0600, David Ahern wrote:
[SNIP]
> +static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
> +{
> +	struct itimerspec new_value;
> +	struct timespec now;
> +	int rc = -1;
> +
> +	kvm->timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
> +	if (kvm->timerfd < 0) {
> +		pr_err("timerfd_create failed\n");
> +		goto out;
> +	}
> +
> +	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0) {
> +		pr_err("clock_gettime failed: %d\n", errno);
> +		close(kvm->timerfd);
> +		goto out;
> +	}
> +
> +	new_value.it_value.tv_sec = now.tv_sec + kvm->display_time;
> +	new_value.it_value.tv_nsec = now.tv_nsec;
> +	new_value.it_interval.tv_sec = kvm->display_time;
> +	new_value.it_interval.tv_nsec = 0;
> +
> +	if (timerfd_settime(kvm->timerfd, TFD_TIMER_ABSTIME,
> +			    &new_value, NULL) != 0) {

Looks like no need to use ABSTIME.

Thanks,
Namhyung
