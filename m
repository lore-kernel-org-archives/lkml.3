Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3FXBgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:36:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34993 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3FXBgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:36:45 -0400
Date: Sun, 23 Jun 2013 18:36:44 -0700 (PDT)
Message-Id: <20130623.183644.1085376304838914809.davem@davemloft.net>
To: wedsonaf@gmail.com
Cc: tgraf@suug.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [NET]: Unmap fragment page once iterator is done
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371257669-21115-1-git-send-email-wedsonaf@gmail.com>
References: <1371257669-21115-1-git-send-email-wedsonaf@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Fri, 14 Jun 2013 17:54:29 -0700

> Callers of skb_seq_read() are currently forced to call skb_abort_seq_read()
> even when consuming all the data because the last call to skb_seq_read (the
> one that returns 0 to indicate the end) fails to unmap the last fragment page.
> 
> With this patch callers will be allowed to traverse the SKB data by calling
> skb_prepare_seq_read() once and repeatedly calling skb_seq_read() as originally
> intended (and documented in the original commit 677e90eda), that is, only call
> skb_abort_seq_read() if the sequential read is actually aborted.
> 
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>

If you're going to do this I want you to get rid of the now-extraneous
skb_abort_seq_read() calls at the same time.

Thanks.
