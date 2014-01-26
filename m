Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaAZPhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 10:37:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaAZPhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 10:37:19 -0500
Date: Sun, 26 Jan 2014 16:37:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: error out if the name buffer is too short
Message-ID: <20140126153737.GA8184@redhat.com>
References: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com> <20140124161922.GA14195@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124161922.GA14195@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24, Oleg Nesterov wrote:
>
> And probably you are right, the fix should be as simple as possible.
> But can't we also simplify __dentry_path? Unless I missed something
> we can move prepend() up, before rcu_read_lock(), "move Get '/' right"
> into that prepend, and even kill retval... OK, most probably I missed
> something,

Of course I missed something ;)

> but at first glance we can do something like
>
> 	static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
> 	{
> 		int len, seq = 0;
> 		int error = 0;
> 		char *end;
>
> 		buf += buflen;
> 		/* Get '/' right, write "/\0" at the end */
> 		if (prepend(&buf, &buflen, "/", 2))
> 			goto Elong;

Heh. Not sure what I was thinking about, but this looks obviously wrong
when I re-read my email. This will add the extra "/" at the end, unless
IS_ROOT().

Sorry for noise.

Oleg.

