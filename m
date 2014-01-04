Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaADA26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:28:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35329 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaADA25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:28:57 -0500
Date: Fri, 03 Jan 2014 19:28:54 -0500 (EST)
Message-Id: <20140103.192854.273068375296010465.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, dm@chelsio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4: allow large buffer size to have page size
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387820069-13623-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1387820069-13623-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 Jan 2014 16:28:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Mon, 23 Dec 2013 15:34:29 -0200

> Since commit 52367a763d8046190754ab43743e42638564a2d1
> ("cxgb4/cxgb4vf: Code cleanup to enable T4 Configuration File support"),
> we have failures like this during cxgb4 probe:
> 
> cxgb4 0000:01:00.4: bad SGE FL page buffer sizes [65536, 65536]
> cxgb4: probe of 0000:01:00.4 failed with error -22
> 
> This happens whenever software parameters are used, without a
> configuration file. That happens when the hardware was already
> initialized (after kexec, or after csiostor is loaded).
> 
> It happens that these values are acceptable, rendering fl_pg_order equal
> to 0, which is the case of a hard init when the page size is equal or
> larger than 65536.
> 
> Accepting fl_large_pg equal to fl_small_pg solves the issue, and
> shouldn't cause any trouble besides a possible performance reduction
> when smaller pages are used. And that can be fixed by a configuration
> file.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

I've given the cxgb4 maintainers more than a week to get around to reviewing
this, but they haven't.

It's entirely unreasonable for you to have to wait just because they haven't
done so.

So I've applied your patch, thank you.
