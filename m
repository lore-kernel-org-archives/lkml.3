Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3DKUEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:04:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52996 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3DKUEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:04:30 -0400
Date: Thu, 11 Apr 2013 13:04:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 05/10] staging: ramster: Move debugfs code out of
 ramster.c file
Message-ID: <20130411200428.GA31680@kroah.com>
References: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1365553560-32258-6-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365553560-32258-6-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 08:25:55AM +0800, Wanpeng Li wrote:
> Note that at this point there is no CONFIG_RAMSTER_DEBUG
> option in the Kconfig. So in effect all of the counters
> are nop until that option gets re-introduced in:
> zcache/ramster/debug: Add RAMSTE_DEBUG Kconfig entry

This patch breaks the build badly:

drivers/staging/zcache/ramster/ramster.c: In function ‘ramster_localify’:
drivers/staging/zcache/ramster/ramster.c:159:4: error: ‘ramster_remote_eph_pages_unsucc_get’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:159:4: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/zcache/ramster/ramster.c:161:4: error: ‘ramster_remote_pers_pages_unsucc_get’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:212:3: error: ‘ramster_remote_eph_pages_succ_get’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:214:3: error: ‘ramster_remote_pers_pages_succ_get’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c: In function ‘ramster_pampd_repatriate_preload’:
drivers/staging/zcache/ramster/ramster.c:299:3: error: ‘ramster_pers_pages_remote_nomem’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c: In function ‘ramster_remote_flush_page’:
drivers/staging/zcache/ramster/ramster.c:437:3: error: ‘ramster_remote_pages_flushed’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:439:3: error: ‘ramster_remote_page_flushes_failed’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c: In function ‘ramster_remote_flush_object’:
drivers/staging/zcache/ramster/ramster.c:454:3: error: ‘ramster_remote_objects_flushed’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:456:3: error: ‘ramster_remote_object_flushes_failed’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c: In function ‘ramster_remotify_pageframe’:
drivers/staging/zcache/ramster/ramster.c:507:5: error: ‘ramster_eph_pages_remote_failed’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:509:5: error: ‘ramster_pers_pages_remote_failed’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:516:4: error: ‘ramster_eph_pages_remoted’ undeclared (first use in this function)
drivers/staging/zcache/ramster/ramster.c:518:4: error: ‘ramster_pers_pages_remoted’ undeclared (first use in this function)
make[3]: *** [drivers/staging/zcache/ramster/ramster.o] Error 1

Please always test your patches.

I've applied patch 1, 3, and 4 in this series.  Please fix this up if you want
me to apply anything else.

greg k-h
