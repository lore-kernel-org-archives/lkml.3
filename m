Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab3JOGbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:31:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:54890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3JOGbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:31:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,497,1378882800"; 
   d="scan'208";a="411046668"
Date: Tue, 15 Oct 2013 14:31:42 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Youquan Song <youquan.song@intel.com>, dan.j.williams@intel.com,
        andriy.shevchenko@intel.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Message-ID: <20131015183142.GA12494@linux-youquan.bj.intel.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com> <1381527738-9339-2-git-send-email-youquan.song@intel.com> <20131011133343.GB32689@kroah.com> <20131013152633.GM2954@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013152633.GM2954@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 08:56:33PM +0530, Vinod Koul wrote:
> On Fri, Oct 11, 2013 at 06:33:43AM -0700, Greg KH wrote:
> > On Fri, Oct 11, 2013 at 05:42:17PM -0400, Youquan Song wrote:
> > > Currently, the DMA channel calculates its data transferred only at network
> > > device driver. When other devices like UART or SPI etc, transfers data by DMA 
> > > mode, but it always shows 0 at /sys/class/dma/dma0chan*/bytes_transferred.
> > 
> > Is that really a problem?  I have never heard anyone complaining about
> > it.  Where are the reports of this?
> Right, am not still getting the point on what is the problem that this series is
> trying to fix..

The issue is that when I using UART to transfer data between to COMs
which using Designware DMA controller channel. But I check the specific
DMA channel by "cat /sys/class/dma/dma0chan3/bytes_transferred", but it
should all "0". I have transferred data by UART port, why its DMA
channel report "0" bytes transferred?  So I guess that it is possible
the DMA device driver issue or the data does not use the Designware DMA channel
fro transferred.  After check the code, I notice only when the DMA
channel used by network device driver and it will record how much data has been
 tranferred, why other device driver will not calculate it. Since DMA
channel is used by other device driver, why only network is specific?  since it is
common interface, the current /sys/class/dma/dma0chan*/bytes_transferred has
much possibility to mislead the user.


Thanks
-Youquan
 
