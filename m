Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaIVF5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:57:04 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42651 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaIVF5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:57:01 -0400
Date: Sun, 21 Sep 2014 22:56:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Matt Ranostay <mranostay@gmail.com>, galak@codeaurora.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] cap1106: support for active-high interrupt option
Message-ID: <20140922055656.GA4147@core.coreip.homeip.net>
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
 <1411268469-21283-3-git-send-email-mranostay@gmail.com>
 <541EA326.1070404@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541EA326.1070404@zonque.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 12:06:30PM +0200, Daniel Mack wrote:
> On 09/21/2014 05:01 AM, Matt Ranostay wrote:
> > Some applications need to use the active-high push-pull interrupt
> > option. This allows it be enabled in the device tree child node.
> > 
> > Signed-off-by: Matt Ranostay <mranostay@gmail.com>
> > ---
> >  drivers/input/keyboard/cap1106.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
> > index b9c43b5..33e2590 100644
> > --- a/drivers/input/keyboard/cap1106.c
> > +++ b/drivers/input/keyboard/cap1106.c
> > @@ -234,6 +234,12 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
> >  			dev_err(dev, "Invalid sensor-gain value %d\n", gain32);
> >  	}
> >  
> > +	if (of_property_read_bool(node, "microchip,active-high")) {
> 
> I think the name of that property should make clear it's only changing
> the interrupt output driver configuration. What about
> "microchip,irq-active-high"?

Can we infer the setting from IRQ flags by chance?

Thanks.

-- 
Dmitry
