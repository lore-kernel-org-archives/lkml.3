Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3CDP2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:28:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:7186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab3CDP2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:28:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,779,1355126400"; 
   d="scan'208";a="270670759"
Message-ID: <5134BD9B.2080003@linux.intel.com>
Date: Mon, 04 Mar 2013 17:28:27 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>   <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>  <1362335704.15793.81.camel@edumazet-glaptop>  <51345EB8.9050309@linux.intel.com> <1362408768.15793.89.camel@edumazet-glaptop>
In-Reply-To: <1362408768.15793.89.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 16:52, Eric Dumazet wrote:
> On Mon, 2013-03-04 at 10:43 +0200, Eliezer Tamir wrote:
>
>> One could for example increment the generation id every time the RTNL is
>> taken. or is this too much?
>
> RTNL is taken for a lot of operations, it would be better to have a
> finer grained increment.

If is taken rarely enough it will still be worth it.

Otherwise it may be hard to know what operations need to invalidate the 
napi reference. It can very well be HW dependent, and then you end up 
adding a function for drivers to call to do the invalidation.

Or we can decide that we only care about catastrophic events and only 
worry about a napi completely going away and not worry about 
configuration changes.(Polling the wrong queue will not kill you, it's 
just a waste of perfectly good CPU cycles.)
