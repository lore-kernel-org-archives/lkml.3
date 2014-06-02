Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaFBNkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:40:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24986 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaFBNku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:40:50 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-06-538c7ee08b1a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 7/7] ARM: EXYNOS: cpuidle: add secure firmware support
 to AFTR mode code
Date: Mon, 02 Jun 2014 15:40:21 +0200
Message-id: <2929163.ygQuOcYWlC@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <538C78DB.1060809@gmail.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
 <1401712543-14281-8-git-send-email-b.zolnierkie@samsung.com>
 <538C78DB.1060809@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+xgO6Dup5gg71PxS3mfZa16F1wlc3i
	bNMbdov3h54xW2x6fI3V4vKuOWwWn3uPMFrMOL+PyeLM6UusFif/9DJarJ/xmsVi1a4/jBYb
	v3o48HrsnHWX3ePOtT1sHpuX1Hvc/veY2WPL1XYWj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL
	4Mp4NPkvS8Eh0YqJ35IbGKcIdjFyckgImEhMf7WbBcIWk7hwbz1bFyMXh5DAIkaJQ9eeQjkt
	TBIvjjezg1SxCVhJTGxfxQhiiwioS3yb0s8OUsQscJxZ4nnvQqAODg5hgUSJX3tUQWpYBFQl
	rp9Zzg4S5hXQlJg2lwckLCrgKbFj+0o2EJsTKLzs3i5miF3LGCXa958Fm88rICjxY/I9sOuY
	BeQl9u2fygph60jsb53GNoFRYBaSsllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85
	P3cTIzhenknvYFzVYHGIUYCDUYmH94d6T7AQa2JZcWXuIUYJDmYlEd6lFkAh3pTEyqrUovz4
	otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjPom8nyb84QZ9x7TkshJ6tUw
	lVVSfPBsmen/yWZF3zt5f31frus8NXme8OlM9WPtu2oYK/6zyuuZn+X5bxojsGy/C9/SB9Wn
	PNjeX/r/S/nEEs4He2r0noWvi195MXHjv2+rVhSxtfz6fu/H6bS9urxlrIdt32zfu/flt99J
	zy59DHSY6CfVE6/EUpyRaKjFXFScCAAUpy4BkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 02, 2014 03:15:07 PM Tomasz Figa wrote:
> Hi,
> 
> On 02.06.2014 14:35, Bartlomiej Zolnierkiewicz wrote:
> > * Use do_idle firmware method instead of cpu_do_idle() on boards with
> >   secure firmware enabled.
> > 
> > * Use sysram_ns_base_addr + 0x24 address for exynos_boot_vector_addr()
> >   and sysram_ns_base_addr + 0x20 one for exynos_boot_vector_flag() on
> >   boards with secure firmware enabled.
> > 
> > This patch fixes hang on an attempt to enter AFTR mode for TRATS2
> > board (which uses EXYNOS4412 SoC with secure firmware enabled).
> > 
> > This patch shouldn't cause any functionality changes on boards that
> > don't use secure firmware.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/arm/mach-exynos/pm.c        | 8 ++++++--
> >  drivers/cpuidle/cpuidle-exynos.c | 7 ++++++-
> >  2 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> > index 0fb9a5a..62a0a5e 100644
> > --- a/arch/arm/mach-exynos/pm.c
> > +++ b/arch/arm/mach-exynos/pm.c
> > @@ -169,7 +169,9 @@ int exynos_cluster_power_state(int cluster)
> >  
> >  static inline void __iomem *exynos_boot_vector_addr(void)
> >  {
> > -	if (samsung_rev() == EXYNOS4210_REV_1_1)
> > +	if (firmware_run())
> > +		return sysram_ns_base_addr + 0x24;
> > +	else if (samsung_rev() == EXYNOS4210_REV_1_1)
> 
> Aha, so this is the use case for the function added by patch 1/7.
> 
> Well, I don't see the need to do it this way and complicate the API. As
> I mentioned in my comments to patches 2/7 and 5/7, more general firmware
> operations should be taking care of setting those registers to
> appropriate values and so there shouldn't be any need to use them
> directly outside the implementation of firmware ops.

More general firmware operations would handle the secure firmware case
fine but how would you like to handle a fallback case given that you
cannot use samsung_rev() etc. in drivers/cpuidle/cpuidle-exynos.c?

> [snip]
> 
> >  static int idle_finisher(unsigned long flags)
> >  {
> >  	exynos_enter_aftr();
> > -	cpu_do_idle();
> > +	if (firmware_run())
> > +		/* no need to check the return value on EXYNOS SoCs */
> > +		call_firmware_op(do_idle, FW_DO_IDLE_AFTR);
> > +	else
> > +		cpu_do_idle();
> 
> This could be done just by
> 
> 	if (call_firmware_op(do_idle, FW_DO_IDLE_AFTR) == -ENOSYS)
> 		cpu_do_idle();
> 
> which is 3 lines less than with a function that is suppose to simplify
> the code.

OK.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

