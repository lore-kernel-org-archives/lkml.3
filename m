Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaBNLRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:17:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19507 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbaBNLRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:17:01 -0500
Date: Fri, 14 Feb 2014 19:14:47 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: use {readl|writel}_relaxed instead of readl/writel in
 i2c-designware-core ?
Message-ID: <20140214191447.7b283568@xhacker>
In-Reply-To: <8705989.qzo882Ldx0@wuerfel>
References: <20140214155438.4f749a79@xhacker>
	<8705989.qzo882Ldx0@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-14_03:2014-02-14,2014-02-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402140028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd,

On Fri, 14 Feb 2014 01:09:44 -0800
Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 14 February 2014 15:54:38 Jisheng Zhang wrote:
> > Hi all,
> > 
> > The writel/readl is too expensive especially on Cortex A9 w/ outer L2
> > cache. This introduce i2c read/write error on Marvell Berlin SoCs when
> > there are L2 cache maintenance operations at the same time.
> > 
> > In our internal berlin bsp, we just replaced readl/writel with the relaxed
> > version. But AFAIK, the "relaxed" version doesn't exist on all
> > architectures. How to handle this issue? 
> 
> In case of i2c-designware, this is safe because that driver does not perform
> DMA. In other drivers, you may have to be more careful, to ensure that all
> MMIO is serialized with DMA operations performed by the driver.
> 
> > Any suggestions are appreciated.
> 
> I would definitely welcome a patch that adds a default  _relaxed
> implementation to include/linux/io.h, like this:
> 
> #ifndef readb_relaxed
> #define readb_relaxed(p) readb(p)
> #endif
> 
> and then adds "#define readb_relaxed(p) readb_relaxed(p)" etc. to all
> architectures that have a non-macro definition for readb.

Thanks for the suggestions. I'll try to send out one RFC patch.

Thanks,
Jisheng
