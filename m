Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3ETTen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:34:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab3ETTel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:34:41 -0400
Date: Mon, 20 May 2013 12:34:40 -0700 (PDT)
Message-Id: <20130520.123440.567878984450788905.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [PATCH v2 net-next 1/4] net: implement support for low latency
 socket polling
From: David Miller <davem@davemloft.net>
In-Reply-To: <5199EF6F.9040008@linux.intel.com>
References: <20130519102533.12527.12991.stgit@ladj378.jer.intel.com>
	<20130520.005447.972811583292360876.davem@davemloft.net>
	<5199EF6F.9040008@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 12:34:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Mon, 20 May 2013 12:39:59 +0300

> On 20/05/2013 10:54, David Miller wrote:
>> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> Date: Sun, 19 May 2013 13:25:33 +0300
>>
>>> +#else /* CONFIG_INET_LL_RX_FLUSH */
>>> +
>>> +#define sk_valid_ll(sk) 0
>>> +#define sk_poll_ll(sk, nonblock) do {} while (0)
>>> +#define skb_mark_ll(napi, skb) do {} while (0)
>>> +#define sk_mark_ll(sk, skb) do {} while (0)
>>
>> Make these inline functions too, so that even if
>> CONFIG_INET_LL_RX_POLL is disabled, the arguments and return values
>> are still properly type checked.
> 
> Is this what you had in mind?
> 
> static inline bool sk_valid_ll(struct sock *sk)

Yes.
