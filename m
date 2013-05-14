Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3ENKvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:51:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,670,1363158000"; 
   d="scan'208";a="333806045"
Message-ID: <5192173C.1070808@intel.com>
Date: Tue, 14 May 2013 03:51:40 -0700
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dong Zhu <bluezhudong@gmail.com>
CC: Jacob Keller <Jacob.e.keller@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Matthew Vick <matthew.vick@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping policy
References: <20130511140219.GG8399@zhudong.nay.redhat.com> <518E7723.5010003@cogentembedded.com> <20130512142555.GI8399@zhudong.nay.redhat.com> <20130512172446.GA2484@netboy> <20130513021236.GJ8399@zhudong.nay.redhat.com> <20130513043140.GA2567@netboy> <20130513100742.GM8399@zhudong.nay.redhat.com> <20130514095155.GO8399@zhudong.nay.redhat.com>
In-Reply-To: <20130514095155.GO8399@zhudong.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 02:51 AM, Dong Zhu wrote:
> Hi,
>
>> I modified this patch and added the method to igb_get_ts_info function.
>> For 82576 nic, through this method we can easily check which type of packets
>> are time stamped now, such as (HWTSTAMP_FILTER_PTP_V1_L4_SYNC and
>> HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ), then change or disable it up to your requests.
>> I think it is convenient.The origial GET_TS_INFO method can only show the device’s
>> time stamping capabilities which nics supported.
> Through this method we can easily check which type of packets are
> timestamped currently, it is useful because that we use the hwstamp_ctl
> set time stamping policy first then we could verify what type of packets
> does the nic timestamp and then do some other testing(regression) for each
> policy.No matter PTP is running or not we can make sure whether timestamp packets
> could cause other general network problems through viewing and setting the
> timestamp policy.

I'm trying to follow this thread, and Richard's question keeps coming up 
in my head, and you've failed to answer it yet.

What are you trying to fix/solve?

It sounds like what you're trying to add can already be retrieved 
through different mechanisms that already exist.

Please explain what you're trying to accomplish that doesn't already 
exist today, and why it's important.  If the facility exists already, 
then use that.  If it's not very usable, it can (maybe) be updated given 
what's deficient.  If it doesn't exist, then explaining why it needs to 
exist will help the case for the patches.

Just providing code doesn't help answer the question of what you're 
trying to do in the first place, and why what already exists isn't good 
enough.

Regards,
-PJ
