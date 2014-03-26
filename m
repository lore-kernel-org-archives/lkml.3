Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaCZM7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:59:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52905 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752018AbaCZM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:59:51 -0400
Date: Wed, 26 Mar 2014 13:59:48 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] ARM: mvebu: Extend the pmsu registers
Message-ID: <20140326135948.3f2669fc@skate>
In-Reply-To: <5332C267.3080908@gmail.com>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
	<1395787705-31061-8-git-send-email-gregory.clement@free-electrons.com>
	<5332C267.3080908@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Wed, 26 Mar 2014 13:04:55 +0100, Sebastian Hesselbarth wrote:
> On 03/25/2014 11:48 PM, Gregory CLEMENT wrote:
> > The initial binding for PMSU were wrong. It didn't take into account
> > all the registers from the PMSU and moreover it referred to registers
> > which are not part of PMSU.
> >
> > The Power Management Unit Service block also controls the Coherency
> > Fabric subsystem. These registers are needed for the CPU idle
> > implementation for the Armada 370/XP, it allows to enter a deep CPU
> > idle state where the Coherency Fabric and the L2 cache are powered
> > down.
> >
> > This commit add support for a new compatible for the PMSU node
> > including the block related to the coherency fabric. It also keeps
> > compatibility with the old binding
> >
> > This patch also adds warnings if one of the base registers set can't
> > be ioremapped.
> >
> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > ---
> >   arch/arm/mach-mvebu/pmsu.c | 47 +++++++++++++++++++++++++++++++++++++++++-----
> >   1 file changed, 42 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
> > index d71ef53107c4..865bcb651e01 100644
> > --- a/arch/arm/mach-mvebu/pmsu.c
> > +++ b/arch/arm/mach-mvebu/pmsu.c
> [...]
> > +static void __init armada_370_xp_pmsu_legacy_init(struct device_node *np)
> > +{
> > +	u32 addr;
> > +	pr_warn("*** Warning ***  Using an old binding which will be deprecated\n");
> > +	/* We just need the adress, we already know the size */
> > +	addr = be32_to_cpu(*of_get_address(np, 0, NULL, NULL));
> > +	addr -= PMSU_BASE_OFFSET;
> > +	pmsu_mp_base = ioremap(addr, PMSU_REG_SIZE);
> > +	of_node_put(np);
> 
> When messing with OF passed resources, I suggest to use
> of_address_to_resource() and work on the struct resource
> instead. The be32_to_cpu pointing to an immediate just looks
> strange.

I'm working on a revised patch set for these PMSU changes, as I also
need them as a preparation for the SMP support on Armada 375/38x. And
my revised patch set makes the manipulations on the 'struct resource',
as you suggest.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
