Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaFEHp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:45:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41151 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEHp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:45:56 -0400
Date: Thu, 05 Jun 2014 00:45:55 -0700 (PDT)
Message-Id: <20140605.004555.658378024391856482.davem@davemloft.net>
To: isubramanian@apm.com
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        rapatel@apm.com, kchudgar@apm.com
Subject: Re: [PATCH v5 4/4] drivers: net: Add APM X-Gene SoC ethernet
 driver support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401737954-26152-5-git-send-email-isubramanian@apm.com>
References: <1401737954-26152-1-git-send-email-isubramanian@apm.com>
	<1401737954-26152-5-git-send-email-isubramanian@apm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Jun 2014 00:45:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iyappan Subramanian <isubramanian@apm.com>
Date: Mon,  2 Jun 2014 12:39:14 -0700

> +	netdev_err(ndev, "LERR: %d ring_num: %d ", status, ring->num);
> +	switch (status) {
> +	case HBF_READ_DATA:
> +		netdev_err(ndev, "HBF read data error\n");
> +		break;

This is not really appropriate.

We have statistics like the ones you are incrementing in this
function as the mechanism people can use to learn what events
happened on an interface, and how many times they happened.

Therefore, emitting a log message for each one of those events too is
not necessary.

We don't emit a netdev_err() for every packet that the IPv4 stack
drops due to a bad checksum, for example.

Please get rid of this.

