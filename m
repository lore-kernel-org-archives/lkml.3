Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3JXMqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:46:40 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:53910 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3JXMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:46:39 -0400
Date: Thu, 24 Oct 2013 13:46:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: READ/WRITE definitions in drivers/spi/spi-omap-100k.c
Message-ID: <20131024124631.GA14517@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

I was modifying includes in a core header file and got duplicate macro
definition warnings on READ / WRITE in drivers/spi/spi-omap-100k.c.
Apparently that driver defines READ / WRITE as macros and assigns the
opposite values to them from the usual READ / WRITE constants defined
in include/linux/fs.h.

I just skimmed through it and there doesn't seem to be any user of the
macros.  Can we *please* remove these?  Please note that READ / WRITE
defined in include/linux/fs.h is something which is widely used
throughout the kernel and there are multiple interfaces which take
those constants.  Re-defining them in the other way around in a driver
file can lead to subtle issues and just is a bad idea.  In general,
refraining from using generic symbols without any qualitification in
low level drivers would be nice.

Thanks.

-- 
tejun
