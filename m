Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaIOTkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:40:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46326 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaIOTkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:40:10 -0400
Message-ID: <54174082.4010008@ti.com>
Date: Mon, 15 Sep 2014 14:39:46 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Dave Gerlach <d-gerlach@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Robert Tivy <rtivy@ti.com>
Subject: Re: [PATCH 2/2] remoteproc: add support to handle internal memories
References: <1404836521-59637-1-git-send-email-s-anna@ti.com> <1404836521-59637-3-git-send-email-s-anna@ti.com> <CAK=WgbY-WmcJdnLHDf1CSkJqNBUeUMPTLcEZyLGKnECbxH1OAQ@mail.gmail.com> <53D7F6F3.9020804@ti.com> <CAK=WgbZ+NhA5AAhURUOojwnCbi2wYkJ11i-C5e7-kpZL5vD_3g@mail.gmail.com>
In-Reply-To: <CAK=WgbZ+NhA5AAhURUOojwnCbi2wYkJ11i-C5e7-kpZL5vD_3g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> On Tue, Jul 29, 2014 at 10:33 PM, Suman Anna <s-anna@ti.com> wrote:
>> We currently have two usecases. The primary usecase is the WkupM3
>> processor on TI Sitara AM335x/AM437x SoCs used for suspend/resume
>> management. This series is a dependency for the WkupM3 remoteproc driver
>> that Dave posted [1]. More details are in section 8.1.4.6 of the AM335x
>> TRM [2]. The program/data sections for this processor all _needs_ to be
>> in the two internal memory RAMS (16K Unified RAM and 8K Data RAM), and
>> there is no MMU for this processor. The current RSC_CARVEOUT and
>> RSC_DEVMEM do not fit to describe this type of memory (we neither
>> allocate memory through dma api nor do we need to map these into an MMU).
> 
> Thanks for the details.
> 
> Can we define a CMA block for these regions, and then just use
> carveout resource entries instead of the ioremap approach?

I am looking at refreshing these patches, and found that I missed
responding to this message.

These processors need to use their internal RAM for loading, which is
not for generic usage by the kernel, so defining a CMA block for this
memory doesn't make sense.

> This may require some changes in remoteproc which we'll need to think
> about, but it sounds like it may fit the problem better instead of
> forcing ioremap to provide a regular pointer (we're supposed to use
> ioremaped memory only with memory primitives such as readl/writel/..).

Will it suffice to replace the memcpy() with memcpy_toio()?

regards
Suman
