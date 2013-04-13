Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3DMDHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 23:07:08 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:63949 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3DMDHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 23:07:06 -0400
Date: Fri, 12 Apr 2013 20:07:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH PART3 v3 2/6] staging: ramster: Move debugfs code out of
 ramster.c file
Message-ID: <20130413030703.GA22129@kroah.com>
References: <1365813371-19006-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1365813371-19006-2-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365813371-19006-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 08:36:06AM +0800, Wanpeng Li wrote:
> Note that at this point there is no CONFIG_RAMSTER_DEBUG
> option in the Kconfig. So in effect all of the counters
> are nop until that option gets introduced in patch:
> ramster/debug: Add CONFIG_RAMSTER_DEBUG Kconfig entry

This patch breaks the build again, so of course, I can't take it:

drivers/built-in.o: In function `ramster_flnode_alloc.isra.5':
ramster.c:(.text+0x1b6a6e): undefined reference to `ramster_flnodes_max'
ramster.c:(.text+0x1b6a7e): undefined reference to `ramster_flnodes_max'
drivers/built-in.o: In function `ramster_count_foreign_pages':
(.text+0x1b7205): undefined reference to `ramster_foreign_pers_pages_max'
drivers/built-in.o: In function `ramster_count_foreign_pages':
(.text+0x1b7215): undefined reference to `ramster_foreign_pers_pages_max'
drivers/built-in.o: In function `ramster_count_foreign_pages':
(.text+0x1b7235): undefined reference to `ramster_foreign_eph_pages_max'
drivers/built-in.o: In function `ramster_count_foreign_pages':
(.text+0x1b7249): undefined reference to `ramster_foreign_eph_pages_max'
drivers/built-in.o: In function `ramster_debugfs_init':
(.init.text+0xd620): undefined reference to `ramster_foreign_eph_pages_max'
drivers/built-in.o: In function `ramster_debugfs_init':
(.init.text+0xd656): undefined reference to `ramster_foreign_pers_pages_max'

I thought you fixed this :(

