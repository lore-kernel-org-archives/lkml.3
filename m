Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaARBxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 20:53:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41254 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaARBxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 20:53:02 -0500
Date: Fri, 17 Jan 2014 17:52:59 -0800 (PST)
Message-Id: <20140117.175259.1030142896492431310.davem@davemloft.net>
To: gerald.schaefer@de.ibm.com
Cc: davidshan@tencent.com, cl@linux.com, venkat.x.venkatsubra@oracle.com,
        rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        frank.blaschka@de.ibm.com, sebott@linux.vnet.ibm.com
Subject: Re: [PATCH] net: rds: fix per-cpu helper usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389887688-55632-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1389887688-55632-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Date: Thu, 16 Jan 2014 16:54:48 +0100

> commit ae4b46e9d "net: rds: use this_cpu_* per-cpu helper" broke per-cpu
> handling for rds. chpfirst is the result of __this_cpu_read(), so it is
> an absolute pointer and not __percpu. Therefore, __this_cpu_write()
> should not operate on chpfirst, but rather on cache->percpu->first, just
> like __this_cpu_read() did before.
> 
> Cc: <stable@vger.kernel.org> # 3.8+
> Signed-off-byd Gerald Schaefer <gerald.schaefer@de.ibm.com>

Applied and queued up for -stable, thanks.
