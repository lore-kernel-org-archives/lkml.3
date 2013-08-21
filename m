Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3HUPJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:09:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:1080 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3HUPJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:09:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,928,1367996400"; 
   d="scan'208";a="366250145"
Message-ID: <5214D812.3090906@linux.intel.com>
Date: Wed, 21 Aug 2013 18:09:06 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Eilon Greenstein <eilong@broadcom.com>,
        Amir Vadai <amirv@mellanox.com>, Willem de Bruijn <willemb@google.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com> <1377093188.4226.108.camel@edumazet-glaptop>
In-Reply-To: <1377093188.4226.108.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/2013 16:53, Eric Dumazet wrote:
> On Wed, 2013-08-21 at 13:39 +0300, Eliezer Tamir wrote:
> 
>>
>> Instead of remembering the napi_id for all the sockets in an epoll,
>> we only track the first socket we see with any unique napi_id.
>> The rational for this is that while there may be many thousands of
>> sockets tracked by a single epoll, we expect to only see a handful
>> of unique napi_ids in most cases.
> 
> This looks buggy assumption to me.
> 
> We use epoll() with in the order of millions of fds per epoller, and
> typically one napi_id per cpu.
> 
> With your model, we would have to use nr_cpu epollers and make sure that
> sockets are properly placed on those epollers by their napi_ids.

There is no assumption here on how the user configures epoll.
All we are doing is reducing the list of sockets monitored
by an epoll instance to a smaller subset where each NAPI_ID
appears only once.

The user is free to have an epoll monitor sockets from queues
associated to any CPU.
