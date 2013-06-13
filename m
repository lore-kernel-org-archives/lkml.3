Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3FMCNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:13:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:30965 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab3FMCNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,855,1363158000"; 
   d="scan'208";a="349041348"
Message-ID: <51B92ACE.7000307@linux.intel.com>
Date: Thu, 13 Jun 2013 05:13:34 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donald.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, erdnetdev@gmail.com, bhutchings@solarflare.com,
        andi@firstfloor.org, hpa@zytor.com, eilong@broadcom.com,
        or.gerlitz@gmail.com, amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH net-next 1/2] net: remove NET_LL_RX_POLL config menue
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com> <20130611142428.17879.33582.stgit@ladj378.jer.intel.com> <20130612.151205.1822920389019274346.davem@davemloft.net> <20130612190103.1545e310@nehalam.linuxnetplumber.net>
In-Reply-To: <20130612190103.1545e310@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/2013 05:01, Stephen Hemminger wrote:
> On Wed, 12 Jun 2013 15:12:05 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
>
>> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> Date: Tue, 11 Jun 2013 17:24:28 +0300
>>
>>>   	depends on X86_TSC
>>
>> Wait a second, I didn't notice this before.  There needs to be a better
>> way to test for the accuracy you need, or if the issue is lack of a proper
>> API for cycle counter reading, fix that rather than add ugly arch
>> specific dependencies to generic networking code.
>
> This should be sched_clock(), rather than direct TSC access.
> Also any code using TSC or sched_clock has to be carefully audited to deal with
> clocks running at different rates on different CPU's. Basically value is only
> meaning full on same CPU.

OK,

If we covert to sched_clock(), would adding a define such as 
HAVE_HIGH_PRECISION_CLOCK to architectures that have both a high 
precision clock and a 64 bit cycles_t be a good solution?

(if not any other suggestion?)


