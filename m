Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3ETJkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:40:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:11246 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab3ETJkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:40:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="244054223"
Message-ID: <5199EF6F.9040008@linux.intel.com>
Date: Mon, 20 May 2013 12:39:59 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [PATCH v2 net-next 1/4] net: implement support for low latency
 socket polling
References: <20130519102525.12527.83301.stgit@ladj378.jer.intel.com> <20130519102533.12527.12991.stgit@ladj378.jer.intel.com> <20130520.005447.972811583292360876.davem@davemloft.net>
In-Reply-To: <20130520.005447.972811583292360876.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2013 10:54, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Date: Sun, 19 May 2013 13:25:33 +0300
>
>> +#else /* CONFIG_INET_LL_RX_FLUSH */
>> +
>> +#define sk_valid_ll(sk) 0
>> +#define sk_poll_ll(sk, nonblock) do {} while (0)
>> +#define skb_mark_ll(napi, skb) do {} while (0)
>> +#define sk_mark_ll(sk, skb) do {} while (0)
>
> Make these inline functions too, so that even if
> CONFIG_INET_LL_RX_POLL is disabled, the arguments and return values
> are still properly type checked.

Is this what you had in mind?

static inline bool sk_valid_ll(struct sock *sk)
{
	return 0;
}

static inline bool sk_poll_ll(struct sock *sk, int noblock)
{
	return 0;
}

static inline void skb_mark_ll(struct sk_buff *skb, struct napi_struct 
*napi)
{
}

static inline voiv sk_mark_ll(struct sock *sk, struct sk_buff *skb)
{
}

would you like me to resend the whole set or just this patch?

Thanks,
Eliezer
