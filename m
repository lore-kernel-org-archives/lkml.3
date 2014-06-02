Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaFBKHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:07:10 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:54509 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbaFBKHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:07:08 -0400
Date: Mon, 2 Jun 2014 12:03:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140602100332.GH28090@lunn.ch>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140602094715.GG28090@lunn.ch>
 <20140602100048.GA12162@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140602100048.GA12162@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:00:48PM +0200, Antoine Ténart wrote:
> Hi Andrew,
> 
> On Mon, Jun 02, 2014 at 11:47:15AM +0200, Andrew Lunn wrote:
> > On Mon, Jun 02, 2014 at 11:21:02AM +0200, Antoine Ténart wrote:
> > > +
> > > +static inline void berlin_reset_cpu(unsigned int cpu)
> > > +{
> > > +	u32 val;
> > > +
> > > +	val = readl(cpu_ctrl + CPU_RESET);
> > > +	val |= BIT(cpu_logical_map(cpu));
> > > +	writel(val, cpu_ctrl + CPU_RESET);
> > > +}
> > 
> > Is this performing a reset on the CPU, or is it taking it out of reset?
> > 
> > If you are going to implement CPU hotplug at some point, you are going
> > to want to be able to put the CPU into reset, i.e. power it off, and
> > take it out of reset, i.e. power it on and getting it running. So it
> > might help if we get these function names clear now.
> 
> It is performing a reset on the CPU. berlin_perform_reset_cpu() then?

Yes, that would be better.

What happens if the CPU is powered off? Will a reset power it on?  Or
are you assuming the boot loader has powered it on?

    Andrew
