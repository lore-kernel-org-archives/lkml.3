Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaC0TXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:23:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57052 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaC0TXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:23:24 -0400
Date: Thu, 27 Mar 2014 15:23:19 -0400 (EDT)
Message-Id: <20140327.152319.1469721259196062415.davem@davemloft.net>
To: dborkman@redhat.com
Cc: ast@plumgrid.com, netdev@vger.kernel.org, hagen@jauu.net,
        keescook@chromium.org, pmoore@redhat.com, mingo@kernel.org,
        hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 8/9] net: filter: rework/optimize internal
 BPF interpreter's instruction set
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395867970-1338-9-git-send-email-dborkman@redhat.com>
References: <1395867970-1338-1-git-send-email-dborkman@redhat.com>
	<1395867970-1338-9-git-send-email-dborkman@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Mar 2014 12:23:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 26 Mar 2014 22:06:09 +0100

>   - Adds swab insns for 32/64-bit

I don't like this.

You don't want a swab instruction, you want "endian X to endian Y".  Just
like we have "cpu_to_le32()", "le32_to_cpu()" et al. in the kernel.

That way the user can be completely oblivious as to the endianness of
the cpu it's running on.

So if you ask for a "to little endian" swab, if the chip is
little-endian then no code needs to be emitted at all, it's a nop.

There is zero reason for the BPF program emitted by userspace to be
dependant upon the cpu endianness.
