Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3AQJgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:36:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42723 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3AQJgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:36:15 -0500
Message-ID: <1358415316.6252.20.camel@cumari.coelho.fi>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
From: Luciano Coelho <coelho@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Thu, 17 Jan 2013 11:35:16 +0200
In-Reply-To: <50F7C4A7.5060202@ti.com>
References: <1358372702-13102-1-git-send-email-coelho@ti.com>
	 <50F7C4A7.5060202@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 10:30 +0100, Peter Ujfalusi wrote:
> Hi Luca,

Hi Péter!

> On 01/16/2013 10:45 PM, Luciano Coelho wrote:
> >  static struct ti_st_plat_data wilink_platform_data = {
> > -	.nshutdown_gpio	= 46,
> >  	.dev_name	= "/dev/ttyO1",
> >  	.flow_cntrl	= 1,
> >  	.baud_rate	= 3000000,
> > -	.chip_enable	= NULL,
> > -	.suspend	= NULL,
> > -	.resume		= NULL,
> > +	.chip_enable	= plat_kim_chip_enable,
> > +	.chip_disable	= plat_kim_chip_disable,
> 
> I just wonder how this is going to work with DT... You are not going to have
> the ability to use callback in this form.
> I think the GPIO handling should be done in the driver itself rather than in
> the board file.

I agree.  The problem is that it used to be in the ti-st driver itself,
but it has been removed in a patch that says "different platforms have
begun to have their own ways to power-up/down the chip." (eccf2979
drivers/misc/ti-st: remove gpio handling).

This needs to be clarified first.  I think we could use this for now and
later fix this properly (hopefully move it back to the ti-st driver).

--
Cheers,
Luca.

