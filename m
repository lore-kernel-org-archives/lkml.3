Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3GOIPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:15:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29885 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3GOIPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:15:22 -0400
Date: Mon, 15 Jul 2013 11:15:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: smatch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: smatch v1.59 released
Message-ID: <20130715081513.GA16280@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch is a C static checker with a lot of kernel specific checks.

This release has several new tricks:

1) Small functions are parsed inline now.  That makes it more accurate
and now even without the database configured, you have at least some
cross function analysis.

2) The way smatch handles math was completely rewritten and should be
more accurate.

3) Comparisons between variables are recorded.  So even if you don't
know the return value, maybe you know that it is less than or equal to
parameter 2.  (This requires the database to be set up).

Btw, having the database set up is super useful for understanding code.
Say you want to know how lifebook_limit_serio3() is called you can type:
`smbdb.py lifebook_limit_serio3` and it's simple enough to see that
(struct dmi_system_id)->callback() is called from dmi_check_system().

The command to set up the database is:
~/path/to/smatch/smatch_scripts/build_kernel_data.sh

To run smatch on the kernel source:
~/path/to/smatch/smatch_scripts/test_kernel.sh

To test a specific file:
~/path/to/smatch/smatch_scripts/kchecker drivers/file.c

regards,
dan carpenter

