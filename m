Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaIDGvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:51:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:26547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaIDGvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:51:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,464,1406617200"; 
   d="scan'208";a="586069003"
Message-ID: <54080BF5.1070504@linux.intel.com>
Date: Thu, 04 Sep 2014 09:51:33 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <53F6F14B.1030609@redhat.com> <20140822074224.GB7372@gmail.com> <53FFEEC0.4000304@redhat.com> <540414AB.9000004@linux.intel.com> <54053998.4040604@redhat.com> <54056076.2030603@linux.intel.com> <20140902083124.GB10356@redhat.com> <5406B9E6.6050103@linux.intel.com> <20140903075104.GA6187@redhat.com>
In-Reply-To: <20140903075104.GA6187@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 10:51, Michael S. Tsirkin wrote:
> On Wed, Sep 03, 2014 at 09:49:10AM +0300, Eliezer Tamir wrote:
>> On 02/09/2014 11:31, Michael S. Tsirkin wrote:
>>> On Tue, Sep 02, 2014 at 09:15:18AM +0300, Eliezer Tamir wrote:

>> Busy polling is not a general purpose feature, it's not something you
>> can casually turn on and will "just work". Most applications should not
>> be using busy polling. Currently it is used by multiserver applications
>> that you spend days tuning to specific platforms.
>>
>> What the user wants is to lower both avg and maximum latencies, at the
>> expense of everything else including power efficiency and sometimes
>> even throughput. The only exception is making the system crash ;)
>>
>> While letting other things take precedence over busy polling might not
>> hurt the avg latency much, it will kill your maximum latency.
> 
> If scheduler happens to run both server and client on the
> same CPU, polling will hurt maximum latency even more.
> So I guess different users want different things.
> 
> How about applications giving us a hint what they prefer?
> For example, a new flag that says "I don't have anything useful to do so
> let's do busy polling but my server is on the local system, so please
> only poll if CPU is otherwise idle".

I'm sorry for being ambiguous, when I said multi-server application, I
meant an app that runs on more than one server machine.

The loopback test is as far as I know not interesting.

Of course if busypoll becomes interesting for virtualization over
loopback, I have no problem with that, provided that there is a way to
get the old behavior and that it is well documented.

-Eliezer
