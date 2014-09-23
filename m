Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaIWF7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:59:40 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32952 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaIWF7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:59:35 -0400
X-Originating-IP: 50.43.15.134
Date: Mon, 22 Sep 2014 22:59:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tiny tree
Message-ID: <20140923055927.GA6900@thin>
References: <20140923145711.5c1ca775@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923145711.5c1ca775@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:57:11PM +1000, Stephen Rothwell wrote:
> Hi Josh,
> 
> After merging the tiny tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> mm/built-in.o: In function `.isolate_migratepages_range':
> (.text+0x2fbd8): undefined reference to `.balloon_page_isolate'
> mm/built-in.o: In function `.putback_movable_pages':
> (.text+0x713c4): undefined reference to `.balloon_page_putback'
> mm/built-in.o: In function `.migrate_pages':
> (.text+0x72a00): undefined reference to `.balloon_page_migrate'
> 
> Caused by commit b37a3fee8450 ("mm: Disable mm/balloon_compaction.c
> completely when !CONFIG_VIRTIO_BALLOON").
> 
> I have reverted that commit for today.

Strange.  That commit compiled just fine here with several
configurations; I'll investigate what's up with ppc64_defconfig.
Will revert for now.

- Josh Triplett
