Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaCZSqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:46:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45441 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCZSqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:46:15 -0400
Date: Wed, 26 Mar 2014 14:46:13 -0400 (EDT)
Message-Id: <20140326.144613.1346051389108269225.davem@davemloft.net>
To: sj38.park@gmail.com
Cc: Ian.Campbell@citrix.com, trivial@kernel.org, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ixen-netback: fix trivial printf format build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAEjAshoYWeCdVD9mC4f6EQkQkd-dVuk47gGEZ-4ig-uVS938ag@mail.gmail.com>
References: <1395806210-23528-1-git-send-email-sj38.park@gmail.com>
	<1395828547.22808.28.camel@kazak.uk.xensource.com>
	<CAEjAshoYWeCdVD9mC4f6EQkQkd-dVuk47gGEZ-4ig-uVS938ag@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 11:46:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 26 Mar 2014 19:34:21 +0900

> Thank you for let me know kindly :)

Also your fix wasn't correct.

You changed the code to use %lx but the type isn't a long.

It's the difference between two pointers, which is ptrdiff_t.  The
proper printf format string for a hexadecimal ptrdiff_t is %tx
