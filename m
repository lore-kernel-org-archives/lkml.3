Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbaKLCoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:44:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36612 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbaKLCoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:44:07 -0500
Date: Tue, 11 Nov 2014 21:44:02 -0500 (EST)
Message-Id: <20141111.214402.693686900755542775.davem@davemloft.net>
To: shuahkh@osg.samsung.com
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/net: psock_fanout seg faults in
 sock_fanout_read_ring()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415725453-6549-1-git-send-email-shuahkh@osg.samsung.com>
References: <1415725453-6549-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 18:44:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuahkh@osg.samsung.com>
Date: Tue, 11 Nov 2014 10:04:13 -0700

> The while loop in sock_fanout_read_ring() checks mmap region
> bounds after access, causing it to segfault. Fix it to check
> count before accessing header->tp_status. This problem can be
> reproduced consistently when the test in run as follows:
> 
>     make -C tools/testing/selftests TARGETS=net run_tests
>     or
>     make run_tests from tools/testing/selftests
>     or
>     make run_test from tools/testing/selftests/net
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Definitely looks correct to me, applied, thanks.
