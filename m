Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaJJTEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:04:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56075 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaJJTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:03:59 -0400
Date: Fri, 10 Oct 2014 15:03:57 -0400 (EDT)
Message-Id: <20141010.150357.694076940362545829.davem@davemloft.net>
To: ast@plumgrid.com
Cc: sojkam1@fel.cvut.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bpf: fix bpf syscall dependence on anon_inodes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412893001-8401-1-git-send-email-ast@plumgrid.com>
References: <1412893001-8401-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Oct 2014 12:03:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Thu,  9 Oct 2014 15:16:41 -0700

> minimal configurations where EPOLL, PERF_EVENTS, etc are disabled,
> but NET is enabled, are failing to build with link error:
> kernel/built-in.o: In function `bpf_prog_load':
> syscall.c:(.text+0x3b728): undefined reference to `anon_inode_getfd'
> 
> fix it by selecting ANON_INODES when NET is enabled
> 
> Reported-by: Michal Sojka <sojkam1@fel.cvut.cz>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> 
> I understand that 'select' is highly non-recommended for all good reasons,
> but here 'depends on' is very user unfriendly, since ANON_INODES is
> a hidden config that users cannot select directly.

Applied, thanks.
