Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3BKHOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 02:14:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34241 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3BKHOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 02:14:19 -0500
Date: Mon, 11 Feb 2013 10:14:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, smatch@vger.kernel.org
Subject: Smatch 1.58 released
Message-ID: <20130211071432.GM4937@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch is a C static analysis tool, but with a lot of kernel
specific checks.

The big thing in this release is that the type information has now
been pushed to the lowest levels.  It broke a bunch of stuff
including to compiles on older versions of GCC but Emil Tantilov
fixed that (thanks!).  It should be Ok now.

Other changes are that the cross function tracking has been
improved (this requires the database).  There is a new check for
sprintf() overflows.

The way to use Smatch is:

	git clone git://repo.or.cz/smatch.git
	cd smatch
	make
	cd ~/path/to/kernel

	[ This next step is optional if you want to build the
	  database.  If you build it several times the database
  	  becomes more complete. ]
  	~/path/to/smatch/smatch_scripts/build_kernel_data.sh

	~/path/to/smatch/smatch_scripts/test_kernel.sh

It creates warns.txt file with all the warnings.  Or alternatively
if you just want to check one file then the command is:

	~/progs/smatch/devel/smatch_scripts/kchecker drivers/file.c

regards,
dan carpenter
