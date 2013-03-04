Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3CDHiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:38:07 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:51812 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3CDHiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:38:05 -0500
Message-ID: <51344F54.8060809@gmail.com>
Date: Mon, 04 Mar 2013 15:37:56 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
In-Reply-To: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 01:55 AM, Eliezer Tamir wrote:
>
> Open issues:
> 1. Find a way to avoid the need to change the sk and skb structs.
> One big disadvantage of how we do this right now is that when a device is
> removed, it's hard to prevent it from getting polled by a socket
> which holds a stale reference.
>
> 2. How do we decide which sockets are eligible to do busy polling?
> Do we add a socket option to control this?
> How do we provide sane defaults while allowing flexibility and performance?
>
> 3. Andi Kleen and HPA pointed out that using get_cycles() is not portable.
>
> 4. How and where do we call ndo_ll_poll from the socket code?
> One good place seems to be wherever the kernel puts the process to sleep,
> waiting for more data, but this makes doing something intelligent about
> poll (the system call) hard. From the perspective of how ndo_ll_poll
> itself is implemented this does not seem to matter.
>
> 5. I would like to hear suggestions on naming conventions and where
> to put the code that for now I have put in include/net/ll_poll.h
>


A dumb question: is bypassing tcpdump/netfilters/qdisc etc. what we 
always want? Isn't this a security issue?

Thanks!
