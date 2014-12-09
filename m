Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaLIIw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:52:28 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:56038 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaLIIw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:52:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Olof Johansson <olof@lixom.net>,
        arm@kernel.org, Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        mporter@linaro.org
Subject: Re: [PATCH] ARM: bcm: fix __iomem annotation on kona_smc
Date: Tue, 09 Dec 2014 09:51:38 +0100
Message-ID: <3044718.ZPFEmzteVb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54862498.8080101@gmail.com>
References: <1418075148-8752-1-git-send-email-olof@lixom.net> <54862498.8080101@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:QTVxm4wVe+26h3Ygyp15biX5F1dG1HVaBx9RUEfHBgVrsVlNsLa
 wuGj8jhTH7iEW4aj8OZi1wbLc+Bibl3zSPyl431CjMlScGJVcoPaOcNWGbeaPOI7eXu0+bI
 D04ZYrtnxPHIxa1rDWqWVPOfitvMEXCgW4zSdCLZ4lQW+/zEJRtmxI4gIdarT+LjW0CfxTK
 N0xECDYON4lCvSuQyTKoQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 14:22:16 Florian Fainelli wrote:
> > diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
> > index a55a7ec..d506d17 100644
> > --- a/arch/arm/mach-bcm/bcm_kona_smc.c
> > +++ b/arch/arm/mach-bcm/bcm_kona_smc.c
> > @@ -142,7 +142,7 @@ static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
> >  static void __bcm_kona_smc(void *info)
> >  {
> >       struct bcm_kona_smc_data *data = info;
> > -     u32 *args = bcm_smc_buffer;
> > +     u32 __iomem *args = bcm_smc_buffer;
> 
> Your fix looks good to me, although the original code sounds a little
> dubious, especially in LPAE environment.

Right, I think it could just use of_iomap() and drop the size
check. If you want to keep the check, using of_address_to_resource()
will do the right thing.

	Arnd
