Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3CWQa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 12:30:59 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41903 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3CWQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 12:30:58 -0400
Date: Sat, 23 Mar 2013 17:30:52 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Soeren Moch <smoch@web.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Kirkwood: fix unused mvsdio gpio pins
Message-ID: <20130323173052.10ecc4cb@skate>
In-Reply-To: <514DC982.3010706@gmail.com>
References: <1364043420-17641-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130323161744.5d13c570@skate>
	<514DC982.3010706@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Sat, 23 Mar 2013 16:25:54 +0100, Sebastian Hesselbarth wrote:

> I understand that you proposed patch fixes mvsdio grab mpp0 by accident.
> But what if you have a kirkwood board where cd-gpio _is_ connected to mpp0?

It didn't work with the existing mvsdio driver, so the purpose of my
patch was merely to restore the old behavior, in order to avoid having
to change all the instances of mvsdio_platform_data, knowing that those
would anyway go away as we convert boards to the Device Tree.

> Not that there is one I know of, but IMHO the only useful patch is to
> set passed values to an invalid gpio number.

To me, it remains a fragile way of doing things. Let's say tomorrow you
add a new "int foo_gpio" field in mvsdio_platform_data. The whole
purpose of C99 struct initializers is that you don't have to change all
instances of the structure because all fields that are not initialized
with .<field> = <value> are guaranteed to be zero. If you need to set
foo_gpio to -1 everywhere when you add this field, it becomes quite
annoying.

> > That said, I have nothing against explicitly setting those GPIO values
> > to an invalid value. Maybe -EINVAL would make more sense than just -1 ?
> 
> Every invalid gpio number will be sufficient. But -EINVAL doesn't make
> more sense than -1 does. Having no cd-gpio is not an "Invalid argument".

It's just that I've seen -EINVAL being used on some other platforms, at
least mach-at91/, but I agree it's not an invalid argument per se.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
