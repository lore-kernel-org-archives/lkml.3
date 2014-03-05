Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaCEAV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:21:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38903 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbaCEAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:21:56 -0500
Date: Tue, 04 Mar 2014 19:21:52 -0500 (EST)
Message-Id: <20140304.192152.1234652192226780071.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: akpm@linux-foundation.org, rgb@redhat.com, eparis@redhat.com,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket
 buffer is large enough
From: David Miller <davem@davemloft.net>
In-Reply-To: <87mwh5d1tf.fsf@xmission.com>
References: <20140304133004.b565820f60f595a48e621e58@linux-foundation.org>
	<20140304.165122.445822929490466603.davem@davemloft.net>
	<87mwh5d1tf.fsf@xmission.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Mar 2014 16:21:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 04 Mar 2014 14:41:16 -0800

> If we really want the ability to always appened to the queue of skb's
> is to just have a version of netlink_send_skb that ignores the queued
> limits.  Of course an evil program then could force the generation of
> enough audit records to DOS the kernel, but we seem to be in that
> situation now.  Shrug.

There is never a valid reason to bypass the socket limits.

It protects the system from things going out of control.

Netlink packet sends can fail, and audit should cope with that
event instead of trying to bludgeon it into not happening.
