Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaBXTca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:32:30 -0500
Received: from tex.lwn.net ([70.33.254.29]:32882 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaBXTc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:32:28 -0500
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 14:32:28 EST
Date: Mon, 24 Feb 2014 11:59:07 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH for-next 3/4] epoll: struct epoll support
Message-ID: <20140224115907.07092911@lwn.net>
In-Reply-To: <1393206162-18151-4-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
	<1393206162-18151-4-git-send-email-n1ght.4nd.d4y@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I was just looking things over quickly, and something jumped out at
me.  In ep_control():

> +	} else if (!(*io) && epi) {
> +		/* delete this eventpoll entry */
> +		if (is_file_epoll(target)) {
> +			tep = target->private_data;
> +			mutex_lock_nested(&tep->mtx, 1);
> +		}
> +		if (is_file_epoll(target))
> +			mutex_lock_nested(&tep->mtx, 1);

How could that possibly work?  I can't imagine tep->mtx is going to
react well to being locked a second time...

jon
