Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbaGOXF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:05:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45382 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaGOXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:05:56 -0400
Date: Tue, 15 Jul 2014 16:05:55 -0700 (PDT)
Message-Id: <20140715.160555.407533257702039786.davem@davemloft.net>
To: jlayton@primarydata.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH] net: clean up some sparse endianness warnings in ipv6.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405340746-10678-1-git-send-email-jlayton@primarydata.com>
References: <1405340746-10678-1-git-send-email-jlayton@primarydata.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Jul 2014 16:05:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@primarydata.com>
Date: Mon, 14 Jul 2014 08:25:46 -0400

>  #endif
> -		(a->s6_addr32[2] ^ htonl(0x0000ffff))) == 0UL;
> +		((a->s6_addr32[2] ^ htonl(0x0000ffff)) == cpu_to_be32(0)));

While you are spinning a new version, change this htonl() to be
cpu_to_be32().  All the rest of this entire expression uses the
cpu_to_*() interfaces, so for consistency this should too.

Thanks.
