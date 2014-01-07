Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaAGGla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:41:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21730 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaAGGl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:41:28 -0500
Date: Tue, 7 Jan 2014 09:41:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: fengguang.wu@intel.com, jim.epost@gmail.com, sfr@canb.auug.org.au,
        gregkh@linuxfoundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@01.org
Subject: Re: [PATCH 1/2] GenWQE: Fix endian issues detected by sparse
Message-ID: <20140107064130.GA5494@mwanda>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
 <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you also fix this Smatch warning?
drivers/misc/genwqe/card_dev.c:658 do_flash_update() warn: maybe return -EFAULT instead of the bytes remaining?

Also we shouldn't be doing dev_err() on copy_to/from_user() problems.
The user can trigger those and flood dmesg.  It is a DoS (annoying).

regards,
dan carpenter

