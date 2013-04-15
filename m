Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3DOBvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:51:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43959 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752753Ab3DOBvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:51:18 -0400
Message-ID: <1365990674.1878.21.camel@joe-AO722>
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
From: Joe Perches <joe@perches.com>
To: htl10@users.sourceforge.net
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Apr 2013 18:51:14 -0700
In-Reply-To: <1365987181.4850.YahooMailClassic@web172306.mail.ir2.yahoo.com>
References: <1365987181.4850.YahooMailClassic@web172306.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 01:53 +0100, Hin-Tak Leung wrote:
> --- On Mon, 8/4/13, Joe Perches <joe@perches.com> wrote:
> > Use a more current logging style.
[]
> I have been sitting on a patch which changes this part of the code to dynamic debugging, and it is much simplier. Just:
> #define dprint(flg, fmt, args...) \
> -       if (flg & DBG_MASK) \
> -               printk(fmt , ## args)
> +               pr_debug(fmt , ## args)

This change wouldn't work well as it would make a mess
of output that uses no prefix (ie: emits at KERN_DEFAULT)
with output that uses KERN_DEBUG

That's the reason for _dbg and _dbg_cont.


