Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaAOVd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:33:56 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:61412 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAOVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:33:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hzNT15R41zSOM98f-0aQ60HBZoD_DAvf6VED7iXoCZ8w@mail.gmail.com>
References: <20140114004509.27138.50345.stgit@viggo.jf.intel.com>
	<20140114004622.27138.54103.stgit@viggo.jf.intel.com>
	<CAMAG_eduH4M2OPVh-R4Q6KG1DDcinEDzC-fQyXj1mLdZG=49hw@mail.gmail.com>
	<CAPcyv4hzNT15R41zSOM98f-0aQ60HBZoD_DAvf6VED7iXoCZ8w@mail.gmail.com>
Date: Wed, 15 Jan 2014 13:33:52 -0800
Message-ID: <CAPcyv4ixMVV5-9NPR_Nx-hgwAGBS8uh1DQabjimCaNfYt30kiA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] net_dma: simple removal
From: Dan Williams <dan.j.williams@intel.com>
To: saeed bishara <saeed.bishara@gmail.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Whipple <whipple@securedatainnovations.ch>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 1:31 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Jan 15, 2014 at 1:20 PM, saeed bishara <saeed.bishara@gmail.com> wrote:
>> Hi Dan,
>>
>> I'm using net_dma on my system and I achieve meaningful performance
>> boost when running Iperf receive.
>>
>> As far as I know the net_dma is used by many embedded systems out
>> there and might effect their performance.
>> Can you please elaborate on the exact scenario that cause the memory corruption?
>>
>> Is the scenario mentioned here caused by "real life" application or
>> this is more of theoretical issue found through manual testing, I was
>> trying to find the thread describing the failing scenario and couldn't
>> find it, any pointer will be appreciated.
>
> Did you see the referenced commit?
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=77873803363c
>
> This is a real issue in that any app that forks() while receiving data
> can cause the dma data to be lost.  The problem is that the copy
> operation falls back to cpu at many locations.  Any one of those
> instance could touch a mapped page and trigger a copy-on-write event.
> The dma completes to the wrong location.
>

Btw, do you have benchmark data showing that NET_DMA is beneficial on
these platforms?  I would have expected worse performance on platforms
without i/o coherent caches.
