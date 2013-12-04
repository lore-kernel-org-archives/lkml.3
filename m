Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3LDSsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:48:18 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46327 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3LDSsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:48:17 -0500
Message-ID: <529F78D4.10905@gmail.com>
Date: Wed, 04 Dec 2013 11:47:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Pavey, Nicholas" <npavey@akamai.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using perf to locate source of context switches
References: <CEC4D35C.A428%npavey@akamai.com>
In-Reply-To: <CEC4D35C.A428%npavey@akamai.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/13, 10:42 AM, Pavey, Nicholas wrote:
> NB: I have also used 'perf record -e cs -g -a -- sleep 2', while the

Add -c 1 to capture *all* context switch events.

perf script will show each event. perf report provides a histogram summary.

I have a time-history command for analyzing scheduling events. It is not 
yet in upstream code. You can try the code in this branch:

https://github.com/dsahern/linux/tree/perf-sched-timehist-3.11

Or download this version (requires Arnaldo's tree):
https://lkml.org/lkml/2013/11/18/555

David
