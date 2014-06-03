Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaFCHVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:21:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39509 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbaFCHVy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:21:54 -0400
Date: Tue, 3 Jun 2014 15:18:26 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140603151826.100a7fd5@xhacker>
In-Reply-To: <20140603071017.GA15966@kwain>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
	<1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
	<20140603143113.0b2aeb74@xhacker>
	<20140603071017.GA15966@kwain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_02:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406030093
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 3 Jun 2014 00:10:17 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Hi Jisheng,
> 
> On Tue, Jun 03, 2014 at 02:31:13PM +0800, Jisheng Zhang wrote:
> > On Mon, 2 Jun 2014 02:21:02 -0700
> > Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> > > +
> > > +extern void berlin_secondary_startup(void);
> > > +extern u32 boot_inst;
> > > +
> > > +static void __iomem *cpu_ctrl;
> > > +
> > > +static inline void berlin_reset_cpu(unsigned int cpu)
> > > +{
> > > +	u32 val;
> > > +
> > > +	val = readl(cpu_ctrl + CPU_RESET);
> > > +	val |= BIT(cpu_logical_map(cpu));
> > > +	writel(val, cpu_ctrl + CPU_RESET);
> > 
> > "writel(BIT(cpu_logical_map(cpu)), cpu_ctrl + CPU_RESET)" is enough.
> > we don't need to read and modify, because we writing 0 has no any effect.
> 
> The reset bit is automatically cleared but I dumped the register value
> and it wasn't 0x0, that's why I preferred to read first and only set the
> reset bit.
> 
> > > +
> > > +	/*
> > > +	 * Write the first instruction the CPU will execute after being
> > > reseted
> > > +	 * in the reset exception register.
> > > +	 */
> > > +	writel(boot_inst, vectors_base + RESET_VECT);
> > 
> > Is it better to let bootloader/firmware handle this writing. Then, we can
> > also remove the tricky boot_inst in headsmp.S.
> 
> We thought about it, and since it can be difficult to update the
> bootloader for some boards, like BG2 based ones, we preferred to include
> this here.
> 
> Thanks!
> 
> Antoine
> 


Got your points. Thanks very much
