Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab3JPIgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:36:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:48096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760246Ab3JPIgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:36:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,505,1378882800"; 
   d="scan'208";a="417588954"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Youquan Song <youquan.song@linux.jf.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Thread-Topic: [PATCH 1/2] dma: Add interface to calculate data transferred
Thread-Index: AQHOxmj7TKNMun2fTEyCvrAxr1aQIZnvb2yAgANEMICAA1hkAP//1FAAgADmHoCAADGFgA==
Date: Wed, 16 Oct 2013 08:36:30 +0000
Message-ID: <1381912571.29062.135.camel@smile>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
	 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
	 <20131011133343.GB32689@kroah.com> <20131013152633.GM2954@intel.com>
	 <20131015183142.GA12494@linux-youquan.bj.intel.com>
	 <CAPcyv4jJSgM7EmDMW-rcjVCnC6-95+qeU9yf+yxD-wMCcQ8amg@mail.gmail.com>
	 <20131016053857.GV2954@intel.com>
In-Reply-To: <20131016053857.GV2954@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AA89FCA2CF1174B8A58C6F514FAB3C3@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9G8akG4031109

On Wed, 2013-10-16 at 11:08 +0530, Vinod Koul wrote:
> On Tue, Oct 15, 2013 at 08:55:20AM -0700, Dan Williams wrote:
> > On Tue, Oct 15, 2013 at 11:31 AM, Youquan Song
> > <youquan.song@linux.intel.com> wrote:
> > > On Sun, Oct 13, 2013 at 08:56:33PM +0530, Vinod Koul wrote:
> > >> On Fri, Oct 11, 2013 at 06:33:43AM -0700, Greg KH wrote:
> > >> > On Fri, Oct 11, 2013 at 05:42:17PM -0400, Youquan Song wrote:
> > > The issue is that when I using UART to transfer data between to COMs
> > > which using Designware DMA controller channel. But I check the specific
> > > DMA channel by "cat /sys/class/dma/dma0chan3/bytes_transferred", but it
> > > should all "0". I have transferred data by UART port, why its DMA
> > > channel report "0" bytes transferred?  So I guess that it is possible
> > > the DMA device driver issue or the data does not use the Designware DMA channel
> > > fro transferred.  After check the code, I notice only when the DMA
> > > channel used by network device driver and it will record how much data has been
> > >  tranferred, why other device driver will not calculate it. Since DMA
> > > channel is used by other device driver, why only network is specific?  since it is
> > > common interface, the current /sys/class/dma/dma0chan*/bytes_transferred has
> > > much possibility to mislead the user.
> > 
> > Yes, and for that reason I think we should delete "
> > /sys/class/dma/dma0chan*/bytes_transferred" it really serves no useful
> > purpose besides "is my dma channel working" which can be determined by
> > other means.
> Well am going to take it a bit further and ask you why do we need the
> /sys/class/dma? I have never used it for slave work.

How user (who, f.e., would like to run dmatest) will know names of the
channels provided?

How could we see what channels of certain dma controller are requested /
busy from userspace?

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
