Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3H2LY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:24:59 -0400
Received: from relay.parallels.com ([195.214.232.42]:38539 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3H2LY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:24:57 -0400
Message-ID: <521F2F7E.8010702@parallels.com>
Date: Thu, 29 Aug 2013 15:24:46 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the akpm-current tree
References: <20130829194741.ff75bb1ce06207d5d3a703de@canb.auug.org.au>
In-Reply-To: <20130829194741.ff75bb1ce06207d5d3a703de@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

08/29/2013 01:47 PM, Stephen Rothwell пишет:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (sparc64 defconfig
> and others) produced these warnings:
>
> mm/page-writeback.c: In function 'balance_dirty_pages_ratelimited':
> mm/page-writeback.c:1450:13: warning: 'bdi_thresh' may be used uninitialized in this function [-Wuninitialized]
> mm/page-writeback.c:1372:16: note: 'bdi_thresh' was declared here
> mm/page-writeback.c:1226:16: warning: 'bdi_dirty' may be used uninitialized in this function [-Wuninitialized]
> mm/page-writeback.c:1369:16: note: 'bdi_dirty' was declared here
>
> Possibly introduced by commit 34c547af1e23 ("mm/page-writeback.c: add
> strictlimit feature"), but I am not sure anything can be done about them.
>

This looks as gcc glitch. So far as I didn't observe the warnings, the 
version of gcc does matter. May be moving the definitions of the two 
variables into for(;;){...} would help. Could you please give it a try?

Thanks,
Maxim
