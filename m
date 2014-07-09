Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaGIKS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:18:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25371 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaGIKS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:18:56 -0400
X-AuditID: cbfee61a-f79e46d00000134f-03-53bd170e86fa
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "Dinh Nguyen (dinguyen@altera.com)" <dinguyen@altera.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: remove incomplete DMA support from gadget code
Date: Wed, 09 Jul 2014 12:18:43 +0200
Message-id: <1661236.KYerOtcomB@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <A2CA0424C0A6F04399FB9E1CD98E0304844BCBFA@US01WEMBX2.internal.synopsys.com>
References: <2181126.aCTfeXMESu@amdc1032>
 <A2CA0424C0A6F04399FB9E1CD98E0304844BCBFA@US01WEMBX2.internal.synopsys.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jAV0+8b3BBo1/zCwO3q+3eHCrlcni
	+KXFzBbNi9ezWZxtesNucXnXHDaLRctamS0ePdzKavHg8E52B06P1r0T2DyevZzM5LF/7hp2
	j74tqxg9tuz/zOhx/MZ2Jo/Pm+QC2KO4bFJSczLLUov07RK4Mk5ePMJY8ICvYlW3cAPjC+4u
	Rk4OCQETiQVvzrNA2GISF+6tZ+ti5OIQEljEKDHjxV5WCKeFSeL/ieOMIFVsAlYSE9tXgdki
	AgYSG45OYwOxmQXamSVOrASLCwv4SUxq2QIWZxFQlfg6ZyY7iM0roCkxpfkXM4gtKuApsWP7
	SrAaToEoiTt7n4DVCAmUSyzZ2cQGUS8o8WPyPRaI+fIS+/ZPZYWwtSTW7zzONIFRYBaSsllI
	ymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgWnkntYFzZYHGIUYCDUYmHV4Fn
	T7AQa2JZcWXuIUYJDmYlEV5b0b3BQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5ak
	ZqemFqQWwWSZODilGhija3lK+a07DYwlL731EjjAf3LBi0ebyqNCuW7+qRN2XZdxZMIcuX0f
	ArkTnhzhj5N5KV8jdftu96QDVnaNPycePi5ko3xj4/64TtusBUtUDprsjmeMNQ1s2pLjstDq
	i/3eu6p3Y+fP9tvxXWuy2cn/3y8EsKw2MVrjrndAc4LR2mMrM3ruHjilxFKckWioxVxUnAgA
	HCGnBYECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, July 08, 2014 08:04:47 PM Paul Zimmerman wrote:
> > From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> > Sent: Tuesday, July 08, 2014 7:55 AM
> > 
> > The commit 5b7d70c6dbf2 ("USB: Gadget driver for Samsung HS/OtG
> > block") which added this driver also introduced the inactive DMA
> > support (due to hardware limitations of DMA buffers alignment).
> > It has been a dead code for over 5 years and should be removed.
> > 
> > We don't keep the unused/untested features in the kernel.  Such
> > code has a real maintainance cost (all other changes have to take
> > dead code into account), i.e. https://lkml.org/lkml/2014/5/6/461.
> > Also all the removed dead code is still accessible in the kernel
> > git repository and can be easily brought back if/when needed.
> > 
> > There should be no functional changes caused by this patch.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Hmm. I'd rather not apply this for the time being. Dinh Nguyen is
> working on a patch to combine the two dwc2 drivers into a dual-role
> driver. I suspect his platform will be able to use DMA. Also, once that
> is done, I plan to enable device-mode support for the Synopsys
> development platform, which also supports DMA.
> 
> If none of this happens over the next couple of months, we can reconsider
> applying this patch. After all, the code has been there for 5 years, a
> couple more months won't hurt. Sound OK?

Well, I would prefer to have it removed now instead of hoping that some
new platforms will have DMA limitations lifted.  DMA code can be easily
brought back when needed and it needs to be verified on new hardware
anyway..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

