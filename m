Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaDWTMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:12:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50877 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWTMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:12:09 -0400
Date: Wed, 23 Apr 2014 15:12:07 -0400 (EDT)
Message-Id: <20140423.151207.732393717073846191.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH net-next 1/1] hyperv: Enable sendbuf mechanism on the
 send path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398189812-8902-1-git-send-email-kys@microsoft.com>
References: <1398189812-8902-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 12:12:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Tue, 22 Apr 2014 11:03:32 -0700

> +			skb = (struct sk_buff *)
> +			      packet->send_completion_tid;

As in netvsc_xmit_completion() this must be coded as:

	skb = (struct sk_buff *) (unsigned long)packet->send_completion_tid;
