Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaFCGWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:22:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46513 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbaFCGWg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:22:36 -0400
Date: Tue, 3 Jun 2014 14:19:13 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140603141913.710a1f7e@xhacker>
In-Reply-To: <20140602102750.GB13681@kwain>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
	<1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
	<20140602094715.GG28090@lunn.ch>
	<20140602100048.GA12162@kwain>
	<20140602100332.GH28090@lunn.ch>
	<20140602102750.GB13681@kwain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_02:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406030087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Antoine, 

On Mon, 2 Jun 2014 03:27:50 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> On Mon, Jun 02, 2014 at 12:03:32PM +0200, Andrew Lunn wrote:
> > On Mon, Jun 02, 2014 at 12:00:48PM +0200, Antoine Ténart wrote:
> > > Hi Andrew,
> > > 
> > > On Mon, Jun 02, 2014 at 11:47:15AM +0200, Andrew Lunn wrote:
> > > > On Mon, Jun 02, 2014 at 11:21:02AM +0200, Antoine Ténart wrote:
> > > > > +
> > > > > +static inline void berlin_reset_cpu(unsigned int cpu)
> > > > > +{
> > > > > +	u32 val;
> > > > > +
> > > > > +	val = readl(cpu_ctrl + CPU_RESET);
> > > > > +	val |= BIT(cpu_logical_map(cpu));
> > > > > +	writel(val, cpu_ctrl + CPU_RESET);
> > > > > +}
> > > > 
> > > > Is this performing a reset on the CPU, or is it taking it out of
> > > > reset?
> > > > 
> > > > If you are going to implement CPU hotplug at some point, you are going
> > > > to want to be able to put the CPU into reset, i.e. power it off, and
> > > > take it out of reset, i.e. power it on and getting it running. So it
> > > > might help if we get these function names clear now.
> > > 
> > > It is performing a reset on the CPU. berlin_perform_reset_cpu() then?
> > 
> > What happens if the CPU is powered off? Will a reset power it on?  Or
> > are you assuming the boot loader has powered it on?
> 
> I actually don't have information about this. For now let's assume the
> boot loader has powered on the CPUs.
> 

We don't support independently power off cpu on BG2 and BG2Q in linux kernel.
So we can assume that bootloader has powered on the CPUs

