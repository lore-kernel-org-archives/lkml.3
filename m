Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3C2Tql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:46:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab3C2Tqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:46:40 -0400
Subject: gpio-ucb1400
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Fri, 29 Mar 2013 20:46:39 +0100
Message-ID: <1364586399.4216.312.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In September 2009, a driver for the GPIO function of the UCB1400 chip
was added to the kernel tree. The probe function of this driver requires
ucbdata to be set. The only place where this happens is in function
ucb1400_gpio_set_data(). This function was never call, and still isn't.
So this is dead code for 3.5 years as far as the upstream kernel is
concerned.

To make things worse, this driver can't be built as a module, for no
good reason that I can see.

Marek, can you explain what was the point of submitting this driver that
nobody can use?

I would like either this driver to be fixed so that it can be used (and
that would IMHO start with dropping the ugly ucb1400_gpio_set_data hook
and global variable ucbdata), or this driver to be dropped from the
kernel tree. If the driver is kept, it should be adjusted so that it can
be built as a module.

If I overlooked something, please let me know.

Thanks,
-- 
Jean Delvare
Suse L3

