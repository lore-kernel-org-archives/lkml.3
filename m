Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab3BUSfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:35:40 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53529 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab3BUSfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:35:39 -0500
Message-ID: <512668FA.5040505@sgi.com>
Date: Thu, 21 Feb 2013 12:35:38 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2013-02-19-17-20 uploaded
References: <20130220012122.870BB31C11E@corp2gmr1-1.hot.corp.google.com> <5125E809.4060407@codeaurora.org> <20130221181811.GA27097@gulag1.americas.sgi.com> <51266721.5060006@codeaurora.org>
In-Reply-To: <51266721.5060006@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 12:27 PM, Stephen Boyd wrote:
> On 2/21/2013 10:18 AM, Nathan Zimmer wrote:
>> On Thu, Feb 21, 2013 at 01:25:29AM -0800, Stephen Boyd wrote:
>>> On 2/19/2013 5:21 PM, akpm@linux-foundation.org wrote:
>>>> * timer_list-split-timer_list_show_tickdevices.patch
>>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
>>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
>>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch
>>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
>>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
>>> These commits seem to break the timer list on devices with maxcpus !=
>>> nr_cpu_ids, which is possible if you specify maxcpus on the kernel
>>> command line. I no longer see the percpu devices that I normally have
>>> after the broadcast device.
>> Interesting.
>> However I can't seem to boot at the moment with maxcpus set to less then the actual
>> number of cpus so I am not having much luck investigating right now.
> It works well on ARM processors. I believe it still works on x86 devices
> as well. I suppose you can simulate it by offlining a CPU and then
> reading the file.
Thanks I am seeing the failure now.
> This comment is useful around the cpumask functions.
>
>      Returns >= nr_cpu_ids if no further cpus set.
>
I had assumed it would be = nr_cpu_ids.
I will need to rethink the iterator.


Also I retested my other patches in the series, the ones for schedstat 
and sched_debug, and those worked fine.
