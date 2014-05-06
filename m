Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaEFUhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:37:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:45011 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaEFUhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,998,1389772800"; 
   d="scan'208";a="428500741"
Date: Tue, 6 May 2014 13:37:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: josh@joshtriplett.org, David Miller <davem@davemloft.net>,
        andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506203743.GP19657@tassilo.jf.intel.com>
References: <1399328773-6531-9-git-send-email-andi@firstfloor.org>
 <20140505.231229.136734008603421707.davem@davemloft.net>
 <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140506183216.GM19657@tassilo.jf.intel.com>
 <1399407478.15399.81.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399407478.15399.81.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In 1024 bytes of memory, and keep an efficient kernel to handle
> arbitrary number of sockets using the venerable and slow BSD socket api.

I agree running in 1024 bytes would be challenging.

> Adding ~1000 lines of code to save few KB was the point I gave up.

You're refering to fib_list? It currently has some duplicated code
(this could/should be fixed). Or we could drop it, I suppose, if really
everyone hates it.

(I thought it was a cute idea, but I'm biased :-)

Total it is saving 350k, about 30% of the total text size of the mini kernel
(plus some dynamic savings) with networking.

I would be happy to fix any reasonable objection. But fundamental 
"I don't care about anything smaller than my smart phone" type arguments
are not particularly constructive.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
