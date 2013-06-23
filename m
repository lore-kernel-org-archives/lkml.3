Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3FWR0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 13:26:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48600 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3FWR0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 13:26:40 -0400
Date: Sun, 23 Jun 2013 12:26:32 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Question: DLPAR remove with mounted partitions.
Message-ID: <20130623172632.GA5685@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062317-7182-0000-0000-0000077B1198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a question regarding a DLPAR remove operations with a mounted
partition.

I am writing a block level device driver that will support DLPAR remove
operations and I was doing some testing with a partition from the adapter
still mounted while I ran a DLPAR remove.

The remove completed successfully and lspci doesn't list my device
anymore. However, I ran the 'df' command and noticed that the partition
was still listed in the output. I, then, ran an 'ls' on the mount point
for that partition and a Kernel Panic occured.

I fixed the panic by setting the queuedata member to NULL in the
request_queue object and checking the request_queue for a NULL queuedata
in the make_request function.

My main question is this: Should the Kernel allow for a successful DLPAR
remove while there are still reference counts still active on the
device? If so, is my implementation the correct way to countering the issue?

Thanks in advance.

Regards,
-Philip Kelleher

