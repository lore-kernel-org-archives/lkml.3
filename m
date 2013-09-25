Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3IYNmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:42:16 -0400
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:45587 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3IYNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:42:15 -0400
Message-ID: <1380116535.4503.19.camel@porter.coelho.fi>
Subject: Re: [PATCH] ti-connectivity: add wl1251 firmware and license
From: Luca Coelho <luca@coelho.fi>
To: balbi@ti.com
Cc: ben@decadent.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Pavel Machek <pavel@denx.de>
Date: Wed, 25 Sep 2013 16:42:15 +0300
In-Reply-To: <20130925132359.GE10746@radagast>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
	 <1380107096.4503.8.camel@porter.coelho.fi>
	 <1380107278.4503.9.camel@porter.coelho.fi>
	 <20130925132359.GE10746@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 08:23 -0500, Felipe Balbi wrote:
> On Wed, Sep 25, 2013 at 02:07:58PM +0300, Luca Coelho wrote:
> > On Wed, 2013-09-25 at 14:04 +0300, Luca Coelho wrote:
> > > When sending big binary blobs, it's generally better to send pull
> > > requests instead of patches.  If you add the -p option when calling git
> > > pull-request, the text will include all the readable parts but will omit
> > > the binary stuff.
> > > 
> > > Thank you very much for following up on this!
> > 
> > Ah, and I forgot to say that you should update the WHENCE file
> > accordingly too.  Check the wl12xx and wl18xx drivers for examples.
> 
> I'll send a pull request, but how about this ? I don't think we can
> change the license. It seems like the other firmwares are using the
> older license, I'd argue those should be changed to the new one, but
> that's another discussion.

Cool, in general it looks good!

Though it would be nice to know if the same "new" license could be used
for all the firmwares to avoid almost identical licenses.

More comments below...

> diff --git a/WHENCE b/WHENCE
> index e66fea5..4e9e2ed 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1705,6 +1705,19 @@ Licence: Redistributable. See LICENCE.tda7706-firmware.txt for details.
>  
>  --------------------------------------------------------------------------
>  
> +Driver: wl1251 - Texas Instruments 802.11 WLAN driver for WiLink4 chips
> +
> +File: ti-connectivity/wl1251-fw.bin
> +File: ti-connectivity/wl1251-nvs.bin

Don't you have the firmware version number to add here with "Version:"
tags like the other ones? I think you can easily find the version by
running strings on the binary and grepping for "Rev" (at least with the
newer WiLinks, this works).


> +Licence: See LICENCE.wl1251 for details.
> +
> +The driver expects to find the firmwares under a ti-connectivity subdirectory.
> +So if your system looks for firmwares in /lib/firmware, the firmwares for
> +wl12xx chips must be located in /lib/firmware/ti-connectivity/.

It's a bit stupid that this was never changed in wl1251, but it still
expects the driver in the "root" firmwares directory (ie.
in /lib/firmware/wl1251-fw.bin, not
in /lib/firmware/ti-connectivity/wl1251-fw.bin).  Maybe now is the right
time to change the driver appropriately to keep consistency? ;)

--
Luca.

