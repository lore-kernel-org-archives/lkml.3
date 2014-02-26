Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaBZVIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:08:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41041 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaBZVIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:08:42 -0500
Date: Wed, 26 Feb 2014 16:08:40 -0500 (EST)
Message-Id: <20140226.160840.2252241966959740296.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 13/16] isdn: hisax/elsa: fix sleep_on race in elsa FSM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393412516-3762435-14-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
	<1393412516-3762435-14-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 13:08:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Feb 2014 12:01:53 +0100

> The state machine code in the elsa driver uses interruptible_sleep_on
> to wait for state changes, which is racy. A closer look at the possible
> states reveals that it is always used to wait for getting back into
> ARCOFI_NOP, so we can use wait_event_interruptible instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
