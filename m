Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab3LMLMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:12:02 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:15761 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3LMLMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:12:00 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Quyaxin <quyaxin@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: RE: [PATCH] mtd: increase max page/OOB size to support 16K pagesize
 NAND
Thread-Topic: [PATCH] mtd: increase max page/OOB size to support 16K
 pagesize NAND
Thread-Index: Ac73wLSIfXMFy3+HQFSy5QaQsDobRP//q3wA//9efLA=
Date: Fri, 13 Dec 2013 11:10:10 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E47537@SZXEMA512-MBX.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F25E47455@SZXEMA512-MBX.china.huawei.com>
 <20131213080118.GC24650@norris-Latitude-E6410>
In-Reply-To: <20131213080118.GC24650@norris-Latitude-E6410>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Dec 13, 2013 at 05:03:49AM +0000, Caizhiyong wrote:
> > From: Cai Zhiyong <caizhiyong@huawei.com>
> > Date: Fri, 13 Dec 2013 12:52:46 +0800
> > Subject: [PATCH] mtd: increase max page/OOB size to support 16K pagesize NAND.
> >
> > The Toshiba's TC58TEG5DCJTA pagesize is 16K, oob size is 1280 bytes.
> > So increase the NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE.
> 
> It would help if we had nand_base/nand_ids support for TC58TEG5DCJTA
> before we try to increase NAND_MAX_PAGESIZE and NAND_MAX_OOBSIZE yet
> again. AFAICT, nand_base will not detect new, large Toshiba flash
> properly anyway.

There are a lot of 16K page size NAND, they are used in android system.

Many NAND need read retry and data randomization, kernel does not support this feature.
Kernel also does not support synchronous NAND.
As you know, is someone doing some work to support those feature now?

If Kernel support TC58TEG5DCJTA, the read retry and data randomization also
need be supported, it will be a big project.

> 
> > Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
> > ---
> >  include/linux/mtd/nand.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> > index f3ea8da..2f0a7f2 100644
> > --- a/include/linux/mtd/nand.h
> > +++ b/include/linux/mtd/nand.h
> > @@ -56,8 +56,8 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs,
> uint64_t len);
> >   * is supported now. If you add a chip with bigger oobsize/page
> >   * adjust this accordingly.
> >   */
> > -#define NAND_MAX_OOBSIZE	744
> > -#define NAND_MAX_PAGESIZE	8192
> > +#define NAND_MAX_OOBSIZE	1280
> > +#define NAND_MAX_PAGESIZE	16384
> 
> It might be time to draw a line in the sand: next person who needs to
> increase MAX_{PAGE,OOB}SIZE gets the job of killing the macro? We are
> long overdue for dynamic buffer allocation.
> 
> There are two drivers that use the macros, plus nand_chip.buffers.*. The
> drivers can be weaned off by allocating a small, fixed-size temporary
> buffer for the few tasks that need it. With nand_base.c, I think we can
> get by with waiting to allocate nand_chip.buffers until after we detect
> the writesize/oobsize.
> 
> So Cai, are you up for this?

Ok, I will try update it.

> 
> >
> >  /*
> >   * Constants for hardware specific CLE/ALE/NCE function
> >
> 
> Brian
