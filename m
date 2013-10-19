Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3JSXqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 19:46:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3JSXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 19:46:38 -0400
Date: Sat, 19 Oct 2013 19:46:35 -0400 (EDT)
Message-Id: <20131019.194635.2189923305870380269.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/9] Introduce support to lazy initialize
 mostly static keys
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382212139-20301-1-git-send-email-hannes@stressinduktion.org>
References: <1382212139-20301-1-git-send-email-hannes@stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 19 Oct 2013 16:46:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Sat, 19 Oct 2013 21:48:50 +0200

> This series implements support for delaying the initialization of secret
> keys, e.g. used for hashing, for as long as possible. This functionality
> is implemented by a new macro, net_get_random_bytes.
> 
> I already used it to protect the socket hashes, the syncookie secret
> (most important) and the tcp_fastopen secrets.
> 
> Changelog:
> v2) Use static_keys in net_get_random_once to have as minimal impact to
>     the fast-path as possible.
> v3) added patch "static_key: WARN on usage before jump_label_init was called":
>     Patch "x86/jump_label: expect default_nop if static_key gets enabled
>     on boot-up" relaxes the checks for using static_key primitives before
>     jump_label_init. So tighten them first.
> v4) Update changelog on the patch "static_key: WARN on usage before
>     jump_label_init was called"

Although I was very skeptical about these changes when you first posted
them, I am quite happy with this series now.

Thanks for working on this and not giving up :-)

Series applied, thanks a lot!

