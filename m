Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaFDWMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:12:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37374 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaFDWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:12:04 -0400
Date: Wed, 04 Jun 2014 15:12:02 -0700 (PDT)
Message-Id: <20140604.151202.2143622064529754958.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH] net: Revert "fib_trie: use seq_file_net rather than
 seq->private"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401919352-32263-1-git-send-email-sasha.levin@oracle.com>
References: <1401919352-32263-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Jun 2014 15:12:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Wed,  4 Jun 2014 18:02:32 -0400

> This reverts commit 30f38d2fdd79f13fc929489f7e6e517b4a4bfe63.
> 
> fib_triestat is surrounded by a big lie: while it claims that it's a
> seq_file (fib_triestat_seq_open, fib_triestat_seq_show), it isn't:
> 
> 	static const struct file_operations fib_triestat_fops = {
> 	        .owner  = THIS_MODULE,
> 	        .open   = fib_triestat_seq_open,
> 	        .read   = seq_read,
> 	        .llseek = seq_lseek,
> 	        .release = single_release_net,
> 	};
> 
> Yes, fib_triestat is just a regular file.
> 
> A small detail (assuming CONFIG_NET_NS=y) is that while for seq_files
> you could do seq_file_net() to get the net ptr, doing so for a regular
> file would be wrong and would dereference an invalid pointer.
> 
> The fib_triestat lie claimed a victim, and trying to show the file would
> be bad for the kernel. This patch just reverts the issue and fixes
> fib_triestat, which still needs a rewrite to either be a seq_file or
> stop claiming it is.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks a lot for catching this, applied.
