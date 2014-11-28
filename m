Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaK1CI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:08:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:56838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaK1CIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:08:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,473,1413270000"; 
   d="scan'208";a="644790852"
From: "Petallo, MauriceX R" <mauricex.r.petallo@intel.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Eduardo Valentin" <edubezval@gmail.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] thermal: Don't call thermal_zone_device_update inside
 spinlock
Thread-Topic: [PATCH] thermal: Don't call thermal_zone_device_update inside
 spinlock
Thread-Index: AQHQCNTaAE3oAKRFckilj5iR4AxSQZxxGoyAgAQy4RA=
Date: Fri, 28 Nov 2014 02:08:20 +0000
Message-ID: <B48739867A236B498580AFF76C49038631FDE02A@PGSMSX107.gar.corp.intel.com>
References: <1415875624-587-1-git-send-email-mauricex.r.petallo@intel.com>
	 <20141125052258.GB29240@developer>
 <1416938199.2043.234.camel@spandruv-desktop.jf.intel.com>
In-Reply-To: <1416938199.2043.234.camel@spandruv-desktop.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAS28YnJ028582

Hi,
Ok. I will update the title.
Thanks for the feedbacks and Ack.

Regards,
-Maurice

-----Original Message-----
From: Srinivas Pandruvada [mailto:srinivas.pandruvada@linux.intel.com] 
Sent: Wednesday, November 26, 2014 1:57 AM
To: Eduardo Valentin
Cc: Petallo, MauriceX R; Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: Don't call thermal_zone_device_update inside spinlock

On Tue, 2014-11-25 at 01:23 -0400, Eduardo Valentin wrote:
Hi, 
> Hi,
> 
> A minor thing. Your patch title makes us think this fix affects the 
> thermal subsystem completely, whereas it affects a specific driver.
> 
Good point. I overlooked this.

Maurice,
Change the title to something like
"thermal: Intel SoC DTS: Don't call thermal_zone_device_update inside spinlock"

Thanks,
Srinivas 
> 
> On Thu, Nov 13, 2014 at 06:47:04PM +0800, Maurice Petallo wrote:
> > The driver calls spin_lock_irqsave during DTS interrupt. The 
> > interrupt handle then calls thermal_zone_device_update which 
> > implicitly calls a sleep function and produce the following bug:
> >
>  
> > BUG: sleeping function called from invalid context at 
> > kernel/locking/mutex.c:97
> > in_atomic(): 1, irqs_disabled(): 1, pid: 920, name: irq/86-soc_dts
> > CPU: 0 PID: 920 Comm: irq/86-soc_dts Tainted: G            E  3.17.0-rc2+ #1
> > Hardware name: Intel Corp. VALLEYVIEW B3 PLATFORM/NOTEBOOK, BIOS 
> > BYTICRB1.86C.0092.R31.1408290850 08/29/2014
> >  00000000 00000000 c25dbe74 c1818cfd f3cc488c c25dbe9c c1059305 
> > c1b4063b
> >  00000001 00000001 00000398 f3cc488c f6817644 f6817644 f3ecc6c0 
> > c25dbea8
> >  c18208f2 f6817400 c25dbebc c159b0bb c25dbedc f6817400 f32a2300 
> > c25dbee8 Call Trace:
> >  [<c1818cfd>] dump_stack+0x48/0x60
> >  [<c1059305>] __might_sleep+0xec/0xf4  [<c18208f2>] 
> > mutex_lock+0x1c/0x34  [<c159b0bb>] thermal_zone_get_temp+0x34/0x59  
> > [<c159bde5>] thermal_zone_device_update+0x2d/0xcb
> >  [<f85da16a>] ? iosf_mbi_write+0x6c/0x74 [iosf_mbi]  [<f7c7445d>] 
> > soc_irq_thread_fn+0x10c/0x163 [intel_soc_dts_thermal]  [<c107b72b>] 
> > irq_thread_fn+0x18/0x2a  [<c107bedb>] irq_thread+0x81/0x11f  
> > [<c107b713>] ? irq_finalize_oneshot+0x7c/0x7c  [<c107bf79>] ? 
> > irq_thread+0x11f/0x11f  [<c107be5a>] ? wake_threads_waitq+0x31/0x31  
> > [<c1054217>] kthread+0x87/0x8c  [<c1821e41>] 
> > ret_from_kernel_thread+0x21/0x30  [<c1054190>] ? 
> > __kthread_parkme+0x55/0x55
> > 
> > Signed-off-by: Maurice Petallo <mauricex.r.petallo@intel.com>
> > Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > ---
> >  drivers/thermal/intel_soc_dts_thermal.c |   12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/thermal/intel_soc_dts_thermal.c 
> > b/drivers/thermal/intel_soc_dts_thermal.c
> > index a6a0a18..5580f5b 100644
> > --- a/drivers/thermal/intel_soc_dts_thermal.c
> > +++ b/drivers/thermal/intel_soc_dts_thermal.c
> > @@ -360,6 +360,9 @@ static void proc_thermal_interrupt(void)
> >  	u32 sticky_out;
> >  	int status;
> >  	u32 ptmc_out;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&intr_notify_lock, flags);
> >  
> >  	/* Clear APIC interrupt */
> >  	status = iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ, @@ 
> > -378,21 +381,20 @@ static void proc_thermal_interrupt(void)
> >  		/* reset sticky bit */
> >  		status = iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
> >  					SOC_DTS_OFFSET_PTTSS, sticky_out);
> > +		spin_unlock_irqrestore(&intr_notify_lock, flags);
> > +
> >  		for (i = 0; i < SOC_MAX_DTS_SENSORS; ++i) {
> >  			pr_debug("TZD update for zone %d\n", i);
> >  			thermal_zone_device_update(soc_dts[i]->tzone);
> >  		}
> > -	}
> > +	} else
> > +		spin_unlock_irqrestore(&intr_notify_lock, flags);
> >  
> >  }
> >  
> >  static irqreturn_t soc_irq_thread_fn(int irq, void *dev_data)  {
> > -	unsigned long flags;
> > -
> > -	spin_lock_irqsave(&intr_notify_lock, flags);
> >  	proc_thermal_interrupt();
> > -	spin_unlock_irqrestore(&intr_notify_lock, flags);
> >  	pr_debug("proc_thermal_interrupt\n");
> >  
> >  	return IRQ_HANDLED;
> 
> A part from the minor thing I mentioned before, you can add my:
> 
> Acked-by: Eduardo Valentin <edubezval@gmail.com>
> 
> > --
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" 
> > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
