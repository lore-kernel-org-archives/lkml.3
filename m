Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbbANEIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 23:08:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3184 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbbANEIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 23:08:47 -0500
Date: Wed, 14 Jan 2015 12:05:09 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: designware: use {readl|writel}_relaxed instead of
 readl/writel
Message-ID: <20150114120509.0ba8267e@xhacker>
In-Reply-To: <20150113143654.GG7660@katana>
References: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
	<20150113143654.GG7660@katana>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_02:2015-01-13,2015-01-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501140042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wolfram,

On Tue, 13 Jan 2015 06:36:54 -0800
Wolfram Sang <wsa@the-dreams.de> wrote:

> 
> On Thu, Dec 11, 2014 at 02:26:41PM +0800, Jisheng Zhang wrote:
> > readl/writel is too expensive especially on Cortex A9 w/ outer L2 cache.
> > This introduces i2c read/write errors on Marvell BG2/BG2Q SoCs when there
> > are heavy L2 cache maintenance operations at the same time.
> 
> Reading this again, I got a question:
> 
> Really read/write errors? I would think that there is a performance
> penalty because of the memory barriers. But errors?

I dunno whether I can call the issue as error. The situation is one i2c client
has a bit strict timing requirement. Without the patch, if there are heavy L2 cache
maintenance operations at the same time, there may be long delay between each
DW_IC_DATA_CMD write opeartions in i2c_dw_xfer_msg() in the DW_IC_INTR_TX_EMPTY isr.

Thus about 1/300 i2c transactions may be ignored by the i2c client per my test.

> 
> > The driver does not perform DMA, so it's safe to use the relaxed version.
> > From another side, the relaxed io accessor macros are available on all
> > architectures now, so we can use the relaxed versions instead.
> 
> Can the designware core make use of DMA in theory?
> 

the IP can do DMA in theory. But currently, there's no DMA support in the driver.

Thanks for your review,
Jisheng
