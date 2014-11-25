Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaKYOWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:22:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15039 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaKYOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:22:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b9-5474908f77ed
Message-id: <1416925325.26128.6.camel@AMDC1943>
Subject: Re: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Date: Tue, 25 Nov 2014 15:22:05 +0100
In-reply-to: <547485F5.50600@collabora.co.uk>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
 <54736AD0.4070909@collabora.co.uk> <1416907375.5023.54.camel@AMDC1943>
 <547485F5.50600@collabora.co.uk>
Content-type: multipart/mixed; boundary="=-t4KcOohHTQ3Z+aShKAkE"
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Zd3+CSUhBktPSlu0XTnIbnH0d4FF
	/+PXzBZPNz9mstj0+BqrxeVdc9gsZpzfx2TxdMJFNovDb9pZLVbt+sPowOXx9/l1Fo+ds+6y
	e2xa1cnmcefaHjaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj2LRO1oKZxhXz9k9k
	bmDcrNHFyMkhIWAisfDLJCYIW0ziwr31bCC2kMBSRonb6/i6GLmA7M+MEiuurgFL8AroS7Qf
	f8MOYgsL+EtsmjiPBcRmEzCW2Lx8CViNiICdxI3VD5lBmpkFbjBJPLh0mLWLkYODRUBVYs4c
	Z5AaTgFdic+7O9ghFmxilHj++TzYUGYBB4kzGyczgdRLCChLNPa7QewVlPgx+R7LBEb+WUiq
	ZiFJQcQ1JVq3/2aHsOUltr+dwwxhx0msb7zMCmFnSDxYP4sFWc0CRvZVjKKppckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGCGx9WUH4+JjVocYBTgYlXh4DRJLQoRYE8uKK3MPMaoAzXm0YfUFRimW
	vPy8VCUR3qBeoDRvSmJlVWpRfnxRaU5q8SFGJg5OqQZGnayd/5edTJky5+Bz37iYjmUh+wRk
	Vd1au1LKDT2+2i3a+C13W/9+0/j/rIc+vvJrtoyaxszB5HPnxy3L29duWz3ziYmX/cdS7e97
	wfbh48xmZa3Tbw5m/H0s2WNwsaVmyfXsz12r2Stex2s0/DnwK2LZtUNnE654nzVyD9kfJsny
	VKz98CEmJZbijERDLeai4kQAZsQ3dZcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t4KcOohHTQ3Z+aShKAkE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On wto, 2014-11-25 at 14:36 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 11/25/2014 10:22 AM, Krzysztof Kozlowski wrote:
> > 
> > Hmmm, that's strange. I've looked again at your dmesg and it is little
> > different than mine (when system fails).
> > 1. Does your PMIC come up? In your dmesg:
> > [    2.687297] max77802-pmic max77802-pmic: regulator init failed for 0
> > [    2.693539] platform max77802-pmic: Driver max77802-pmic requests probe deferral
> >
> 
> The Peach Pit/Pi DTS define the parent input supplies for the max77802 PMIC
> regulators and these are regulators from the tps65090 PMU but the max77802
> is probed before. When the system does not fail, the probe is deferred and
> succeed later but I don't know when the system fails (more on that below).

OK.

>  
> > 2. In my case booting fails just after disabling unused clocks which is
> > quite early, my dmesg:
> > [   11.700074] input: gpio_keys as /devices/platform/gpio_keys/input/input0
> > [   11.704282] s3c-rtc 101e0000.rtc: setting system clock to 2029-01-11 19:19:17 UTC (1862853557)
> > [   11.770602] mmcblk0: mmc0:0001 M8G1WA 7.28 GiB
> > [   11.776201] mmcblk0boot0: mmc0:0001 M8G1WA partition 1 2.00 MiB
> > [   11.780968] mmcblk0boot1: mmc0:0001 M8G1WA partition 2 2.00 MiB
> > [   11.786823] mmcblk0rpmb: mmc0:0001 M8G1WA partition 3 128 KiB
> > [   11.793815]  mmcblk0: p1 p2 p3 p4
> > [   11.824165] PVDD_G3D_1V0: disabling
> > [   11.830833] PVDD_G3DS_1V0: disabling
> > [   11.837771] PVDD_HSIC_1V8: disabling
> > [   11.841172] PVDD_ABB_1V8: disabling
> > [   11.844866] PVDD_ANAIP_1V8: disabling
> > [   11.847157] usb 5-1.4: new high-speed USB device number 3 using exynos-ehci
> > [   11.848778] PVDD
> > 
> > In your case you have a gap here:
> > [    3.624142] platform 12d10000.adc: Driver exynos-adc requests probe deferral
> > [   24.188722] random: nonblocking pool is initialized
> >
> > Could you try my patches once again but this time with enabled:
> > DEBUG_EXYNOS_UART
> > EARLY_PRINTK
> > DEBUG_S3C_UART3
> > DEBUG_LL
> >
> 
> Yes, there is a gap and I don't know why. Even after enabling all those
> config options, nothing is printed on the serial console after the exynos-adc
> probe deferral. Only that message in drivers/char/random.c is printed but
> nothing else is printed after all...

