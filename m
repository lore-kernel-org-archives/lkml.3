Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3GJQzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:55:16 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62502 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3GJQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:55:14 -0400
Date: Wed, 10 Jul 2013 09:55:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 22/51] Input: atmel_mxt_ts - Add shutdown function
Message-ID: <20130710165509.GC22992@core.coreip.homeip.net>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-23-git-send-email-nick.dyer@itdev.co.uk>
 <20130707052934.GB15453@core.coreip.homeip.net>
 <51DA8CB6.2010109@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DA8CB6.2010109@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 10:56:06AM +0100, Nick Dyer wrote:
> Dmitry Torokhov wrote:
> > On Thu, Jun 27, 2013 at 01:48:57PM +0100, Nick Dyer wrote:
> >> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> >> Acked-by: Benson Leung <bleung@chromium.org>
> > 
> > Why is this needed?
> 
> The patch disables the interrupt handler on shutdown.
> 
> One of our customers reported a bug caused by input events being generated
> during shutdown (for example if the user was touching the device whilst it
> was turning off), which was solved by putting in this change.

What kind of bug? Could you please be more precise?

> 
> However, now you've drawn my attention to it again, it seems to me that
> probably a better thing for us to be doing would be to power off the
> touchscreen controller here, and let the interrupt disable be handled by
> core code - do you agree?

We'd be powering off everything in a moment anyway, no? Or is there a
concern that the device will stay powered up even if the system is in off
state?

Thanks.

-- 
Dmitry
