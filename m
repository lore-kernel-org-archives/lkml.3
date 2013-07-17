Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3GQNqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:46:43 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34273 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab3GQNqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:46:40 -0400
Date: Wed, 17 Jul 2013 09:46:39 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-aio@kvack.org
Subject: Re: linux-next: build failure after merge of the final tree (aio tree related)
Message-ID: <20130717134639.GC19643@kvack.org>
References: <20130717134124.23192f8c9bcc29b07f57743f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717134124.23192f8c9bcc29b07f57743f@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen, (actually a greeting this time!)

On Wed, Jul 17, 2013 at 01:41:24PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> fs/aio.c: In function 'aio_migratepage':
> fs/aio.c:196:2: error: implicit declaration of function 'migrate_page_move_mapping' [-Werror=implicit-function-declaration]
>   rc = migrate_page_move_mapping(mapping, new, old, NULL, mode);
>   ^
> 
> Caused by commit 36bc08cc0170 ("fs/aio: Add support to aio ring pages
> migration"). The declaration of migrate_page_move_mapping() in
> linux/migrate.h is protected by CONFIG_MIGRATION - its use in fs/aio.c is
> not.  So the usage needs to be protected, or there needs to be a dummy
> version in linux/migrate.h

I have added and tested a fix for this issue and pushed it out to my 
tree.  Thanks for the report -- I'll try to be a bit more careful.

		-ben

> I have reverted that commit for today.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
"Thought is the essence of where you are now."
