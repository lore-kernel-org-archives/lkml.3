Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3BUS1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:27:47 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4152 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3BUS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:27:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,710,1355126400"; 
   d="scan'208";a="26137390"
Message-ID: <51266721.5060006@codeaurora.org>
Date: Thu, 21 Feb 2013 10:27:45 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2013-02-19-17-20 uploaded
References: <20130220012122.870BB31C11E@corp2gmr1-1.hot.corp.google.com> <5125E809.4060407@codeaurora.org> <20130221181811.GA27097@gulag1.americas.sgi.com>
In-Reply-To: <20130221181811.GA27097@gulag1.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/2013 10:18 AM, Nathan Zimmer wrote:
> On Thu, Feb 21, 2013 at 01:25:29AM -0800, Stephen Boyd wrote:
>> On 2/19/2013 5:21 PM, akpm@linux-foundation.org wrote:
>>> * timer_list-split-timer_list_show_tickdevices.patch
>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch
>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
>>> * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
>> These commits seem to break the timer list on devices with maxcpus !=
>> nr_cpu_ids, which is possible if you specify maxcpus on the kernel
>> command line. I no longer see the percpu devices that I normally have
>> after the broadcast device.
> Interesting.
> However I can't seem to boot at the moment with maxcpus set to less then the actual
> number of cpus so I am not having much luck investigating right now. 

It works well on ARM processors. I believe it still works on x86 devices
as well. I suppose you can simulate it by offlining a CPU and then
reading the file.

This comment is useful around the cpumask functions.

    Returns >= nr_cpu_ids if no further cpus set.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

