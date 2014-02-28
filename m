Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaB1LFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:05:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15801 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaB1LFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:05:37 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-bd-53106d7f2e22
Message-id: <1393585526.31997.1.camel@AMDC1943>
Subject: Re: [PATCH 0/4] mfd: sec: Add support for S2MPS14
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Fri, 28 Feb 2014 12:05:26 +0100
In-reply-to: <20140228104927.GB31720@lee--X1>
References: <1393584104-18912-1-git-send-email-k.kozlowski@samsung.com>
 <20140228104927.GB31720@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xK7r1uQLBBv1T+Sw2zljPanG26Q27
	xf2vRxktLu+aw2Yx4/w+Jou1R+6yW5zuZrW4uOILk8X6Ga9ZHDg97lzbw+Yx72SgR9+WVYwe
	nzfJBbBEcdmkpOZklqUW6dslcGVsf3qLqWABf8WN968YGxi/cHcxcnJICJhIXFz0kRXCFpO4
	cG89WxcjF4eQwFJGifaOc6wQzmdGiQ0zb7F0MXJw8AroSyzbaQfSICxgJXFq2iYmEJtNwFhi
	8/IlbCAlIgIqEufemIO0MgscZ5KYfugwI0gNi4CqxN3Jm8FsTgFdiduzljKD2EICWRIXJvwB
	O4JZQF1i0rxFzBAHKUnsbu9kh4jLS2xe8xYszisgKPFj8j2WCYwCs5C0zEJSNgtJ2QJG5lWM
	oqmlyQXFSem5hnrFibnFpXnpesn5uZsYIaH+ZQfj4mNWhxgFOBiVeHgnePIHC7EmlhVX5h5i
	lOBgVhLhzXMXCBbiTUmsrEotyo8vKs1JLT7EyMTBKdXAmJM1s3D1oWgvhgMi+x6YvLOfab1j
	UsCnlxMn3Qmfuvd3cvqKFs4iF+2r6od/19xOeWe6+JZWLsfLhSwrlD6J2Gy0fWEttnSp4Som
	Y+ajW3dWPz759Z/32VyhXyoZp++ZdOhv7a4uqXkX9nDD/IcvV/0Wn7/lgEL/lrPrf13NreKd
	79cyr6A5rU6JpTgj0VCLuag4EQB9MrVqUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 10:49 +0000, Lee Jones wrote:
> > Few days ago I sent patches adding support for S2MPS14 device to the
> > sec-core/s2mps11 drivers. These patches were rather large as they covered
> > multiple subsystems so I decided to split everything into smaller, separate
> > patches.
> > 
> > The original patchset (version 3) can be found here:
> > http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=1649217
> > 
> > This patchset is a small subset of the patchset related to the MFD core
> > driver. It adds support for the S2MPS14 device only to the MFD core driver.
> > I already obtained acks from Lee Jones during previous reviews.
> > 
> > The patchset is based on current Linus' tree *with* patch:
> > mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
> > (which is already in Lee Jones' MFD tree)
> 
> Can all of these patches be applied as they are?
> 
> Is anything going to break as a result?

Yes, they can be applied as they are. That was the reason behind
splitting everything. Nothing should break, as far as I reviewed this
and tested.

Best regards,
Krzysztof

> 
> > Krzysztof Kozlowski (4):
> >   mfd: sec: Add maximum RTC register for regmap config
> >   mfd: sec: Select different RTC regmaps for devices
> >   mfd: sec: Use consistent S2MPS11 RTC alarm interrupt indexes
> >   mfd: sec: Add support for S2MPS14
> > 
> >  drivers/mfd/sec-core.c              |   57 ++++++++++++-
> >  drivers/mfd/sec-irq.c               |   97 ++++++++++++++++++++--
> >  include/linux/mfd/samsung/core.h    |    1 +
> >  include/linux/mfd/samsung/irq.h     |   31 ++++++-
> >  include/linux/mfd/samsung/rtc.h     |   57 +++++++++++--
> >  include/linux/mfd/samsung/s2mps14.h |  152 +++++++++++++++++++++++++++++++++++
> >  6 files changed, 378 insertions(+), 17 deletions(-)
> >  create mode 100644 include/linux/mfd/samsung/s2mps14.h
> > 
> 

