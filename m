Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3LPDgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 22:36:00 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:30903 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab3LPDf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 22:35:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Mon, 16 Dec 2013 11:06:51 +0800
From: Huang Shijie <b32955@freescale.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
CC: Huang Shijie <shijie8@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Quyaxin <quyaxin@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: increase max page/OOB size to support 16K
 pagesize NAND
Message-ID: <20131216030649.GA27109@shlinux2.ap.freescale.net>
References: <C3050A4DBA34F345975765E43127F10F25E47455@SZXEMA512-MBX.china.huawei.com>
 <20131213080118.GC24650@norris-Latitude-E6410>
 <C3050A4DBA34F345975765E43127F10F25E47537@SZXEMA512-MBX.china.huawei.com>
 <20131213151138.GA1316@gmail.com>
 <C3050A4DBA34F345975765E43127F10F25E47627@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E47627@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 02:03:54AM +0000, Caizhiyong wrote:
> > >
> > > There are a lot of 16K page size NAND, they are used in android system.
> > >
> > > Many NAND need read retry and data randomization, kernel does not support this
> > feature.
> > Brian is adding the read-retry feature.
> > 
> > I think the data randomization should be done by the hardware.
> > If we do it by software, it costs lot of the cpu cycles.
> >
> > 
> > > Kernel also does not support synchronous NAND.
> > 
> > The synchronous NAND should be supported by the nand controller driver,
> > not the kernel.
> 
> Yes. Those feature should be support by NAND controller hardware and driver.
> But the driver does not know what NAND should use those feature.
> Perhaps, the NAND id table, should add something.
We can get the synchronous info from the ONFI nand.

In actually, if you do not add this patch, i will change it too.
I have several 16K nand chips on my hands now. :)

thanks
Huang Shijie


