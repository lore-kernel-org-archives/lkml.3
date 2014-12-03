Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaLCKwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:52:08 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:56325 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaLCKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:52:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] ARM: imx: add support for MSCM interrupt router
Date: Wed, 03 Dec 2014 11:51:09 +0100
Message-ID: <2336832.xq32rHipj9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417565531-4507-7-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-7-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ea6AXii02c9iuuTL6i/Yq1diJZ0gN5KoKKcktBehsHY
 fxfDEQD+TWjQvHUYMT+XZPnvmkzizwItpzVlWw/EGsjMmhehYN
 fkgD3Fj5q6xFeRkHMIwtS3us/RQRqjxCWctAompMuSTpn2uNaJ
 ihw9QeZxbcRS/wPSgT2Y8KItOuLux4ikGayASbnk2bVsNgSXGC
 s0ZkvcXcJ5b9ELm1l8ylwmlQ57WFZXmzdQ1cCpALdzu560TBJX
 Fm/nbbcX/DjkaISH7+4juatdGEhMxUwYuDpptYsOUlRlovFBOc
 BdROJ50dN/sQat9r4RsP7HnCam1sPEjVcqYghhx+xYSJMG5vn7
 COmcWE573umAFd36M6Yc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 01:12:05 Stefan Agner wrote:
> +
> +static int vf610_mscm_domain_xlate(struct irq_domain *d,
> +				struct device_node *controller,
> +				const u32 *intspec, unsigned int intsize,
> +				unsigned long *out_hwirq,
> +				unsigned int *out_type)
> +{
> +#ifdef CONFIG_ARM_GIC
> +	*out_hwirq += 16;
> +#endif
> +	return 0;
> +}

I don't see how the hwirq should in any way depend on whether the
kernel also supports an ARM_GIC. This number should only be meaningful
inside of your irqchip driver.

	Arnd
