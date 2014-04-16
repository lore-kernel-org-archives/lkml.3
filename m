Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbaDPS6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:58:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47401 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbaDPS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:58:25 -0400
Date: Wed, 16 Apr 2014 14:58:22 -0400 (EDT)
Message-Id: <20140416.145822.1317931249717152474.davem@davemloft.net>
To: aaro.koskinen@iki.fi
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        hughd@google.com
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140414184353.GA5630@drone.musicnaut.iki.fi>
References: <20131022174612.GC24448@blackmetal.musicnaut.iki.fi>
	<20131022.135442.1072093301788210177.davem@davemloft.net>
	<20140414184353.GA5630@drone.musicnaut.iki.fi>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Apr 2014 11:58:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Mon, 14 Apr 2014 21:43:53 +0300

> Just for the archives, I got one of these again with 3.14:

Meelis and Aaro, thanks again for all of your reports.

After pouring over a lot of the data and auditing some code I'm
suspecting it's a problem with transparent huge pages.

One thing you two can do to help me further confirm this is to run
with THP disabled for a while and see if you still get the log
messages.

Simply, as root:

bash# echo "never" >/sys/kernel/mm/transparent_hugepage/enabled

And then do your gcc bootstraps or whatever else seems to usually
run when you trigger this problem.

Thanks!
