Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaBZVIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:08:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41045 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaBZVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:08:48 -0500
Date: Wed, 26 Feb 2014 16:08:46 -0500 (EST)
Message-Id: <20140226.160846.1904753935237205820.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 14/16] isdn: divert, hysdn: fix interruptible_sleep_on
 race
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393412516-3762435-15-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
	<1393412516-3762435-15-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 13:08:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Feb 2014 12:01:54 +0100

> These two drivers use identical code for their procfs status
> file handling, which contains a small race against status
> data becoming available while reading the file.
> 
> This uses wait_event_interruptible instead to fix this
> particular race and eventually get rid of all sleep_on
> instances. There seems to be another race involving
> multiple concurrent readers of the same procfs file, which
> I don't try to fix here.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
