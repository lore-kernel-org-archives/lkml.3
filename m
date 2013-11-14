Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3KNUjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:39:07 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35745 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3KNUi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:38:59 -0500
Message-ID: <528534E0.3030209@gmail.com>
Date: Thu, 14 Nov 2013 13:38:56 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, mingo@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf kvm record: Change the default value of perf_guest
 to 0.
References: <1384465918-14085-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1384465918-14085-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/13, 2:51 PM, Dongsheng Yang wrote:
> Currently, we can not record the event counters of host to perf.data.host.
> Example:
>     perf kvm --host record -a sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.625 MB perf.data.guest (~27290 samples) ]

perf kvm by definition wants --guest enabled. Host profiling is done 
with just 'perf record'; no need for the kvm layer at all. If you really 
want to go through perf-kvm to record host events disable guest actions:

$ perf kvm --host --no-guest record -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.029 MB perf.data.host (~1255 samples) ]


David
