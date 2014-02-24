Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBXF3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:29:36 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:46578 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaBXF3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:29:35 -0500
Date: Mon, 24 Feb 2014 05:29:34 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH for-next 1/4] epoll: struct epoll userspace definiton
Message-ID: <20140224052934.GA7056@dcvr.yhbt.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
 <1393206162-18151-2-git-send-email-n1ght.4nd.d4y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393206162-18151-2-git-send-email-n1ght.4nd.d4y@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> +++ b/include/uapi/linux/eventpoll.h
> @@ -61,6 +61,12 @@ struct epoll_event {
>  	__u64 data;
>  } EPOLL_PACKED;
>  
> +struct epoll {
> +	int ep_fildes; /* file descriptor */
> +	int ep_events; /* triggering events */
> +	long long ep_ident; /* entry ID (cf. epoll_event->data) */
> +} EPOLL_PACKED;

Why not reuse the existing epoll_event struct?

	struct epoll {
		int ep_fildes; /* file descriptor */
		struct epoll_event event;
	} EPOLL_PACKED;
