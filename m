Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3CWPRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 11:17:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41796 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3CWPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 11:17:49 -0400
Date: Sat, 23 Mar 2013 16:17:44 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Soeren Moch <smoch@web.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Kirkwood: fix unused mvsdio gpio pins
Message-ID: <20130323161744.5d13c570@skate>
In-Reply-To: <1364043420-17641-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1364043420-17641-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Sat, 23 Mar 2013 13:56:58 +0100, Sebastian Hesselbarth wrote:
> mvsdio_platform_data allows to pass card detect and write protect gpio
> numbers to the driver. Some kirkwood boards don't use both pins as
> they are not connected, and don't set the corresponding value in
> platform_data.
> 
> This will leave the unset values in platform_data initialized as 0,
> which is in fact a valid gpio pin. mvsdio will grab that pin and
> configure it as gpio, which in turn breaks nand controller as mpp0
> also carries nand_io2.
> 
> This patch fixes the above by initializing unused gpio functions in
> the platform_data with an invalid (-1) value.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reported-by: Soeren Moch <smoch@web.de>

This somewhat "conflicts" with the patch I've submitted on the mvsdio
driver to exclude 0 as a valid GPIO, see
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-March/157157.html.
This patch ensures that the mvsdio driver behaves as it was behaving
before 3.9 as far as legacy probing is concerned.

That said, I have nothing against explicitly setting those GPIO values
to an invalid value. Maybe -EINVAL would make more sense than just -1 ?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
