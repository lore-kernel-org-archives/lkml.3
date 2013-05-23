Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3EWHJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:09:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51835 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3EWHJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:09:11 -0400
Date: Thu, 23 May 2013 08:09:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
Message-ID: <20130523070905.GD18714@gmail.com>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
 <20130522155347.GJ1627@sirena.org.uk>
 <20130522165353.GB18714@gmail.com>
 <20130522174516.GT1627@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130522174516.GT1627@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Mark Brown wrote:

> On Wed, May 22, 2013 at 05:53:53PM +0100, Lee Jones wrote:
> > On Wed, 22 May 2013, Mark Brown wrote:
> 
> > > running or not, the worst that should happen is that the state can be
> > > read back.  I'd therefore expect the fix here to be in the board side
> > > code that enables the regulators.
> 
> > It's both.
> 
> > From the platform side we have stopped passing the external regulator
> > driver's constraints for Snowball:
> 
> > https://lkml.org/lkml/2013/5/22/280
> 
> > All I've done here is stop the ext driver from crapping out with the
> > misleading error "Configuration error: size mismatch", because a)
> > it's not an error, it's expected and b) It's not a size mismatch,
> > instead we have chosen to keep the constraints back in the Snowball
> > (and u8505) case.
> 
> OK, so the regulator driver is buggy and insisting on having constraints
> passed in for every regulator then?

If that's not how it's meant to work then, yes.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
