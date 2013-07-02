Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3GBUGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:06:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3GBUGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:06:18 -0400
Date: Tue, 2 Jul 2013 22:01:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Define WTERMSIG{,_MASK} and WCOREDUMP and use where
	appropriate
Message-ID: <20130702200147.GC9359@redhat.com>
References: <1372696755-17427-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372696755-17427-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Denys Vlasenko wrote:
>
> Grepping for numeric constants is inconvenient.

Personally I agree very much, and I like the intent.

> +#define WTERMSIG_MASK     0x7f
> +#define WTERMSIG(status)  ((status) & WTERMSIG_MASK)
> +#define WCOREDUMP(status) ((status) & 0x80)

But I am not sure we need WTERMSIG/WCOREDUMP helpers, although
I won't really argue.

OTOH, I think it would be nice to add the name for 0x80 and
change coredump_finish().

And if we do not add WTERMSIG(), then perhaps we can turn other
0x7f's into WTERMSIG_MASK?

Oleg.

