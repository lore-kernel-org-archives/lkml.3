Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaDWIYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:24:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55135 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203AbaDWIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:24:12 -0400
Date: Wed, 23 Apr 2014 10:24:09 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tejun Heo <tj@kernel.org>, zmxu@marvell.com,
        Jisheng Zhang <jszhang@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] ata: ahci: add AHCI support for Berlin SoCs
Message-ID: <20140423082409.GC24355@kwain>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
 <1398181105-19714-2-git-send-email-antoine.tenart@free-electrons.com>
 <CAL_JsqKE_Z3kBhS1VaQADV5ob8x6AKHhbHaQEGoVSwkwdd50zA@mail.gmail.com>
 <CAL_JsqJwC2xcZakXiJXJscK7tN7xt2OotBKyr9u+aK3bOP+7GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJwC2xcZakXiJXJscK7tN7xt2OotBKyr9u+aK3bOP+7GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

On Tue, Apr 22, 2014 at 01:54:33PM -0500, Rob Herring wrote:
> On Tue, Apr 22, 2014 at 1:47 PM, Rob Herring <robherring2@gmail.com> wrote:
> > On Tue, Apr 22, 2014 at 10:38 AM, Antoine Ténart
> > <antoine.tenart@free-electrons.com> wrote:
> >> Add support for the Berlin SoCs AHCI SATA controller allowing to
> >> interface with devices like external hard drives.
> 
> One more thing.
> 
> >> +       nports = readl(hpriv->mmio + HOST_PORTS_IMPL);
> >> +
> >> +       /* force_map is modified only if the property is found */
> >> +       of_property_read_u32(np, "marvell,force-port-map", &force_map);
> 
> This property does not appear to be documented.

I'll update it regarding Sebastian comments, or maybe drop it if it is
possible to enable each port individually.

> 
> >> +       if (force_map)
> >> +               nports = force_map;
> 
> You don't need this as your comment says, you can just do:
> 
> of_property_read_u32(np, "marvell,force-port-map", &nports);
> 
> nports will only be changed if property is present.

Sure.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
