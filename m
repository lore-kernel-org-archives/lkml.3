Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3DVTfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:35:30 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38292 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3DVTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:35:28 -0400
Date: Mon, 22 Apr 2013 12:35:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] usb: storage: Convert US_DEBUGP to usb_stor_dbg
In-Reply-To: <1366397040.3901.45.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1304221234270.16385@chino.kir.corp.google.com>
References: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org> <1366254055.28609.61.camel@joe-AO722> <20130419173503.GA27495@kroah.com> <1366397040.3901.45.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013, Joe Perches wrote:

> @@ -966,11 +934,13 @@ static int realtek_cr_autosuspend_setup(struct us_data *us)
>  static void realtek_cr_destructor(void *extra)
>  {
>  	struct rts51x_chip *chip = (struct rts51x_chip *)extra;
> -
> -	US_DEBUGP("%s: <---\n", __func__);
> +	struct us_data *us;
>  
>  	if (!chip)
>  		return;
> +
> +	us = chip->us;
> +
>  #ifdef CONFIG_REALTEK_AUTOPM
>  	if (ss_en) {
>  		del_timer(&chip->rts51x_suspend_timer);

>From linux-next:

drivers/usb/storage/realtek_cr.c: In function 'realtek_cr_destructor':
drivers/usb/storage/realtek_cr.c:942:11: error: 'struct rts51x_chip' has no member named 'us'

chip->us here is only defined when CONFIG_REALTEK_AUTOPM is enabled.
