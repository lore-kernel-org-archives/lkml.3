Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaAFUro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:47:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34517 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbaAFUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:47:43 -0500
Date: Mon, 06 Jan 2014 15:47:40 -0500 (EST)
Message-Id: <20140106.154740.590358835696689785.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net 1/2] macvlan: forbid L2 fowarding offload for
 macvtap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388978467-2075-1-git-send-email-jasowang@redhat.com>
References: <1388978467-2075-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 12:47:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon,  6 Jan 2014 11:21:06 +0800

> L2 fowarding offload will bypass the rx handler of real device. This will make
> the packet could not be forwarded to macvtap device. Another problem is the
> dev_hard_start_xmit() called for macvtap does not have any synchronization.
> 
> Fix this by forbidding L2 forwarding for macvtap.
> 
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I think I agree with Neil that the rx_handler change might be the best
way to fix this.  That change seems to have a lot of nice unintended
side effects, no?
