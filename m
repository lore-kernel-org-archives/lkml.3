Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaHAE7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:59:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54234 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaHAE7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:59:08 -0400
Date: Thu, 31 Jul 2014 21:59:07 -0700 (PDT)
Message-Id: <20140731.215907.860867918938148695.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv: Increase the size of
 the sendbuf region
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406770549-29982-1-git-send-email-kys@microsoft.com>
References: <1406770549-29982-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Jul 2014 21:59:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Wed, 30 Jul 2014 18:35:49 -0700

> For forwarding scenarios, it will be useful to allocate larger
> sendbuf. Make the necessary adjustments to permit this.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

This needs more information.

You're increasing the size by 16 times, 1MB --> 16MB, thus less
cache locality.

You're also now using vmalloc() memory, thus more TLB misses and
thrashing.

This must have a negative impact on performance, and you have to
test for that and quantify it when making a change as serious as
this one.

You also haven't gone into detail as to why forwarding scenerios
require more buffer space, than say thousands of local sockets
sending bulk TCP data.

I'm not applying this, it needs a lot more work.
