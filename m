Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3EIN4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:56:33 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39989 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3EIN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:56:31 -0400
Message-ID: <518BAB0B.60401@gmail.com>
Date: Thu, 09 May 2013 07:56:27 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, jolsa@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com> <1368073909-8825-11-git-send-email-dsahern@gmail.com> <87obck7d8e.fsf@sejong.aot.lge.com>
In-Reply-To: <87obck7d8e.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 2:45 AM, Namhyung Kim wrote:
> On Wed,  8 May 2013 22:31:46 -0600, David Ahern wrote:
> [SNIP]
>> +static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
>> +{
>> +	struct itimerspec new_value;
>> +	struct timespec now;
>> +	int rc = -1;
>> +
>> +	kvm->timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
>> +	if (kvm->timerfd < 0) {
>> +		pr_err("timerfd_create failed\n");
>> +		goto out;
>> +	}
>> +
>> +	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0) {
>> +		pr_err("clock_gettime failed: %d\n", errno);
>> +		close(kvm->timerfd);
>> +		goto out;
>> +	}
>> +
>> +	new_value.it_value.tv_sec = now.tv_sec + kvm->display_time;
>> +	new_value.it_value.tv_nsec = now.tv_nsec;
>> +	new_value.it_interval.tv_sec = kvm->display_time;
>> +	new_value.it_interval.tv_nsec = 0;
>> +
>> +	if (timerfd_settime(kvm->timerfd, TFD_TIMER_ABSTIME,
>> +			    &new_value, NULL) != 0) {
>
> Looks like no need to use ABSTIME.

hmmm.... I did that for a reason. I forget why now. Let me poke around 
with it and see if I can remember.

David

