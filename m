Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3DSRfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:35:08 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59792 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3DSRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:35:06 -0400
Date: Fri, 19 Apr 2013 10:35:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: storage: Convert US_DEBUGP to usb_stor_dbg
Message-ID: <20130419173503.GA27495@kroah.com>
References: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
 <1366254055.28609.61.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366254055.28609.61.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 08:00:55PM -0700, Joe Perches wrote:
> Use a more current logging style with dev_printk
> where possible.
> 
> o Convert uses of US_DEBUGP to usb_stor_dbg
> o Add "struct us_data *" to usb_stor_dbg uses
> o usb_stor_dbg now uses struct device */dev_vprint_emit
> o Removed embedded function names
> o Coalesce formats
> o Remove trailing whitespace
> o Remove useless OOM messages
> o Remove useless function entry/exit logging
> o Convert some US_DEBUGP uses to dev_info and dev_dbg
> 
> $ size drivers/usb/storage/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  137787	  55520	  68584	 261891	  3ff03	drivers/usb/storage/built-in.o.debug.new
>  140782	  55200	  68904	 264886	  40ab6	drivers/usb/storage/built-in.o.debug.old
>  102709	  54936	  63784	 221429	  360f5	drivers/usb/storage/built-in.o.no_debug.new
>  101506	  54568	  63592	 219666	  35a12	drivers/usb/storage/built-in.o.no_debug.old
> 
> Increase in no_debug size is because some previously
> compiled-out US_DEBUGP are now dev_dbg and are compiled
> in and a couple of US_DEBUGP messages are now dev_info.

With your other patch applied, this one seems to not apply to my tree:

checking file drivers/usb/storage/alauda.c
checking file drivers/usb/storage/cypress_atacb.c
checking file drivers/usb/storage/datafab.c
checking file drivers/usb/storage/debug.c
Hunk #1 FAILED at 42.
Hunk #2 succeeded at 150 (offset 1 line).
Hunk #3 succeeded at 172 (offset 1 line).
1 out of 3 hunks FAILED
checking file drivers/usb/storage/debug.h
checking file drivers/usb/storage/ene_ub6250.c
checking file drivers/usb/storage/freecom.c
checking file drivers/usb/storage/initializers.c
checking file drivers/usb/storage/isd200.c
checking file drivers/usb/storage/jumpshot.c
checking file drivers/usb/storage/karma.c
checking file drivers/usb/storage/option_ms.c
checking file drivers/usb/storage/realtek_cr.c
checking file drivers/usb/storage/scsiglue.c
checking file drivers/usb/storage/sddr09.c
checking file drivers/usb/storage/sddr55.c
checking file drivers/usb/storage/shuttle_usbat.c
checking file drivers/usb/storage/sierra_ms.c
checking file drivers/usb/storage/transport.c
checking file drivers/usb/storage/usb.c

