Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3HUS1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab3HUS1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:27:09 -0400
Date: Wed, 21 Aug 2013 20:20:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, spender@grsecurity.net
Subject: Re: [PATCH] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Message-ID: <20130821182053.GA19624@redhat.com>
References: <CALCETrXMQdjRyvP8RHOd5xjciurS7-hKUOExvkvQ1RWmdRdypA@mail.gmail.com> <0be9da18c0ca360773a397de3063d01019ff88d8.1377107508.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0be9da18c0ca360773a397de3063d01019ff88d8.1377107508.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can't really comment the patch, just a nit:

On 08/21, Andy Lutomirski wrote:
>
> +static bool may_flink(const struct path *path)
> +{
> +	bool ret;
> +	struct inode *inode = path->dentry->d_inode;
> +
> +	/*
> +	 * This is racy: I_LINKABLE could be cleared between this check
> +	 * and the actual link operation.

OK,

> +	spin_lock(&inode->i_lock);
> +	ret = !!(inode->i_state & I_LINKABLE);
> +	spin_unlock(&inode->i_lock);

so why do we need to take a lock ?

Oleg.

