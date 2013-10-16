Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3JPGb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:31:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:41258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3JPGb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,505,1378882800"; 
   d="scan'208";a="393612595"
Date: Wed, 16 Oct 2013 11:08:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Youquan Song <youquan.song@linux.jf.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Youquan Song <youquan.song@intel.com>, andriy.shevchenko@intel.com,
        mika.westerberg@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Message-ID: <20131016053857.GV2954@intel.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
 <20131011133343.GB32689@kroah.com>
 <20131013152633.GM2954@intel.com>
 <20131015183142.GA12494@linux-youquan.bj.intel.com>
 <CAPcyv4jJSgM7EmDMW-rcjVCnC6-95+qeU9yf+yxD-wMCcQ8amg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jJSgM7EmDMW-rcjVCnC6-95+qeU9yf+yxD-wMCcQ8amg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 08:55:20AM -0700, Dan Williams wrote:
> On Tue, Oct 15, 2013 at 11:31 AM, Youquan Song
> <youquan.song@linux.intel.com> wrote:
> > On Sun, Oct 13, 2013 at 08:56:33PM +0530, Vinod Koul wrote:
> >> On Fri, Oct 11, 2013 at 06:33:43AM -0700, Greg KH wrote:
> >> > On Fri, Oct 11, 2013 at 05:42:17PM -0400, Youquan Song wrote:
> > The issue is that when I using UART to transfer data between to COMs
> > which using Designware DMA controller channel. But I check the specific
> > DMA channel by "cat /sys/class/dma/dma0chan3/bytes_transferred", but it
> > should all "0". I have transferred data by UART port, why its DMA
> > channel report "0" bytes transferred?  So I guess that it is possible
> > the DMA device driver issue or the data does not use the Designware DMA channel
> > fro transferred.  After check the code, I notice only when the DMA
> > channel used by network device driver and it will record how much data has been
> >  tranferred, why other device driver will not calculate it. Since DMA
> > channel is used by other device driver, why only network is specific?  since it is
> > common interface, the current /sys/class/dma/dma0chan*/bytes_transferred has
> > much possibility to mislead the user.
> 
> Yes, and for that reason I think we should delete "
> /sys/class/dma/dma0chan*/bytes_transferred" it really serves no useful
> purpose besides "is my dma channel working" which can be determined by
> other means.
Well am going to take it a bit further and ask you why do we need the
/sys/class/dma? I have never used it for slave work.

Does it get used anywhere in async_tx?

--
~Vinod
