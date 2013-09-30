Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3I3JwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:52:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44871 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840Ab3I3JwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:52:05 -0400
Date: Mon, 30 Sep 2013 10:52:02 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Get pdata from arizona structure not
	device
Message-ID: <20130930095202.GY3635@opensource.wolfsonmicro.com>
References: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5248B9BA.9020003@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5248B9BA.9020003@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:37:30AM +0900, Chanwoo Choi wrote:
> No, extcon-arizona driver don't currently support DT to get platform data.
> I cannot find some dt function to parse data from dts file.
> You have to implement extcon-arizona driver by using DT binding style
> to get platform data. I think this patch is not necessary.

Currently the Arizona MFD driver reads the device tree
information and populates the pdata structure, this happens in
drivers/mfd/arizona-core.c. Then the various drivers just use the
pdata as normal.

Admittedly, at the moment we don't parse any data for the extcon
driver but without this patch we will attempt to use a NULL
pointer on device tree systems.

I would also be happy to implement this as a NULL check on the
pdata when we use it if that is preferable? But since we have the
cached pdata seems we might as well use it.

Thanks,
Charles
