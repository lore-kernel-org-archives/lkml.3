Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3GCT70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:59:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3GCT7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:59:25 -0400
Date: Wed, 3 Jul 2013 21:54:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change SIGPIPE's siginfo.si_code from SI_USER to
	SI_KERNEL.
Message-ID: <20130703195452.GA6930@redhat.com>
References: <1372880335-23755-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372880335-23755-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Denys Vlasenko wrote:
>
> @@ -514,7 +514,7 @@ pipe_write(struct kiocb *iocb, const struct iovec *_iov,
>  	__pipe_lock(pipe);
>
>  	if (!pipe->readers) {
> -		send_sig(SIGPIPE, current, 0);
> +		send_sig(SIGPIPE, current, 1);

Honestly, I simply have no idea what makes more sense in this case...
But I am not sure about this user-visible change. It can break
something and for what?

And if you do this then I guess you should also change net/.

Oleg.

