Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab3KRCe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:34:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:32901 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3KRCet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:34:49 -0500
Date: Mon, 18 Nov 2013 02:34:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Greg Price <price@MIT.EDU>, Christopher Li <sparse@chrisli.org>,
        Erico Nunes <nunes.erico@gmail.com>, linux-sparse@vger.kernel.org,
        dwmw2 <dwmw2@infradead.org>, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clarify error on directive in macro arguments (Re:
 [PATCH] jffs2: fix sparse errors: directive in argument list)
Message-ID: <20131118023443.GN13318@ZenIV.linux.org.uk>
References: <20131118020746.GX16018@ringworld.MIT.EDU>
 <1384740932.5814.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384740932.5814.4.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 06:15:32PM -0800, Joe Perches wrote:
> > > sparse matches gcc behaviour (I hope), but it warns about such abuses.
> > > It's a defect, all right - one being reported by sparse.
> > 
> > Perhaps the following tweak to the error message would make this
> > subtlety clearer?
> 
> Maybe, but this case isn't a macro.  It's a function.
> Dunno if differentiating when it's a macro or a
> function is difficult though.

In which case?  With printk() it's perfectly fine and sparse
will not complain at all.  With pr_info(), OTOH, we have
#define pr_info(fmt, ...) \
        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
and when you start playing that kind of games with it, you get warnings.
