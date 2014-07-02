Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbaGBTKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:10:09 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:57203 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaGBTKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:10:03 -0400
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2014 15:10:02 EDT
Message-ID: <1404327517.10859.3.camel@linux-fkkt.site>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
From: Oliver Neukum <oliver@neukum.org>
To: Stefan Klug <stefan.klug@baslerweb.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu
Date: Wed, 02 Jul 2014 20:58:37 +0200
In-Reply-To: <53B42B14.7010303@baslerweb.com>
References: <53B42B14.7010303@baslerweb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 17:53 +0200, Stefan Klug wrote:

> Implementation details:
> The patch only touches drivers/usb/core/devio.c.
> In procy_do_submiturb(), it is checked if zerocopy is allowed. This is 
> currently a rough
> check which compares the number of required pages to 
> ps->dev->bus->sg_tablesize.

It seems to me that the check is per call, so using
multiple calls one could still pin unlimited amounts
of memory.

> I don't know if there is more to check there.
> Then the user memory provided inside the usbdevfs_urb structure is 
> pinned to
> physical memory using get_user_pages_fast().
> All the user pages are added to the scatter-gather list and the logic 
> continues as before.

How do you enforce the cache coherency rules?
Also you don't have a fall back if get_user_pages_fast()
returns less than requested. It seems to me that than you
ought to fall back buffered IO.

	Regards
		Oliver


