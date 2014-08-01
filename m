Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaHAKqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbaHAKqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:46:53 -0400
Message-ID: <53DB701B.9070900@redhat.com>
Date: Fri, 01 Aug 2014 06:46:51 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG cpufreq] Invalid argument on writing to scaling_governor
References: <20140801104314.GA741@localhost>
In-Reply-To: <20140801104314.GA741@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/01/2014 06:43 AM, Fengguang Wu wrote:
> Hi Prarit,
> 
> I noticed that commit dbcbfe6aa0d61ae5e13cab43b30802482007c199 ("cpufreq: hold
> policy->rwsem for duration of changing governors") will cause this problem:
> 
> root@nhm4 ~# echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
> -bash: echo: write error: Invalid argument
> 
> root@nhm4 ~# cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_available_governors
> conservative userspace powersave ondemand performance
> 

Rafael, this patch needs to be rejected based on my previous comments, most
notably Saravana was able to reproduce the original problem.  I'm going to wait
for his reproducer and see what I can do.

Thanks,

P.

> Thanks,
> Fengguang
> 
