Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaGWWMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:12:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38336 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbaGWWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:12:54 -0400
Date: Wed, 23 Jul 2014 15:12:52 -0700 (PDT)
Message-Id: <20140723.151252.513994964059108010.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/2] rx busy polling support for virtio-net
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406104435-24077-1-git-send-email-jasowang@redhat.com>
References: <1406104435-24077-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Jul 2014 15:12:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 23 Jul 2014 16:33:53 +0800

> This series introduces the support for rx busy polling support. This
> was useful for reduing the latency for a kvm guest. Instead of
> introducing new states and spinlocks, this series re-uses NAPI state
> to synchonrize between NAPI and busy polling. This grealy simplified
> the codes and reduce the overheads of spinlocks for normal NAPI fast
> path.
> 
> Test was done between a kvm guest and an external host. Two hosts were
> connected through 40gb mlx4 cards. With both busy_poll and  busy_read
> are set to 50 in guest, 1 byte netperf tcp_rr shows 127% improvement:
> transaction rate was increased from 8353.33 to 18966.87.
> 
> Changes from V2:
> - Avoid introducing new states and spinlocks by reusuing the NAPI
>   state
> - Fix the budget calculation in virtnet_poll()
> - Drop patch 1/3 from V2 since it was useless
> 
> Changes from V1:
> - split the patch info smaller ones
> - add more details about test setup/configuration

Series applied, thanks Jason.
