Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3IPLGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:06:19 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34976 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab3IPLGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:06:18 -0400
Date: Mon, 16 Sep 2013 12:06:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
Message-ID: <20130916110614.GK3999@lee--X1>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
 <20130916091956.GF3999@lee--X1>
 <20130916104009.GA29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130916104009.GA29403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Mark Brown wrote:

> On Mon, Sep 16, 2013 at 10:19:56AM +0100, Lee Jones wrote:
> 
> > Can't you just NULL .id_table?
> 
> > Here's the code which would use it:
> > > /* match on an id table if there is one */
> > > if (driver->id_table)
> > >         return i2c_match_id(driver->id_table, client) != NULL;
> 
> > Matching for "dummy" will just waste cycles.
> 
> i2c_device_probe() will return -ENODEV if id_table is NULL before we get
> to actually matching.  We could remove that check though...

Unless there will be any repercussions that I am naive to I think that
sounds suitable. Any volunteers?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
