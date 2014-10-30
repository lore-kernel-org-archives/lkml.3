Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbaJ3Hyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:54:37 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:34886 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbaJ3Hyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:54:36 -0400
Date: Thu, 30 Oct 2014 08:51:27 +0100
From: Johan Hovold <johan@kernel.org>
To: Jim Paris <jim@jtan.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v3] cdc-acm: ensure that termios get set when the port is
 activated
Message-ID: <20141030075127.GC13062@localhost>
References: <20141029150716.GG2265@localhost>
 <1414596640-28555-1-git-send-email-johan@kernel.org>
 <20141029155602.GC17399@kroah.com>
 <20141029155840.GJ2265@localhost>
 <20141030005314.GA6049@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030005314.GA6049@psychosis.jim.sh>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:53:14PM -0400, Jim Paris wrote:
> The driver wasn't properly configuring the hardware for the current
> termios settings under all conditions.  Ensure that termios are
> written to the device when the port is activated.
> 
> Signed-off-by: Jim Paris <jim@jtan.com>
> ---
> 
> Switched to Johan's suggestion of using a prototype rather than moving
> acm_tty_set_termios.  This depends on his patch in order to get proper
> DTR handling.
> 
> Thanks,
> Jim 
> 
> ---
>  drivers/usb/class/cdc-acm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index e934e19f49f5..d2cd1b6d02a7 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -58,6 +58,9 @@ static struct usb_driver acm_driver;
>  static struct tty_driver *acm_tty_driver;
>  static struct acm *acm_table[ACM_TTY_MINORS];
>  
> +static void acm_tty_set_termios(struct tty_struct *tty,
> +				struct ktermios *termios_old);
> +

Nit: Would you mind placing the prototype after all data declarations
(i.e. below acm_table_lock)?

>  static DEFINE_MUTEX(acm_table_lock);

Thanks,
Johan
