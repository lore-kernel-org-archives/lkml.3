Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaJIIiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:38:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34779 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJIIit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <20141009074729.GN3279@distanz.ch>
References: <1412760595-3935-1-git-send-email-lftan@altera.com>
	<1412760595-3935-18-git-send-email-lftan@altera.com>
	<20141009074729.GN3279@distanz.ch>
Date: Thu, 9 Oct 2014 16:38:47 +0800
X-Google-Sender-Auth: PioLC7S8Q9WnhALFeZwvKOyieNM
Message-ID: <CAFiDJ5-E6_K-pH9NAoPAifY=+mWhofn6gP9avtGs5aQ2kT1hRA@mail.gmail.com>
Subject: Re: [PATCH v4 17/29] nios2: System calls handling
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 3:47 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
>> +#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
>> +#include <linux/fb.h>
>> +unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr,
>> +             unsigned long len, unsigned long pgoff, unsigned long flags)
>> +{
>> +
>> +     struct fb_info *info = filp->private_data;
>> +
>> +     return (unsigned long)info->screen_base;
>> +}
>> +EXPORT_SYMBOL(get_fb_unmapped_area);
>
> get_fb_unmapped_area only used if HAVE_ARCH_FB_UNMAPPED_AREA is defined,
> but this isn't the case for nios2. AFAICS the altfb driver has been
> broken on nios2 for a long time anyway, so I'd suggest to just remove
> this function for now.
Okay.

Regards
Ley Foon
