Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3FXOve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:51:34 -0400
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:52534 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161Ab3FXOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:51:33 -0400
Date: Mon, 24 Jun 2013 16:37:37 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 2/2] fb: fix atyfb unused data warnings
Message-ID: <20130624143737.GI305@game.jcrosoft.org>
References: <51C26B56.20802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C26B56.20802@infradead.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6524871435616955211
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:39 Wed 19 Jun     , Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix compiler warnings of data defined but not used.  They are only used
> with certain kconfig settings.
> 
> drivers/video/aty/atyfb_base.c:534:13: warning: 'ram_dram' defined but not used [-Wunused-variable]
> drivers/video/aty/atyfb_base.c:535:13: warning: 'ram_resv' defined but not used [-Wunused-variable]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:	Paul Mackerras <paulus@samba.org>
> Cc:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc:	linux-fbdev@vger.kernel.org
> Cc:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc:	Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/video/aty/atyfb_base.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20130619.orig/drivers/video/aty/atyfb_base.c
> +++ linux-next-20130619/drivers/video/aty/atyfb_base.c
> @@ -531,8 +531,10 @@ static int correct_chipset(struct atyfb_
>  	return 0;
>  }
>  
> +#if defined(CONFIG_FB_ATY_GX) || defined(CONFIG_FB_ATY_CT)
>  static char ram_dram[] = "DRAM";
>  static char ram_resv[] = "RESV";
use __maybe_unused macro instead of the ifdef
> +#endif
>  #ifdef CONFIG_FB_ATY_GX
>  static char ram_vram[] = "VRAM";
>  #endif /* CONFIG_FB_ATY_GX */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
