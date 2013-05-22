Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3EVQ7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:59:14 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:37022 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3EVQ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:59:13 -0400
Date: Wed, 22 May 2013 17:53:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
Message-ID: <20130522165353.GB18714@gmail.com>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
 <20130522155347.GJ1627@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130522155347.GJ1627@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Mark Brown wrote:

> On Wed, May 22, 2013 at 01:47:33PM +0100, Lee Jones wrote:
> > This patch fixes a bug introduced in the v3.10 merge window.
> > 
> > Some platforms will not want external registers. Rather than setting up
> > lots of different clauses in the core ab8500 regulator driver not to
> > call ab8500-ext init() we just won't pass the initialisation data from
> > platform code. This patch checks for it and if it's missing, we won't
> > register the external regulators.
> 
> This seems problematic - if the regulators are unused then they
> shouldn't have anything enabled in the constraints

Right, that's what this does.

"we just won't pass the initialisation data from platform code."

'initialisation data' == 'constraints'.

> and the regulator
> driver ought to be read only in which case it doesn't matter if it's
> running or not, the worst that should happen is that the state can be
> read back.  I'd therefore expect the fix here to be in the board side
> code that enables the regulators.

It's both.

>From the platform side we have stopped passing the external regulator
driver's constraints for Snowball:

https://lkml.org/lkml/2013/5/22/280

All I've done here is stop the ext driver from crapping out with the
misleading error "Configuration error: size mismatch", because a)
it's not an error, it's expected and b) It's not a size mismatch,
instead we have chosen to keep the constraints back in the Snowball
(and u8505) case.

Strictly speaking 'this' part of the fix is not an -rc candidate, but
without it someone could waste a great deal of time finding out why
this 'error' has appeared when it's not actually an error at all. Thus,
it would be more than helpful if it made it into the -rcs along with
the real platform fix.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
