Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaKLTsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:48:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45868 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaKLTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:48:23 -0500
Date: Wed, 12 Nov 2014 14:46:40 -0500 (EST)
Message-Id: <20141112.144640.703336197189868183.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add processing of MTU reduced by the
 host
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415748472-27463-1-git-send-email-haiyangz@microsoft.com>
References: <1415748472-27463-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 11:48:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 11 Nov 2014 15:27:52 -0800

> -	if (mtu < 68 || mtu > limit)
> +	if (mtu < ETH_DATA_LEN || mtu > limit)
>  		return -EINVAL;

This is not correct.

The test is against the minimally supported MTU, which should
be 68 not ETH_DATA_LEN which is 1500.
