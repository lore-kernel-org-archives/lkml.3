Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJQUsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:48:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42625 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaJQUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:48:40 -0400
Date: Fri, 17 Oct 2014 16:48:38 -0400 (EDT)
Message-Id: <20141017.164838.1035248404947187957.davem@davemloft.net>
To: emunson@akamai.com
Cc: netdev@vger.kernel.org, andy@greyhouse.net, vfalico@gmail.com,
        j.vosburgh@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move rlb table dump to procfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413571313-10137-1-git-send-email-emunson@akamai.com>
References: <1413571313-10137-1-git-send-email-emunson@akamai.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Oct 2014 13:48:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <emunson@akamai.com>
Date: Fri, 17 Oct 2014 14:41:52 -0400

> Because debugfs is not net namespace aware, it is currently not
> possible to dump the RLB hash table when network namespaces are enabled.
> This patch creates a second proc file called IFNAME_rlb_table for
> bonding interfaces that use adaptive load balancing which will expose
> this table to userspace.  It also removes all the debugfs code from the
> bonding module as the RLB hash was the only entry in debugfs.
> 
> Signed-off-by: Eric B Munson <emunson@akamai.com>

It's meant to be a debugging facility, which has no stable API
and is not something the user can depend upon it.

Once you move it to procfs, it's basically over and we are
stuck with this forever.

I think the intention of this meaning to be a debug facility for
developers is very clear.

I'm not applying this, sorry.
