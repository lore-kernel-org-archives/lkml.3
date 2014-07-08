Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaGHUE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:04:56 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:47243 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaGHUEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:04:54 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Dinh Nguyen (dinguyen@altera.com)" <dinguyen@altera.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "Robert Baldyga" <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: dwc2: remove incomplete DMA support from gadget
 code
Thread-Topic: [PATCH] usb: dwc2: remove incomplete DMA support from gadget
 code
Thread-Index: AQHPmrycS0FNgw5mhES6/ILZKpsVs5uWl/pw
Date: Tue, 8 Jul 2014 20:04:47 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844BCBFA@US01WEMBX2.internal.synopsys.com>
References: <2181126.aCTfeXMESu@amdc1032>
In-Reply-To: <2181126.aCTfeXMESu@amdc1032>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Tuesday, July 08, 2014 7:55 AM
> 
> The commit 5b7d70c6dbf2 ("USB: Gadget driver for Samsung HS/OtG
> block") which added this driver also introduced the inactive DMA
> support (due to hardware limitations of DMA buffers alignment).
> It has been a dead code for over 5 years and should be removed.
> 
> We don't keep the unused/untested features in the kernel.  Such
> code has a real maintainance cost (all other changes have to take
> dead code into account), i.e. https://lkml.org/lkml/2014/5/6/461.
> Also all the removed dead code is still accessible in the kernel
> git repository and can be easily brought back if/when needed.
> 
> There should be no functional changes caused by this patch.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Hmm. I'd rather not apply this for the time being. Dinh Nguyen is
working on a patch to combine the two dwc2 drivers into a dual-role
driver. I suspect his platform will be able to use DMA. Also, once that
is done, I plan to enable device-mode support for the Synopsys
development platform, which also supports DMA.

If none of this happens over the next couple of months, we can reconsider
applying this patch. After all, the code has been there for 5 years, a
couple more months won't hurt. Sound OK?

-- 
Paul

