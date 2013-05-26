Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3EZQvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 12:51:42 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48130 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754217Ab3EZQvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 12:51:41 -0400
Date: Sun, 26 May 2013 18:51:39 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Hector Palacios <hector.palacios@digi.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net
Subject: Re: [PATCH v3] watchdog: core: don't try to stop device if not running
Message-ID: <20130526165139.GA8365@spo001.leaseweb.com>
References: <1365433592-25687-1-git-send-email-hector.palacios@digi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365433592-25687-1-git-send-email-hector.palacios@digi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hector,

> A watchdog device may be stopped from userspace using WDIOC_SETOPTIONS
> ioctl and flag WDIOS_DISABLECARD. If the device is closed after this
> operation, watchdog_release() is called and status bits checked for
> stopping it. Besides, if the device has not been unregistered a critical
> message "watchdog did not stop!" is printed, although the ioctl may have
> successfully stopped it already.
> 
> Without the patch a user application sample code like this will successfully
> stop the watchdog, but the kernel will output the message
> "watchdog did not stop!":
> 
> 	wd_fd = open("/dev/watchdog", O_RDWR);
> 
> 	flags = WDIOS_DISABLECARD;
> 	ioctl(wd_fd, WDIOC_SETOPTIONS, &flags);
> 
> 	close(wd_fd);
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---
> 
> Changes from v1:
>  - Make it less intrusive with 'if/else if' clauses.
>  - Change the logic of 'err' variable for better readability of code.
>  - Remove one-liner if brackets that broke coding sytle.
> Changes from v2:
>  - Revert "Change the logic of 'err'..." from v1 because otherwise the
>    'else if' can't be reached if the watchdog is running.
> 
>  drivers/watchdog/watchdog_dev.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.

