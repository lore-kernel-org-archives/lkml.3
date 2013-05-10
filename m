Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3EJEvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:51:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3EJEvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:51:46 -0400
Date: Fri, 10 May 2013 05:51:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the origintree
Message-ID: <20130510045144.GJ25399@ZenIV.linux.org.uk>
References: <20130510131926.bbbee7dec35f696c407ac63e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510131926.bbbee7dec35f696c407ac63e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 01:19:26PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/md/bcache/super.c:656:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/md/bcache/super.c:656:2: warning: (near initialization for 'bcache_ops.release') [enabled by default]
> 
> Introduced by commit cafe56359144 ("bcache: A block layer cache")
> interacting with commit db2a144bedd5 ("block_device_operations->release()
> should return void").

Simply drop that return 0; and make it return void.  Or just leave it as is
for now - while C implementation has every right to blow up when calling a
function that returns int as if it had been a function returning void (e.g.
C ABI might have return value for int passed as it's usually done for big
structs), AFAIK, none of the architectures we support do anything of that
kind.
