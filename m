Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3AVVch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:32:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38643 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3AVVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:32:36 -0500
Message-ID: <1358890299.6252.166.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Revert "drivers/misc/ti-st: remove gpio handling"
From: Luciano Coelho <coelho@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <gregkh@linuxfoundation.org>, <peter.ujfalusi@ti.com>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jan 2013 23:31:39 +0200
In-Reply-To: <20130122201453.GR22517@atomide.com>
References: <1358766762-24405-1-git-send-email-coelho@ti.com>
	 <20130122201453.GR22517@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 12:14 -0800, Tony Lindgren wrote:
> * Luciano Coelho <coelho@ti.com> [130121 03:16]:
> > This reverts commit eccf2979b2c034b516e01b8a104c3739f7ef07d1.
> > 
> > The reason is that it broke TI WiLink shared transport on Panda.
> > Also, callback functions should not be added to board files anymore,
> > so revert to implementing the power functions in the driver itself.
> > 
> > Additionally, changed a variable name ('status' to 'err') so that this
> > revert compiles properly.
> > 
> > Cc: stable <stable@vger.kernel.org> [3.7]
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> 
> This also makes sense from converting to DT based boot as the GPIO
> calls should happen in the driver. Those mdelays probably can be fixed,
> but since this is a revert to a known working version:

I thought about checking exactly what we need as delays and whether we
really need to do all that toggling.  At least in some boards, the
toggles are not needed, but I don't know for sure whether it works in
all different variations of the chip, so I kept them to be safe.  Also,
I tried to deviate as little as possible from a plain revert, since I'd
like to get this into stable as well.


> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks!

--
Luca.

