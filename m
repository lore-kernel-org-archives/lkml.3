Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3LXMqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:46:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55575 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3LXMqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:46:08 -0500
Date: Tue, 24 Dec 2013 12:45:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20131224124538.GZ30815@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-7-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815830-8794-7-git-send-email-pawel.moll@arm.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 06/18] regmap: Formalise use of non-bus context
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 04:23:38PM +0000, Pawel Moll wrote:

I'd note that I wasn't CCed on most of this series so I'm not entirely
sure what it's trying to do.

> Bus-less maps (ones with reg_read and reg_write functions
> defined in regmap_config) were given the context passed
> in regmap_init(), but it was still called "bus_context".
> 
> This patch formalises this aspect by renaming it to simple
> "context" and adds the missing link, free_context function
> in regmap_config, which allows bus-less maps to use the
> context in classic way.

This should be two patches, one patch to do the rename and one to add
the operation.  The obvious question here is why is this callback useful
- what is being allocated in a regmap specific context that needs to be
lifetime managed separately to the thing doing the creation?  I can't
see any obvious reason why this would ever get used.
