Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab3LBS7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:59:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53002 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3LBS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:59:04 -0500
Date: Mon, 02 Dec 2013 13:59:02 -0500 (EST)
Message-Id: <20131202.135902.408377838919681103.davem@davemloft.net>
To: agraf@suse.de
Cc: herbert@gondor.apana.org.au, alexander.h.duyck@intel.com,
        netdev@vger.kernel.org, edumazet@google.com, herbert@gondor.apana.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: gem csum breakage with 018c5bba (Handle CHECKSUM_COMPLETE more
 adequately ...)
From: David Miller <davem@davemloft.net>
In-Reply-To: <B8BCE323-6F65-4D14-BD4A-BFA07C3ED290@suse.de>
References: <B8BCE323-6F65-4D14-BD4A-BFA07C3ED290@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 02 Dec 2013 10:59:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>
Date: Fri, 22 Nov 2013 19:08:16 +0100

> With current Linus' master tree my ibook started emitting a lot of
> annoying csum calculation warnings. I've bisected it down to the
> commit seen in the subject line, but I suppose the real problem lies
> somewhere a lot deeper and only gets revealed thanks to the more
> clever checksum logic applied now.
> 
> Any ideas how to dig further into this?

Ok, I'm going to revert this commit, for several reasons.

In addition to the problem you are running into, it just occurred to me
that if the __pskb_trim() call fails, we'll leave a corrupted checksum
in the SKB.

Thanks for your report.
