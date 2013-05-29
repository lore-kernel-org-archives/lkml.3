Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966903Ab3E2VcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:32:15 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55600 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965980Ab3E2VcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:32:04 -0400
Date: Wed, 29 May 2013 23:32:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        paulus@samba.org, michael@ellerman.id.au,
        Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [RFC PATCH v3 0/5] powerpc: Support context tracking for Power
 pSeries
Message-ID: <20130529213159.GD17419@somewhere>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
 <1368424306.19924.20.camel@pasglop>
 <1368432193.2618.30.camel@ThinkPad-T5421>
 <1368435563.19924.28.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368435563.19924.28.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 06:59:23PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-13 at 16:03 +0800, Li Zhong wrote:
> > 
> > To my understanding, it is used to enable RCU user extended quiescent
> > state, so RCU on that cpu doesn't need scheduler ticks. And together
> > with some other code(already in 3.10), we are able to remove the ticks
> > in some cases (e.g. only 1 task running on the cpu, with some other
> > limitations).
> 
> Ok, sounds interesting. Once you fix the little cosmetic issue, I don't
> see any reason not to merge them as it's basically wiring up an existing
> feature (in that regard the patches are pretty straightforward) and I
> assume the overhead is only there when you enable it.

Yeah when CONFIG_RCU_USER_QS=n and CONFIG_VIRT_CPU_ACCOUNTING_GEN=n this
should be zero overhead. And those configs are only needed for full dynticks.

Thanks.

> 
> Cheers,
> Ben.
> 
> 
