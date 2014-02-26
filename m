Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaBZVIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:08:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41038 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaBZVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:08:36 -0500
Date: Wed, 26 Feb 2014 16:08:34 -0500 (EST)
Message-Id: <20140226.160834.847804163386929425.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 12/16] isdn: pcbit: fix interruptible_sleep_on race
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393412516-3762435-13-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
	<1393412516-3762435-13-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 13:08:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Feb 2014 12:01:52 +0100

> interruptible_sleep_on is racy and going away. In case of pcbit,
> the driver would run into a timeout if the card is initialized
> before we start waiting for it. This uses wait_event to fix the
> race. In order to do this, the state machine handling for the
> timeout case has to get trivially reorganized so we actually know
> whether the timeout has occorred or not.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
