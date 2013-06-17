Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab3FQK33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:29:29 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:54224 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3FQK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:29:28 -0400
Message-ID: <1371464962.3252.181.camel@edumazet-glaptop>
Subject: Re: [PATCH] tcp: Modify the condition for the first skb to collapse
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jun Chen <jun.d.chen@intel.com>
Cc: ycheng@google.com, ncardwell@google.com, edumazet@google.com,
        netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 17 Jun 2013 03:29:22 -0700
In-Reply-To: <1371490190.28418.6.camel@chenjun-workstation>
References: <1371478739.10495.5.camel@chenjun-workstation>
	 <1371456935.3252.177.camel@edumazet-glaptop>
	 <1371490190.28418.6.camel@chenjun-workstation>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 13:29 -0400, Jun Chen wrote:
> > 
> hi,
> When the condition of tcp_win_from_space(skb->truesize) > skb->len is
> true but the before(start, TCP_SKB_CB(skb)->seq) is also true, the final
> condition will be true. The follow line:
> int offset = start - TCP_SKB_CB(skb)->seq;
> BUG_ON(offset < 0);
> this BUG_ON will be triggered.
> 

Really this should never happen, we must track what's happening here.

Are you using a pristine kernel, without any patches ?

Are you able to reproduce this bug in a short amount of time ?

What kind of driver is in use ? (your stack trace was truncated)



