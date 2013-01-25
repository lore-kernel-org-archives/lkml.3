Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3AYISO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:18:14 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:41412 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3AYISM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:18:12 -0500
Date: Fri, 25 Jan 2013 08:18:11 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Afzal Mohammed <afzal@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 1/4] ARM: OMAP2+: dpll: round rate to closest value
In-Reply-To: <871e6890897534b6c3669e252f23bef5ff1247b6.1358937533.git.afzal@ti.com>
Message-ID: <alpine.DEB.2.00.1301250816010.471@utopia.booyaka.com>
References: <cover.1358937533.git.afzal@ti.com> <871e6890897534b6c3669e252f23bef5ff1247b6.1358937533.git.afzal@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, 23 Jan 2013, Afzal Mohammed wrote:

> Currently round rate function would return proper rate iff requested
> rate exactly matches the PLL lockable rate. This causes set_rate to
> fail if exact rate could not be set. Instead round rate may return
> closest rate possible (less than the requested). And if any user is
> badly in need of exact rate, then return value of round rate could
> be used to decide whether to invoke set rate or not.
> 
> Modify round rate so that it return closest possible rate.

This doesn't look like the right approach to me.  For some PLLs, an exact 
rate is desired.

We removed the rate tolerance code in commit 
241d3a8dca239610d3d991bf58d4fe38c2d86fd5, but that was probably premature.  
We've encountered several situations now where we could really use it, 
like MPU CPUFreq.  I'd suggest reverting 
241d3a8dca239610d3d991bf58d4fe38c2d86fd5 or using a similar approach.


- Paul
