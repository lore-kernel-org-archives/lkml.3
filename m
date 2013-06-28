Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3F1GAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:00:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:46399 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab3F1GAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,956,1363158000"; 
   d="scan'208";a="361858360"
Message-ID: <51CD2689.2020305@linux.intel.com>
Date: Fri, 28 Jun 2013 09:00:41 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Cody P Schafer <devel-lists@codyps.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v4 net-next] net: poll/select low latency socket support
References: <20130624072751.26134.78163.stgit@ladj378.jer.intel.com> <20130624072803.26134.41593.stgit@ladj378.jer.intel.com> <51CCD812.5090408@codyps.com> <51CCD906.6030902@codyps.com>
In-Reply-To: <51CCD906.6030902@codyps.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/2013 03:29, Cody P Schafer wrote:
> On 06/27/2013 05:25 PM, Cody P Schafer wrote:
>> On 06/24/2013 12:28 AM, Eliezer Tamir wrote:
>>> select/poll busy-poll support.
>>> ...
>>
>> I'm seeing warnings about using smp_processor_id() while preemptable
>> (log included below) due to this patch. I expect the use of
>> ll_end_time() -> sched_clock() here is triggering this.
>>
>> Apologies if this has already been noted.
>
> To be clear, given how sched_time() is used here the BUG appears
> invalid, but we need a way to mark this as OK for the smp_processor_id()
> checks so we don't get BUG spam.
>
Thanks for reporting this.

-Eliezer
