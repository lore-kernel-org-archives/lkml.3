Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbbAFWV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:21:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56409 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbAFWVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:21:55 -0500
Date: Tue, 06 Jan 2015 17:21:52 -0500 (EST)
Message-Id: <20150106.172152.2034122593693302134.davem@davemloft.net>
To: maarten.lankhorst@canonical.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] unlock rtnl mutex in ic_open_devs while waiting
From: David Miller <davem@davemloft.net>
In-Reply-To: <54AA9706.5020202@canonical.com>
References: <54AA9706.5020202@canonical.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 14:21:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date: Mon, 05 Jan 2015 14:52:06 +0100

> This fixes a deadlock with alx_link_check, which takes the rtnl_mutex in
> a work item to check the link.
> 
> I have no idea whether alx should be fixed or ipconfig.c,
> but this saves 120 seconds off my boot time. ;-)
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

I genuinely think that alx_link_check() needs to use a smaller hammer
to do it's locking, there is no reason to use the RTNL mutex.

A driver private mutex will probably work just as well and not have
this problem.
