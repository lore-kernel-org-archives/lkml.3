Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaEIDUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:20:24 -0400
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:58909 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaEIDUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:20:23 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2014 23:20:23 EDT
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        linux-security-module@vger.kernel.org, eparis@redhat.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <cover.1399554584.git.d.kasatkin@samsung.com>
References: <cover.1399554584.git.d.kasatkin@samsung.com>
Date: Fri, 09 May 2014 12:10:03 +0900
Message-ID: <29977.1399605003@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dmitry Kasatkin:
> Following patch replaces IMA usage of kernel_read() with special
> version which skips security check that triggers kernel panic
> when Apparmor and IMA appraisal are enabled together.

I know this is related to exit(2), but this behaviour of IMA is related
to open(2) too.
When O_DIRECT is specified, some filesystems (for example, ext2) call
do_blockdev_direct_IO() which acquires i_mutex. But
IMA:process_measurement() already acquires i_mutex before kernel_read().
It causes a deadlock even if you replace kernel_read() by a simpler one.
How can we stop reading the file from IMA?


J. R. Okajima
