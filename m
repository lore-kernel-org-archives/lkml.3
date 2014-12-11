Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbaLKEeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:34:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50265 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaLKEeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:34:44 -0500
Date: Wed, 10 Dec 2014 23:34:42 -0500 (EST)
Message-Id: <20141210.233442.1443408250525657088.davem@davemloft.net>
To: ast@plumgrid.com
Cc: fengguang.wu@intel.com, davej@redhat.com, dborkman@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sock: fix access via invalid file
 descriptor
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418271295-5829-1-git-send-email-ast@plumgrid.com>
References: <1418271295-5829-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 20:34:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 10 Dec 2014 20:14:55 -0800

> 0day robot reported the following crash:
> [   21.233581] BUG: unable to handle kernel NULL pointer dereference at 0000000000000007
> [   21.234709] IP: [<ffffffff8156ebda>] sk_attach_bpf+0x39/0xc2
> 
> It's due to bpf_prog_get() returning ERR_PTR.
> Check it properly.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Fixes: 89aa075832b0 ("net: sock: allow eBPF programs to be attached to sockets")
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> Silly mistake. I was sure I've checked this error path. Apparently not :(

Applied, thanks Alexei.
