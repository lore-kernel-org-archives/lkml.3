Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaLSBBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:01:47 -0500
Received: from message.langara.bc.ca ([209.87.29.115]:40860 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLSBBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:01:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Message-id: <fb6dd1a5bb7e.549378f9@langara.bc.ca>
Date: Fri, 19 Dec 2014 01:01:45 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: When should I not use CLONE_IO?
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently GLibc does not use CLONE_IO and does not expose a way to use CLONE_IO
(for threads which are where it'd be most useful I assume). The documentation is
unclear though and leaves me in the dark about a lot. For example, I don't see
why GLibc shouldn't use CLONE_IO with every thread by default. Also, it seems to
me that if threads share I/O contexts they should also have to share I/O
schedulers right? Does this mean that if threads share I/O contexts with
CLONE_IO that sched_setscheduler either severs the I/O context sharing or sets
the same scheduler for both of them? Even if the threads sharing the same I/O
context must use the same scheduler can they have different priorities?

Thank you,
Steven Stewart-Gallus
