Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3EPVUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:20:06 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52061 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab3EPVUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:20:04 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: samsung: fix suspend/resume functionality
Date: Thu, 16 May 2013 23:19:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1368724352-10849-1-git-send-email-dianders@chromium.org> <1368724352-10849-2-git-send-email-dianders@chromium.org> <1944811.006SLH6aYj@flatron>
In-Reply-To: <1944811.006SLH6aYj@flatron>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305162319.48168.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 16. Mai 2013, 21:19:20 schrieb Tomasz Figa:
[...]
> > +
> > +		if (type->fld_width[PINCFG_TYPE_CON_PDN]) {
> > +			bank->pm_save.conpdn = readl(reg +
> > +				type->reg_offset[PINCFG_TYPE_CON_PDN]);
> > +			bank->pm_save.pudpdn = readl(reg +
> > +				type->reg_offset[PINCFG_TYPE_PUD_PDN]);
> > +		}
> 
> I wonder if you couldn't do all the saving here in a single loop over all
> pin control types, like:
> 
> 	unsigned int offsets = bank->type->reg_offsets;
> 	unsigned int widths = bank->type->fld_width;
> 
> 	for (i = 0; i < PINCFG_TYPE_NUM; ++i)
> 		if (widths[i])
> 			bank->pm_save[i] = readl(reg + offsets[i]);
> 
> The only thing not handled by this loop is second CON registers in banks
> with two of them. I can't think of any better solution for this other than
> just adding a special case after the loop.

doing this in the loop over the pinctrl types like Tomasz suggests, also 
nicely fixes the problem of s3c24xx [0] only having FUNC, DAT and PUD and some 
(gpa) not even having the PUD, which was not checked in the original patch.


Heiko

[0] patch is with Kgene currently, so should make it into 3.11
