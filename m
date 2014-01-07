Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaAGTLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:11:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaAGTLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:11:17 -0500
Date: Tue, 07 Jan 2014 14:11:15 -0500 (EST)
Message-Id: <20140107.141115.513158198056746890.davem@davemloft.net>
To: ethan.kernel@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: replace __GFP_NOFAIL with GFP_ATOMIC in
 mdesc_kmalloc()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389087077-311-1-git-send-email-ethan.kernel@gmail.com>
References: <1389087077-311-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 07 Jan 2014 11:11:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ethan Zhao <ethan.kernel@gmail.com>
Date: Tue,  7 Jan 2014 17:31:17 +0800

> Has kmalloc() failure checking there, so it is unnecessary to allocate with
> __GFP_NOFAIL flag that might block forever.
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>

This allocation failing borders on catastrophic.  The allocation failure
handling is just for looks.

This function is triggered when the firmware tells us that new cpus or
other devices are available.  This memory being allocated will hold
the machine description that we traverse to find those new devices.

If this allocation is allowed to fail, we will never have any way to
get the notification again.  It really is __GFP_NOFAIL and must
succeed.

I'm not applying this, sorry.
