Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbbAZVcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:32:50 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39740 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbbAZVcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:32:45 -0500
Message-ID: <1422307962.29618.31.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] drivers: net: xgene: fix: Out of order descriptor bytes
 read
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Iyappan Subramanian <isubramanian@apm.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        mlangsdo@redhat.com, patches <patches@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Date: Mon, 26 Jan 2015 13:32:42 -0800
In-Reply-To: <1422307652.29618.30.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1421957007-720-1-git-send-email-isubramanian@apm.com>
	 <1421967050.3471.14.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAKh23FmxvV82mVrHq5jv-FE+e6u6CkW+xL_a2_ULAQgP_mM2VA@mail.gmail.com>
	 <1422307652.29618.30.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 13:27 -0800, Eric Dumazet wrote:

> What happens if you compile a kernel with CONFIG_SMP=n ?
> 
> 
> Most drivers in drivers/net use rmb() in this case, not smp_rmb() or
> barrier()

Note that dma_rmb() was recently added as well.



