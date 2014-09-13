Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaIMViJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 17:38:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaIMViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 17:38:08 -0400
Date: Sat, 13 Sep 2014 17:38:05 -0400 (EDT)
Message-Id: <20140913.173805.566607253438396851.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: ast@plumgrid.com, keescook@chromium.org, hannes@stressinduktion.org,
        dborkman@redhat.com, spender@grsecurity.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bpf: correctly handle errors in sk_attach_filter()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410581190-31922-1-git-send-email-sasha.levin@oracle.com>
References: <1410581190-31922-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Sep 2014 14:38:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Sat, 13 Sep 2014 00:06:30 -0400

> Commit "net: bpf: make eBPF interpreter images read-only" has changed bpf_prog
> to be vmalloc()ed but never handled some of the errors paths of the old code.
> 
> On error within sk_attach_filter (which userspace can easily trigger), we'd
> kfree() the vmalloc()ed memory, and leak the internal bpf_work_struct.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied.
