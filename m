Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaKDH7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:59:37 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49106 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaKDH7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:59:34 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-02-545887631ee2
Message-id: <1415087969.2389.10.camel@AMDC1943>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 04 Nov 2014 08:59:29 +0100
In-reply-to: <20141103154433.GC4042@n2100.arm.linux.org.uk>
References: <20141103100442.GB4042@n2100.arm.linux.org.uk>
 <Pine.LNX.4.44L0.1411031036350.1316-100000@iolanthe.rowland.org>
 <20141103154433.GC4042@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xq7rJ7REhBsvmq1hsnLGe1eLJgXZG
	i+lTLzBarJ76l9XibNMbdoslk+ezWsyaspfJYmHbEhaLy7vmsFl87j3CaHH7Mq/F2iN32S3e
	vYywuHvqKJvFmdOXWC0m/L7AZnF8bbjFy779LA5CHi3NPWwei/e8ZPK4c20PkNU3mdVjyZtD
	rB5brrazeMy++4PRo2/LKkaPFau/s3t83iTnsffzb5YA7igum5TUnMyy1CJ9uwSujJvfpzAW
	/GCtuLKjm7WB8QJLFyMnh4SAiURz6002CFtM4sK99UA2F4eQwFJGia6mN1DOZ0aJawfPAzkc
	HLwC+hKfJmeANAgLZEp0/vnJCmKzCRhLbF6+BGyQiICpxLVHz5hBepkFmlklJv+4zQSSYBFQ
	lTj59j7YZk4Ba4l90/+yQixYxyhxcuFTZpAEs4C6xKR5i5hBlkkIKEs09ruBhHkFBCV+TL7H
	AlEiL7F5zVvmCYwCs5B0zEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIbH4
	dQfj0mNWhxgFOBiVeHhXxEeECLEmlhVX5h5ilOBgVhLhXV0FFOJNSaysSi3Kjy8qzUktPsTI
	xMEp1cB4Ji4uKdHB7WSwsvg/7vQd7Y1PJj8oaFLSuCgfvORTwHfZwE9tz9tnMoYnsSuxMy59
	/+PeLv+lIYKvv/Zkv1l25yKPtNDPee9kzL+IKeQkS3+b/axSoPS8oM3pMga1IAPRJfN2VnFI
	skd+3am8SCFsr4DBvmrdooA1jcF3D33l/bHLZF1GqLYSS3FGoqEWc1FxIgBqbHOQowIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-11-03 at 15:44 +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 03, 2014 at 10:41:02AM -0500, Alan Stern wrote:
> > Bear in mind, however, that once the irq_safe flag has been set, the 
> > runtime PM core offers no way to turn it off again.
> 
> Ah, I thought it did permit it to change both ways.  In that case, we
> don't need to validate that it doesn't change state on each call, and
> we can just get away with checking its value.

It cannot be unset but still it could be *set* during runtime (not only
in probe). However that shouldn't happen between suspend-resume calls,
so the solution of undoing suspend's work seems fine.

I'll send a new patch doing this way. Without the wrapper.

Best regards,
Krzysztof



