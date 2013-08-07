Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3HGSnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:43:00 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34756 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab3HGSm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:42:59 -0400
Date: Wed, 7 Aug 2013 11:42:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Moiseev <o2g.org.ru@gmail.com>
Cc: linux-input@vger.kernel.org, arnoques@gmail.com, russianneuromancer@ya.ru,
        ike.pan@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] input: ideapad_slidebar: new input driver
Message-ID: <20130807184254.GA830@core.coreip.homeip.net>
References: <52022EAE.5040000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52022EAE.5040000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Wed, Aug 07, 2013 at 03:25:34PM +0400, Andrey Moiseev wrote:
> +/* Keyboard handler */
> +static irq_handler_t kbd_irq_handler(int irq, void *dev_id,
> +                    struct pt_regs *regs)
> +{
> +    /* Scancodes: e03b on move, bb on release */
> +    int scancode = inb(0x60);

No, you should not just read KBC data without regard to what other
parts of kernel are doing (i8042 might be accessing it at the same time
because AUX IRQ was raised).

This driver has to be implemented as i8042 filter.

Thanks.

-- 
Dmitry
