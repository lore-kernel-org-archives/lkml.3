Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3BRQnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:43:51 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:56129 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3BRQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:43:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130205214818.4615.12937.stgit@lambeau>
References: <20130205214818.4615.12937.stgit@lambeau>
Date: Mon, 18 Feb 2013 17:43:47 +0100
Message-ID: <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, gleb@redhat.com,
        kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, anthony@codemonkey.ws
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
> In the case of where you have a system that is running in a
> capped or overcommitted environment the user may see steal time
> being reported in accounting tools such as top or vmstat.  This can
> cause confusion for the end user.

Sorry, I'm no expert in this area. But I don't really understand what
is confusing for the end user here.

> To ease the confusion this patch set
> adds the idea of consigned (expected steal) time.  The host will separate
> the consigned time from the steal time.  Tthe steal time will only be altered
> if hard limits (cfs bandwidth control) is used.  The period and the quota used
> to separate the consigned time (expected steal) from the steal time are taken
> from the cfs bandwidth control settings. Any other steal time accruing during
> that period will show as the traditional steal time.

I'm also a bit confused here. steal time will then only account the
cpu time lost due to quotas from cfs bandwidth control? Also what do
you exactly mean by "expected steal time"? Is it steal time due to
overcommitting minus scheduler quotas?

Thanks.
