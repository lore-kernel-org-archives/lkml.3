Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3J3CpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:45:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52296 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3J3Co7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:44:59 -0400
Date: Tue, 29 Oct 2013 22:44:56 -0400 (EDT)
Message-Id: <20131029.224456.313230245288672803.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com
Subject: Re: [PATCH net] virtio-net: correctly handle cpu hotplug notifier
 during resuming
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383030667-14343-1-git-send-email-jasowang@redhat.com>
References: <1383030667-14343-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 19:44:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 29 Oct 2013 15:11:07 +0800

> commit 3ab098df35f8b98b6553edc2e40234af512ba877 (virtio-net: don't respond to
> cpu hotplug notifier if we're not ready) tries to bypass the cpu hotplug
> notifier by checking the config_enable and does nothing is it was false. So it
> need to try to hold the config_lock mutex which may happen in atomic
> environment which leads the following warnings:
 ...
> A correct fix is to unregister the hotcpu notifier during restore and register a
> new one in resume.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> This patch is needed for 3.8 and above.

Applied and queued up for -stable, thanks Jason.
