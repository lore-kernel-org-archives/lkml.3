Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbbAXPvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:51:06 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58667 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbAXPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501240117400.3639@localhost.localdomain>
References: <alpine.DEB.2.11.1501240109060.3489@localhost.localdomain>
	<alpine.DEB.2.11.1501240117400.3639@localhost.localdomain>
Date: Sat, 24 Jan 2015 16:50:58 +0100
X-Google-Sender-Auth: vvKlRsfKAftMEg3Rsk2MrTKcvOM
Message-ID: <CAMuHMdX2cs_JW4QEC=E=m2Z6gg=kZE5PnHBQYZ5RnFp1E9m_fQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] fbcon: expose cursor blink interval via sysfs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 2:19 AM, Scot Doyle <lkml14@scotdoyle.com> wrote:
> +static ssize_t store_cursor_blink_ms(struct device *device,
> +                                    struct device_attribute *attr,
> +                                    const char *buf, size_t count)
> +{

...

> +       unsigned long ms;

...

> +       if (!kstrtoul(buf, 0, &ms)) {

kstrtos16()?

> +               ms = min_t(unsigned long, ms, SHRT_MAX);
> +               ops->blink_jiffies = max_t(int, msecs_to_jiffies(ms), 1);


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
