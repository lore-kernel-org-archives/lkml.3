Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaJ0T5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:57:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50420 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaJ0T47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:56:59 -0400
Date: Mon, 27 Oct 2014 15:56:56 -0400 (EDT)
Message-Id: <20141027.155656.1414383076601514662.davem@davemloft.net>
To: dvhart@linux.intel.com
CC: linux-kernel@vger.kernel.org
Subject: futex testsuite suggestion...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 12:56:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First of all, thanks so much for writing your futex test suite, it's
proved invaluable for sparc64 kernel development for me lately.

I'd like to suggest that you add a test that triggers transparent
hugepages, because if an architecture doesn't implement
__get_user_pages_fast() such futexes cause a machine to hang.

I hacked up something simple that took the existing performance
test and made it operate in a register allocated using memalign().

I would suggest doing a memalign(HUGEPAGE_SIZE, HUGEPAGE_SIZE) then
iterating running a futex test within each normal page within that
hugepage.

Thanks!
