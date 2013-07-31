Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab3GaNmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:42:23 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:48247 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759766Ab3GaNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:42:20 -0400
Date: Wed, 31 Jul 2013 09:42:15 -0400
From: Tejun Heo <htejun@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>, alexander.shishkin@linux.intel.com,
        kernel@pengutronix.de, linux-usb@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130731134215.GS2810@htj.dyndns.org>
References: <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731132708.GQ9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 31, 2013 at 02:27:08PM +0100, Mark Brown wrote:
> It's really only interrupts that affect most devices - if there's DMA or
> anything going on after the remove() then as you said earlier the driver
> is probably doing something wrong.

Hmmm... it depends on the specific driver is converted but if the
deactivation sequence - shutting down of command engine - is also
handled by devm as in libata and if you have non-devres resource free
in the exit path, you have the same problem.  Again, in general,
tearing things down in the order which isn't the reverse of allocation
is a bad idea.  Adhering to the order isn't that hard and will result
in far less craziness in the long term.

Thanks.

-- 
tejun
