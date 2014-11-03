Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaKCJgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:36:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11753 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaKCJgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:36:40 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-41-54574ca5c6a1
Content-transfer-encoding: 8BIT
Message-id: <1415007395.4241.18.camel@AMDC1943>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 03 Nov 2014 10:36:35 +0100
In-reply-to: <3452823.YQ5FR2FtKz@avalon>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <20141031142241.GA17547@amd> <1414766416.6537.6.camel@AMDC1943>
 <3452823.YQ5FR2FtKz@avalon>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t/xa7pLfcJDDJa+YbPYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF2aY37BZLJs9nteicuITdYtaUvUwWC9uWsFhc3jWHzeJz7xFGi9uXeS3W
	HrnLbvHuZYTF3VNH2SzOnL7EajHh9wU2i+Nrwy1e9u1ncRD2aGnuYfOY3TGT1WPxnpdMHneu
	7WHzWNw3mdVjyZtDrB5brrazeMy++4PRo2/LKkaPFau/s3t83iTnsffzb5YAnigum5TUnMyy
	1CJ9uwSujO8fr7MVTJeqeHP+FGMD43mRLkZODgkBE4mtWxtYIWwxiQv31rN1MXJxCAksZZR4
	MekaO0iCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+ZUeL8xsNsEPX6EpcudzCB
	2MIC4RL3l20BW8AmYCyxefkSsBoRAQuJ3kXTGUGamQVWsUp8XLuYCWQBi4CqxPZn0iA1nAIa
	Er8n9kEdtJxRoulnByNIjYSAskRjv9sERoFZSM6bhXDeLCTnLWBkXsUomlqaXFCclJ5rqFec
	mFtcmpeul5yfu4kREptfdjAuPmZ1iFGAg1GJh3fC5bAQIdbEsuLK3EOMEhzMSiK8PTrhIUK8
	KYmVValF+fFFpTmpxYcYmTg4pRoYi5vMbQNYuBv6GIKOqxhPfnNDgjVgysp8Na61K6UXVgox
	7/nO7jBnMjNj+792pv4Hm12PyHZvvv3vyDW51ZpT08Nt/NVVZV+um2dx8tNjN99/2vI/1HWX
	9W7U7HFq15p1Pf7X+7/rfie9PBx+LDSG+abytTunLH4qbi/4FV2k5rmpK3tFTsorJZbijERD
	Leai4kQA7cO6C6sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sob, 2014-11-01 at 02:29 +0200, Laurent Pinchart wrote:
> Hi Krzysztof,
> 
> On Friday 31 October 2014 15:40:16 Krzysztof Kozlowski wrote:
> > On pią, 2014-10-31 at 15:22 +0100, Pavel Machek wrote:
> > > On Fri 2014-10-31 10:14:55, Krzysztof Kozlowski wrote:
> > >> On pon, 2014-10-20 at 11:04 +0200, Krzysztof Kozlowski wrote:
> > >>> Add a simple getter pm_runtime_is_irq_safe() for querying whether
> > >>> runtime PM IRQ safe was set or not.
> > >>> 
> > >>> Various bus drivers implementing runtime PM may use choose to suspend
> > >>> differently based on IRQ safeness status of child driver (e.g. do not
> > >>> unprepare the clock if IRQ safe is not set).
> > >>> 
> > >>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > >>> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> > >> 
> > >> Rafael, Len, Pavel,
> > >> 
> > >> Is proposed API ok? Do you have any comments?
> > >> 
> > >> I'll upload whole patchset to Russell's patch tracking system. However
> > >> an ack from PM maintainer is probably needed.
> > > 
> > > I don't like the API. Having callbacks work in different context (irq
> > > / noirq) based on what another function reports is ugly.
> > > 
> > > What is the penalty if we always decide callbacks are not IRQ safe?
> > 
> > Then pm_runtime_get_sync() could not be called in atomic context. The
> > pl330 runtime PM would have to be completely reworked because one
> > pm_runtime_get_sync() is called in device_issue_pending which cannot
> > sleep (at least in non preemptible kernels). Probably this can be solved
> > some way...
> 
> Many other drivers suffer from the same problem. While I won't reject your 
> proposed fix, I would prefer a more generic approach.
> 
> One option that has been discussed previously was to use a work queue to delay 
> starting the DMA transfer to an interruptible context where 
> pm_runtime_get_sync() could be called. However, as Russell pointed out [1], 
> even that won't work in all cases as the DMA slave might need the transfer to 
> be started before enabling part of its hardware (OMAP audio seem to be such a 
> case).
> 
> I've heard a rumor of a possible DMA engine rework to forbid calling the 
> descriptor preparation API from atomic context. This could be used as a base 
> to implement runtime PM, as DMA slave drivers should not prepare descriptors 
> if they don't need to use them. However that's a long term plan, and we need a 
> solution sooner than that.
> 
> I've been toying with the idea of adding explicit open/close (or whatever we 
> would call them) operations to the DMA engine API. Those would be used by DMA 
> slave drivers to signal that they will start/stop using the DMA engine.
> 
> If (1) we must start the DMA synchronously with a DMA slave call, (2) need to 
> sleep to handle PM, and (3) don't want to keep the DMA engine powered for as 
> long as one channel is requested, then we need to turn at least preparation as 
> not callable in atomic context, or introduce a new operation.
> 
> [1] http://www.spinics.net/lists/dmaengine/msg01548.html

That makes sense. However I am not familiar with DMA core code as much
as I think it would be needed to make such generic changes :). I'll
stick to one driver for now.

Thanks for comments!
Krzysztof



