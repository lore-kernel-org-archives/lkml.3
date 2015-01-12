Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbbALLp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:45:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36125 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbALLpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:45:23 -0500
Date: Mon, 12 Jan 2015 14:45:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: smatch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: smatch v1.60 released
Message-ID: <20150112114515.GC7568@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intro:

Smatch is a C static checker with a lot of kernel specific checks.  You
can download it from:  http://repo.or.cz/w/smatch.git.

Notes:

It has been a year and a half since the last release so there have been
a lot of changes everywhere.  The main thing continues to be tracking
values across function calls.

One warning I'm particularly proud of resulted in this patch:
https://lkml.org/lkml/2015/1/6/1034
To make that work, then Smatch traced the data down three normal
calls and across a function pointer call and returned that one of the
function pointers didn't initialize *count.  Smatch is the only open
source project trying to do this level of cross function analysis.

The cross function database is so useful on it's own if you are trying
to understand a new subsystem.  Just build the database and then you
can run `smdb.py function_name` to see how it's called and which values
are passed.  Maybe it's called as a function pointer so using grep and
cscope doesn't work.  Or maybe you wanted to see where the family in
(struct net_proto_family)->family is set you could run
`smdb.py where net_proto_family family`.

Quickstart Guide:

The command to set up the database is:
~/path/to/smatch/smatch_scripts/build_kernel_data.sh
This command takes 2-3 hours to complete.  You can skip this step if you
want.

To run smatch on the kernel source:
~/path/to/smatch/smatch_scripts/test_kernel.sh
This creates a warns.txt file with the warnings.

To test a specific file:
~/path/to/smatch/smatch_scripts/kchecker drivers/file.c

regards,
dan carpenter
