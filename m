Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935968Ab3DPTtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:49:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49167 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935589Ab3DPTtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:49:16 -0400
Date: Tue, 16 Apr 2013 15:49:12 -0400 (EDT)
Message-Id: <20130416.154912.896506198616355113.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <57e8f99081a94575a57cae5e93705c22@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1366139031-12518-1-git-send-email-haiyangz@microsoft.com>
	<20130416.151141.1928940532005718606.davem@davemloft.net>
	<57e8f99081a94575a57cae5e93705c22@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Apr 2013 12:49:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 16 Apr 2013 19:34:52 +0000

> The Hyper-V hosts always use 64 bit request id. The guests can have
> 32 or 64 bit pointers which equal to the ulong type size. So we cast
> it to ulong type. And, assigning 32bit integer to 64 bit variable
> works fine.

It works fine, but it's unclean.

Keep the req_id type as "u64", because that's what it is, a 64-bit request ID.
