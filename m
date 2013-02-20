Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3BTINU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:13:20 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56138 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3BTINR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:13:17 -0500
Date: Wed, 20 Feb 2013 08:13:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>
Subject: Re: [PATCH 06/35] mfd: ab8500-core: Sysfs chip id modification
Message-ID: <20130220081311.GB3368@gmail.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-7-git-send-email-lee.jones@linaro.org>
 <201302192204.45153.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302192204.45153.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Arnd Bergmann wrote:

> On Friday 15 February 2013, Lee Jones wrote:
> >         struct ab8500 *ab8500;
> > +       int chip_id = -EINVAL;
> >
> >         ab8500 = dev_get_drvdata(dev);
> > -       return sprintf(buf, "%#x\n", ab8500 ? ab8500->chip_id : -EINVAL);
> > +       if(ab8500) {
> > +               chip_id = ab8500->chip_id;
> > +               if((is_ab8505(ab8500) || is_ab9540(ab8500)) && ab8500->version != 0xFF)
> > +                       chip_id = (ab8500->version << 8) | chip_id;
> > +       }
> > +       return sprintf(buf, "%#x\n", chip_id);
> >  }
> 
> What's the use of printing "ffffffea" for unknown versions here?

You mean instead of -EINVAL? No idea, Marcus?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
