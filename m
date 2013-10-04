Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3JDJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:56:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59697 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3JDJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:56:21 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-7d-524e90c35324
Date: Fri, 04 Oct 2013 11:56:12 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] thermal: exynos: fix: Return from
 exynos_report_trigger() when therm_dev is NULL
Message-id: <20131004115612.1017e0f7@amdc308.digital.local>
In-reply-to: <524DE45E.1060606@ti.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1380010102-25817-2-git-send-email-l.majewski@samsung.com>
 <524DE45E.1060606@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoO7hCX5BBlcfG1g0XA2x2DhjPavF
	/CPnWC3W7P/JZNF59gmzxZtH3BaXd81hs/jce4TRYsb5fUwWtxtXsFn0L+xlsnjysI/NYv2M
	1ywOvB6L97xk8lg37S2zR9+WVYwejxa3MHocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujLOt
	q5kL1olVHO99wdbA+EOwi5GTQ0LARGLD4muMELaYxIV769lAbCGB6YwSB+eodDFyAdntTBIX
	L3xgBkmwCKhKbPrxEMxmE9CT+Hz3KROILQJk33jxBMxmFnjDLLF6hReILSyQLXH82T2wel4B
	a4k7M9eygticAmoS568uZ4NYMJ9R4uG6NrAifgFJifZ/P5ghLrKTOPdpAztEs6DEj8n3WCAW
	aEls3tbECmHLS2xe85Z5AqPgLCRls5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcAQ9k9rBuLLB4hCjAAejEg+vQK1vkBBrYllxZe4hRgkOZiUR3j3dfkFCvCmJlVWpRfnx
	RaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGDeqqK3dc9lWhGsvC8OT2V2R
	9zgXL4veNY9b4eOurap8b8tOmohKsJ+axOF6iiHzbZil4eVE/e0a82MEpx4IVTx3afX/dYnS
	si1igYIqoiYZH/6qTQleYFzqph30asF3by8RzUjNQr7Qq8dLb343PbNml/vBP3kXWJfIc6yb
	kC7YGfepNvfPWSWW4oxEQy3mouJEAHtZfPGcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

Thanks for reply.

> On 24-09-2013 04:08, Lukasz Majewski wrote:
> > The commit 4de0bdaa9677d11406c9becb70c60887c957e1f0
> > ("thermal: exynos: Add support for instance based
> > register/unregister") broke check for presence of therm_dev at
> > global thermal zone in exynos_report_trigger().
> > 
> > The resulting wrong test prevents thermal_zone_device_update()
> > call, which calls handlers for situation when trip points are
> > passed. Such behavior prevents thermal driver from proper reaction
> > (when TMU interrupt is raised) in a situation when overheating is
> > detected at TMU hardware. This patch fixes it.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_thermal_common.c
> > b/drivers/thermal/samsung/exynos_thermal_common.c index
> > f10a6ad..55a912a 100644 ---
> > a/drivers/thermal/samsung/exynos_thermal_common.c +++
> > b/drivers/thermal/samsung/exynos_thermal_common.c @@ -310,7 +310,7
> > @@ void exynos_report_trigger(struct thermal_sensor_conf *conf) }
> >  
> >  	th_zone = conf->pzone_data;
> > -	if (th_zone->therm_dev)
> > +	if (!th_zone->therm_dev)
> 
> Fine with this fix, as it really looks obvious. But after reading the
> code a bit, I am considering if we can remove the above check at all.

I have just preserved the old behaviour for -rcX fix.

> 
> Reading the driver code piece at drivers/thermal/samsung/exynos_tmu.c,
> by checking how exynos_register_thermal gets called, and how error is
> handled, I assume we do not need to check for th_zone->therm_dev.

It looks like we don't need this check (we will not register the
thermal zone if therm dev is not correct).

> 
> To me looks like the driver only allows th_zone's exist only with
> valid therm_dev, isn't it? Except for the probe sequence, maybe, at
> run time there is a time window that we have valid th_zone with
> invalid therm_dev. However, reading the probe, still, the irq gets
> initialized only in very end, so the work queue don't get queue till
> then at least.
> 
> So, my question before acking is, shall we remove this check
> altogether?

I think that it is up to you to decide how we proceed. 

Shall this patch go into v3.12-rcX since it is "obvious" (and documents
what and when was broken) or would you require to prepare "new" patch
with removal of this check?

> 
> 
> >  		return;
> >  
> >  	if (th_zone->bind == false) {
> > 
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
