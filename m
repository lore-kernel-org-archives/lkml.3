Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3LRWoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:44:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57404 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LRWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 17:44:03 -0500
Date: Wed, 18 Dec 2013 17:43:59 -0500 (EST)
Message-Id: <20131218.174359.2230195267384857675.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: rashika.kheria@gmail.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, joe@perches.com,
        andriy.shevchenko@linux.intel.com, vfalico@redhat.com,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH] drivers: ptp: Include new header file in ptp_pch.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131216085839.GA8303@netboy>
References: <1387140255-11797-1-git-send-email-rashika.kheria@gmail.com>
	<20131216085839.GA8303@netboy>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 18 Dec 2013 14:44:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Mon, 16 Dec 2013 09:58:40 +0100

> On Mon, Dec 16, 2013 at 02:14:15AM +0530, Rashika Kheria wrote:
>> ---
>>  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |    9 ---------
>>  .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    1 +
>>  drivers/ptp/ptp_pch.c                              |    1 +
>>  include/linux/ptp_pch.h                            |   16 ++++++++++++++++
>>  4 files changed, 18 insertions(+), 9 deletions(-)
>>  create mode 100644 include/linux/ptp_pch.h
> 
> Instead of adding a random driver header into include/linux, I would
> prefer that you just move the ptp_pch.c from drivers/ptp to
> drivers/net/ethernet/oki-semi/pch_gbe. Then you can just include
> pch_gbe.h directly.

I think this begs an even more fundamental question, why isn't the PTP
driver abstraction providing the necessary methods and interfaces so
that pch_gbe doesn't have to call into the ptp_pch.c code directly?

Moving ptp_pch.c elsehwere is not desirable, it's a PTP driver so
it belongs under drivers/ptp.

Someone who understands all of these components needs to sort this
out cleanly, this patch isn't it.
