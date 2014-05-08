Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaEHQPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:15:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:57581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbaEHQPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="508475952"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: "Duyck, Alexander H" <alexander.h.duyck@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "Lin, Wei W" <wei.w.lin@intel.com>, "Chen, Jet" <jet.chen@intel.com>
Subject: Re: [PATCH] DCA: fix over-warning in ioat3_dca_init
Thread-Topic: [PATCH] DCA: fix over-warning in ioat3_dca_init
Thread-Index: AQHPaqHh2Vem8b+Bs0SNE9U8Bi8ebZs3PasAgAAGxICAAAgagIAABJEA
Date: Thu, 8 May 2014 16:13:57 +0000
Message-ID: <1399565636.122877.3.camel@djiang5-desk1.amr.corp.intel.com>
References: <1399542166-42985-1-git-send-email-jet.chen@intel.com>
	 <536B9CF6.9000907@intel.com> <536BA2A3.50506@intel.com>
	 <536BA96F.1030203@intel.com>
In-Reply-To: <536BA96F.1030203@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.127]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D092133DA5DEF04BA29773BFBB5D9DE1@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s48GFRiR028809

On Thu, 2014-05-08 at 08:57 -0700, Alexander Duyck wrote:
> On 05/08/2014 08:28 AM, Jet Chen wrote:
> > I agree with your option that it is a real BIOS bug and it puts pressure on the BIOS guys to get this fixed. However, this warning message interferes with our kernel booting tests and kernel performance tests. We have to disable CONFIG_INTEL_IOATDMA in kconfig until this issue gets fixed. Before that, code of CONFIG_INTEL_IOATDMA will not be validated in our testing system :(.
> > Hope this issue could get fixed soon.
> > 
> > Thanks,
> > Jet
> > 
> 
> First I would recommend updating your BIOS.  If the updated BIOS also
> has the issue I would recommend taking this feedback to whoever provided
> the BIOS for your platform so that they can implement the fix.
> 
> If I am not mistaken some BIOSes have the option to disable DCA and/or
> IOATDMA.  You might want to check yours to see if you can just disable
> DCA on your platform until the issue can be resolved.

Disabling DCA is the preferred option. IOATDMA is functional without
DCA.

Jet,
What exactly are you attempting to test with IOATDMA? The only two
consumers of this DMA driver I know of are MDRAID and NTB. But support
for XOR/PQ ops on Xeon platforms have been removed due to various
reasons recently so it really is just NTB at the moment in the latest
kernels. 

> Thanks,
> 
> Alex
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
