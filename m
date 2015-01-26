Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbbAZUyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:54:31 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:62497 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbbAZUy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:54:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
	<alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
Date: Mon, 26 Jan 2015 21:54:28 +0100
Message-ID: <CAFLxGvzhaK-m4+QuBwGkdm4mQptSg7+e9DZtkhZEKpBn5gNJjw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] fbcon: expose cursor blink interval via sysfs
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 9:41 PM, Scot Doyle <lkml14@scotdoyle.com> wrote:
> The fbcon cursor, when set to blink, is hardcoded to toggle display state
> five times per second. Expose this setting via
> /sys/class/graphics/fbcon/cursor_blink_ms
>
> Values written to the interface set the approximate time interval in
> milliseconds between cursor toggles, from 1 to 32767. Since the interval
> is stored internally as a number of jiffies, the millisecond value read
> from the interface may not exactly match the entered value.
>
> An outstanding blink timer is reset after a new value is entered.
>
> If the cursor blink is disabled, either via the 'cursor_blink' boolean
> setting or some other mechanism, the 'cursor_blink_ms' setting may still
> be modified. The new value will be used if the blink is reactivated.

Out of curiosity, why do you need this new setting?
Your patch describes what it does but does not describe the "why".

-- 
Thanks,
//richard
