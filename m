Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3FULOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:14:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35878 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FULOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 07:14:45 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-67-51c435a3d492
From: Tomasz Figa <t.figa@samsung.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v6 4/8] ARM: Add .init_platform() callback to machine
 descriptor
Date: Fri, 21 Jun 2013 13:14:34 +0200
Message-id: <72209947.cQvP4jsDBz@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <51C429F4.60709@arm.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
 <1371774924-9224-5-git-send-email-tomasz.figa@gmail.com>
 <51C429F4.60709@arm.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t/xq7qLTY8EGtz5zGrxd9IxdouZn26y
	WUx9+ITN4sDsh6wWB/7sYLRoXHKZxaJ3wVU2i02Pr7FaXN41h81ixvl9TBa3L/Na/L3zj81i
	3osXbBanrn9mszi84gCTxauDbSwWmzdNZbZYtesPo8XLjydYHIQ91sxbw+jR0tzD5vH71yRG
	jwWfr7B7PDvRzuaxc9Zddo9NqzrZPBoOnGfxuHNtD5vHu3Pn2D02L6n3OD9jIaPHlRNNrB59
	W1YxenzeJOexcW5ogEAUl01Kak5mWWqRvl0CV8abz4dZC6ZJVcz8+pC9gfGoSBcjJ4eEgInE
	kaMHWCFsMYkL99azdTFycQgJLGWU+P5yKTuE08UksXbZZ2aQKjYBNYnPDY/YQGwRAXWJp/3P
	wIqYBe6zSax4PJ0JJCEsECZx8MQXsLEsAqoS7w4sYAGxeQW0JJY+ugg2iB+o+d22p2D1ogKu
	Eu9XHwaq4eDgBKqf+N0KYvEsRomj2++wQ/QKSvyYfA9sDrOAvMS+/VNZIWwtifU7jzNNYBSc
	haRsFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIifCvOxiXHrM6xCjAwajE
	wxuodDhQiDWxrLgy9xCjBAezkghv8B2gEG9KYmVValF+fFFpTmrxIUYmDk6pBsbbs/MUC9ln
	7Egty9VkNZh76/GKFXtTOQ5aBZ5+wsU0tzpyQu8BnwsCBzl3eu2xtHgnOHmR3CydntVBUR7B
	E+ZP+GsxbV5yc3rzz/XT51zPMvp79r5M1sW6uNdHl13Qnr0/8ofGMh/B9HgdtY02GwOFHD8x
	RJx9pX/yuz178wenh9sevMlsMeFXYinOSDTUYi4qTgQA4mbyL84CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Friday 21 of June 2013 11:24:52 Marc Zyngier wrote:
> On 21/06/13 01:35, Tomasz Figa wrote:
> 
> Hi Tomasz,
> 
> > Most ARM platforms have parts that should be initialized as early as
> > possible, which usually means as soon as memory management (kmalloc,
> > ioremap) starts to work,
> > 
> > However, currently there is no appropriate callback in machine_desc
> > struct to use for such initialization and platforms tend to stuff
> > things
> > up .init_irq() and .init_time() callbacks.
> > 
> > Since all the DT-based platforms are going towards generic IRQ and time
> > initialization (using irqchip_init and clocksource_of_init) and current
> > code assumes that if custom callbacks are not provided in machine_desc
> > then generic ones should be used, this problem has become a bit more
> > inconvenient.
> > 
> > This patch tries to solve this issue by introducing new callback called
> > .init_platform(), where any custom low level initialization of platform
> > can be done safely.
> > 
> > Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> > ---
> > 
> >  arch/arm/include/asm/mach/arch.h | 1 +
> >  arch/arm/kernel/irq.c            | 3 +++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm/include/asm/mach/arch.h
> > b/arch/arm/include/asm/mach/arch.h index 308ad7d..b2f4d11 100644
> > --- a/arch/arm/include/asm/mach/arch.h
> > +++ b/arch/arm/include/asm/mach/arch.h
> > @@ -46,6 +46,7 @@ struct machine_desc {
> > 
> >  	void			(*reserve)(void);/* reserve mem blocks	*/
> >  	void			(*map_io)(void);/* IO mapping function	*/
> >  	void			(*init_early)(void);
> > 
> > +	void			(*init_platform)(void);
> > 
> >  	void			(*init_irq)(void);
> >  	void			(*init_time)(void);
> >  	void			(*init_machine)(void);
> > 
> > diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> > index 9723d17..61e2000 100644
> > --- a/arch/arm/kernel/irq.c
> > +++ b/arch/arm/kernel/irq.c
> > @@ -115,6 +115,9 @@ EXPORT_SYMBOL_GPL(set_irq_flags);
> > 
> >  void __init init_IRQ(void)
> >  {
> > 
> > +	if (machine_desc->init_platform)
> > +		machine_desc->init_platform();
> > +
> > 
> >  	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
> >  	
> >  		irqchip_init();
> >  	
> >  	else
> 
> To me, this new hook is strictly equivalent to init_irq. What do we gain
> exactly? I didn't think init_irq was going away...
> 
> I know init_irq is not pretty, and we tend to overload it with other
> stuff, but I don't really see the point of adding a new callback that
> has the exact same properties.

Well, it doesn't really give us any functional benefits.

However in my opinion it looks much saner in case of DT-only platforms that 
don't need any specific IRQ initialization, but need to call some platform 
specific initialization routines, after memory management, but before 
anything else is initialized.

This way irqchip_init() doesn't have to be explicitly called in platform 
code.

Anyway, I don't have any strong opinion on this. If it is perfectly fine to 
abuse irqchip_init() for anything that must be done at this stage of boot, 
then I'm fine with this either and will modify the board file from further 
patch from this series to not rely on this change any more.

Best regards,
Tomasz

> 
> 	M.
