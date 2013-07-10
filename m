Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3GJFVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:21:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:63077 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab3GJFVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1033,1363158000"; 
   d="scan'208";a="329121179"
Message-ID: <51DCEF51.3080503@linux.intel.com>
Date: Wed, 10 Jul 2013 08:21:21 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: corbet@lwn.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        dwmw2@infradead.org, eliezer@tamir.org.il
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
References: <20130709162514.062f1361@lwn.net> <20130709.160611.636749585237773459.davem@davemloft.net> <51DCD50C.6070606@linux.intel.com> <20130709.214156.1738814737075691376.davem@davemloft.net>
In-Reply-To: <20130709.214156.1738814737075691376.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 07:41, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Date: Wed, 10 Jul 2013 06:29:16 +0300
> 
>> If the following names changes are acceptable I will try to send out
>> a patch today.

>> 2. ndo_ll_poll -> ndo_busy_poll
>>
>> - not technically accurate since the ndo callback does not itself busy
>> poll, it's just used to implement it.
> 
> I think this name change is accurate, it expresses the two elements of
> what it does.  It's busy waiting, in that it's doing a synchronous
> scan of the device's RX queue, and it's polling just like NAPI polling
> does.

OK

> Well... what would be great would be to come up with some single
> interface that drivers can implement rather than having to have
> both napi->poll and netdevice_ops->ndo_ll_poll().  But that's a task
> for a later date.
> 
> Therefore, ndo_busy_poll is probably best for now.

I will think about this, maybe we could even unify ndo_poll_controller.
It seems like said unified method would have to have an extra parameter
that would indicate from which context it was called:
1. from napi poll (bh)
2. from poll controller (with interrupts disabled)
3. from busy poll (user context)
-of course not for today.

> Nope, looks complete.  And also do the manpage update.

Where do I find the repository for the manpages?


