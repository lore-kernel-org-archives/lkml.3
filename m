Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbaJ3OwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:52:08 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:45182 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696AbaJ3OwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:52:06 -0400
Date: Thu, 30 Oct 2014 15:48:58 +0100
From: Johan Hovold <johan@kernel.org>
To: Jim Paris <jim@jtan.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v4] cdc-acm: ensure that termios get set when the port is
 activated
Message-ID: <20141030144858.GG13062@localhost>
References: <20141029150716.GG2265@localhost>
 <1414596640-28555-1-git-send-email-johan@kernel.org>
 <20141029155602.GC17399@kroah.com>
 <20141029155840.GJ2265@localhost>
 <20141030005314.GA6049@psychosis.jim.sh>
 <20141030075127.GC13062@localhost>
 <20141030144538.GA23737@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030144538.GA23737@psychosis.jim.sh>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:45:38AM -0400, Jim Paris wrote:
> The driver wasn't properly configuring the hardware for the current
> termios settings under all conditions.  Ensure that termios are
> written to the device when the port is activated.
> 
> Signed-off-by: Jim Paris <jim@jtan.com>
> ---
> 
> Moved prototype.

You seem to have posted the old version again.

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
>  static DEFINE_MUTEX(acm_table_lock);

Johan
