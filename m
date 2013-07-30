Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3G3XKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:10:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43147 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab3G3XKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:10:37 -0400
Date: Tue, 30 Jul 2013 16:10:35 -0700 (PDT)
Message-Id: <20130730.161035.1646022729333223847.davem@davemloft.net>
To: linus.luessing@web.de
Cc: bridge@lists.linux-foundation.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, amwang@redhat.com,
        linux@baker-net.org.uk
Subject: Re: [PATCHv2] bridge: disable snooping if there is no querier
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374760580-12920-1-git-send-email-linus.luessing@web.de>
References: <1374757046-12463-1-git-send-email-linus.luessing@web.de>
	<1374760580-12920-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 16:10:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Thu, 25 Jul 2013 15:56:20 +0200

> +	atomic64_t			multicast_querier_delay_time;

Please don't use an atomic64_t here, it's pointless.

You're only doing set and read operations on it, there's absolutely
nothing atomic about that.

You have to make sure that the top-level operations that use this
new value use an appropriate amount of locking on the higher level
objects.
