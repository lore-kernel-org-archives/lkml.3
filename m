Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3FSOqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:46:24 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40243 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3FSOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:46:23 -0400
Date: Wed, 19 Jun 2013 16:46:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, acme@redhat.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 15/15] perf, tools: Add perf stat --transaction v3
Message-ID: <20130619144621.GW6123@two.firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
 <1366485563-16209-16-git-send-email-andi@firstfloor.org>
 <20130619085159.GA25177@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619085159.GA25177@concordia>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This hard coded list isn't going to work for us on powerpc.
> 
> We don't have HLE, so we won't ever have an event for el-start.
> 
> I don't quite grok what the cycles-ct is about, checkpointed cycles?

The counter is check pointed on a transaction start, and set back to
the checkpoint when an abort happens. This allows to count the cycles
wasted in aborts, when you subtract from cycles-t.

> But I don't think we have anything equivalent.

But you have cycles-t and tx-start?

I can make el-start, cycles-ct optional

> I guess the simplest option is to make it a per-arch list inside the
> perf tool?

I'm not sure that would be acceptable to the perf maintainers.
Although I'm just guessing, I haven't heard any comments on
this patch recently.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