You may try attached patch (very early printk) if you suspect that some
logs are missing.

> 
> > and with following change:
> > 
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index 4896ae9e23da..316856e55784 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -478,7 +478,9 @@ static void clk_disable_unused_subtree(struct clk *clk)
> >          * sequence.  call .disable_unused if available, otherwise fall
> >          * back to .disable
> >          */
> > +       pr_err("clk: checking %s\n", clk->name);
> >         if (__clk_is_enabled(clk)) {
> > +               pr_err("clk: enabled %s, disabling\n", clk->name);
> >                 if (clk->ops->disable_unused)
> >                         clk->ops->disable_unused(clk->hw);
> >                 else if (clk->ops->disable)
> > 
> > Without my patch the boot hangs:
> > [   12.230666] clk: checking dout_unipro
> > [   12.234304] clk: checking mout_unipro
> > [   12.237913] clk: checking sclk_usbd300
> > [   12.241638] clk: enabled sclk_usbd300, disabling
> > [   12.246264] clk: checking dout_usbd300
> > [   12.249992] clk: checking sclk_usbd301
> > [   12.253683] clk: enabled sclk_usbd301, disabling
> > [   12.258309] clk: checking dout_usbd301
> > [   12.262007] clk: checking sclk_maudio0
> > [   12.265728] clk: enabled sclk_maudio0, disabling
> > [   12.270355] clk: checking pcm_bus
> > 
> > because audss seems to be gated so kernel cannot access status of
> > pcm_bus clock.
> >
> 
> I added those printk's but clk_disable_unused() is executed after the
> exynos-adc probe function so the logs are not shown on the serial console.

So this would mean that something fails before clk_disable_unused().

> As mentioned previously in the thread, Tushar's fix [0] works for me and with
> that patch I see the clocks disabled by clk_disable_unused_subtree() and the
> kernel is able to access pcm_bus and other audio clocks:
> 
> [    5.007368] clk: checking mout_spdif
> [    5.010908] clk: checking dout_audio0
> [    5.014566] clk: checking mout_audio0
> [    5.018208] clk: checking sclk_maudio0
> [    5.021926] clk: enabled sclk_maudio0, disabling
> [    5.026541] clk: checking pcm_bus
> [    5.029820] clk: enabled pcm_bus, disabling
> [    5.034001] clk: checking sclk_pcm
> [    5.037367] clk: enabled sclk_pcm, disabling
> 
> Any ideas?

Yes, I got. On Peach board the i2s0 is enabled in DTS. Probing it could
fail because it relies on enabling audss clocks (which cannot be
accessed).

I reproduced another hang on Arndale Octa after enabling i2s0 in DTS.
Maybe that is the cause also on Peach.

Best regards,
Krzysztof




--=-t4KcOohHTQ3Z+aShKAkE
Content-Disposition: attachment; filename="319-Very-early-printk-for-next-20141106-3.19.patch"
Content-Type: text/x-patch; name="319-Very-early-printk-for-next-20141106-3.19.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From def8df7c5d8098ec1656c075701e9ba17f0617c9 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Date: Thu, 6 Nov 2014 12:58:07 +0100
Subject: [PATCH] Very early printk, for next-20141106 (3.19?)

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 kernel/printk/printk.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1b7092dbb590..269318013504 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1708,6 +1708,13 @@ asmlinkage int vprintk_emit(int facility, int level,
 		}
 	}
 
+	if (1) {
+		extern void printascii(const char *);
+		printascii(text);
+		printed_len = 0;
+		goto early_printk_out;
+	}
+
 	if (level == LOGLEVEL_DEFAULT)
 		level = default_message_loglevel;
 
@@ -1754,6 +1761,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 						 dict, dictlen, text, text_len);
 	}
 
+early_printk_out:
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
 	lockdep_on();
-- 
1.9.1


--=-t4KcOohHTQ3Z+aShKAkE--

