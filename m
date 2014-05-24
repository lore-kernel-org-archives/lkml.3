Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaEXDgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 23:36:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57963 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaEXDgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 23:36:42 -0400
Date: Fri, 23 May 2014 23:36:37 -0400 (EDT)
Message-Id: <20140523.233637.1826798421419100755.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH net-next 2/4] bridge: adhere to querier election
 mechanism specified by RFCs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400662742-31999-3-git-send-email-linus.luessing@web.de>
References: <1400662742-31999-1-git-send-email-linus.luessing@web.de>
	<1400662742-31999-3-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 May 2014 20:36:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Wed, 21 May 2014 10:59:00 +0200

> +	if (saddr <= br->ip4_querier.addr.u.ip4)
> +		goto update;

It is clear to me that you should be making these comparisons in cpu
endianness.

Otherwise the code will handle the same situations differently
on big-endian vs. little-endian machines.

