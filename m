Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbaD1T6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:58:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45495 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaD1T6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:58:13 -0400
Date: Mon, 28 Apr 2014 13:23:47 -0400 (EDT)
Message-Id: <20140428.132347.778081265367223580.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, stable@kernel.org
Subject: Re: [PATCH V1 net-next 1/1] hyperv: Properly handle checksum
 offload
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398484523-27596-1-git-send-email-kys@microsoft.com>
References: <1398484523-27596-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Apr 2014 10:23:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Fri, 25 Apr 2014 20:55:23 -0700

> @@ -467,6 +467,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
>  	if (skb_is_gso(skb))
>  		goto do_lso;
>  
> +	if (skb->ip_summed != CHECKSUM_PARTIAL)
> +		goto do_send;
> +

There are many possible values of ip_summed, why would you go to do_send if
for example it was set to CHECKSUM_COMPLETE?

I think you are just rushing this change, take your time and implement the
fix properly.

For example, if you only expect two possible values here (CHECKSUM_PARTIAL
and something else), design your test so that it only allows those two
values and therefore you'll be documenting this invariant.
